import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../notifications/domain/reminder_rule.dart';
import '../../domain/entities/product.dart';

class AppDatabase extends DatabaseConnectionUser {
  AppDatabase() : super(DatabaseConnection.fromExecutor(_openConnection())) {
    _init();
  }

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'scanner.sqlite'));
      return NativeDatabase(file);
    });
  }

  Future<void> _init() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcode TEXT NOT NULL,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        category TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        expiry_date INTEGER NOT NULL,
        fridge_id TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at INTEGER NOT NULL
      );
    ''');
    await customStatement('''
      CREATE TABLE IF NOT EXISTS reminder_rules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        offset_days INTEGER NOT NULL UNIQUE
      );
    ''');
    await customStatement('''
      CREATE TABLE IF NOT EXISTS product_reminder_overrides (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        offset_days INTEGER NOT NULL,
        FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
      );
    ''');
    await customStatement('''
      CREATE TABLE IF NOT EXISTS scheduled_notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        notification_id INTEGER NOT NULL,
        scheduled_at INTEGER NOT NULL,
        offset_days INTEGER NOT NULL,
        FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
      );
    ''');
    final hasRules = await customSelect('SELECT COUNT(*) AS c FROM reminder_rules').getSingle();
    if ((hasRules.data['c'] as int? ?? 0) == 0) {
      await saveGlobalReminderOffsets([3, 1, 0]);
    }
  }

  Stream<List<Product>> watchProducts({bool activeOnly = false}) {
    final filter = activeOnly ? "WHERE status = 'active'" : '';
    return customSelect('SELECT * FROM products $filter ORDER BY expiry_date ASC')
        .watch()
        .map((rows) => rows.map(_mapProduct).toList());
  }

  Future<List<Product>> getAllProducts() async {
    final rows = await customSelect('SELECT * FROM products ORDER BY expiry_date ASC').get();
    return rows.map(_mapProduct).toList();
  }

  Future<List<Product>> getActiveProducts() async {
    final rows = await customSelect("SELECT * FROM products WHERE status = 'active' ORDER BY expiry_date ASC")
        .get();
    return rows.map(_mapProduct).toList();
  }

  Future<List<Product>> getExpiringSoon(int days) async {
    final deadline = DateTime.now().add(Duration(days: days)).millisecondsSinceEpoch;
    final rows = await customSelect(
      "SELECT * FROM products WHERE status = 'active' AND expiry_date <= ? ORDER BY expiry_date ASC",
      variables: [Variable.withInt(deadline)],
    ).get();
    return rows.map(_mapProduct).toList();
  }

  Future<List<Product>> getExpired() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final rows = await customSelect(
      "SELECT * FROM products WHERE status = 'active' AND expiry_date < ? ORDER BY expiry_date ASC",
      variables: [Variable.withInt(now)],
    ).get();
    return rows.map(_mapProduct).toList();
  }

  Future<int> upsertProduct(Product product) async {
    if (product.id != null) {
      await customStatement(
        'UPDATE products SET barcode=?, name=?, brand=?, category=?, quantity=?, expiry_date=?, fridge_id=?, status=?, created_at=? WHERE id=?',
        [
          product.barcode,
          product.name,
          product.brand,
          product.category,
          product.quantity,
          product.expiryDate.millisecondsSinceEpoch,
          product.fridgeId,
          product.status.name,
          product.createdAt.millisecondsSinceEpoch,
          product.id,
        ],
      );
      return product.id!;
    }
    await customStatement(
      'INSERT INTO products (barcode,name,brand,category,quantity,expiry_date,fridge_id,status,created_at) VALUES (?,?,?,?,?,?,?,?,?)',
      [
        product.barcode,
        product.name,
        product.brand,
        product.category,
        product.quantity,
        product.expiryDate.millisecondsSinceEpoch,
        product.fridgeId,
        product.status.name,
        product.createdAt.millisecondsSinceEpoch,
      ],
    );
    final row = await customSelect('SELECT last_insert_rowid() AS id').getSingle();
    return row.data['id'] as int;
  }

  Future<Product?> getProductById(int productId) async {
    final rows = await customSelect('SELECT * FROM products WHERE id = ?', variables: [Variable.withInt(productId)])
        .get();
    if (rows.isEmpty) return null;
    return _mapProduct(rows.first);
  }

  Future<void> deleteProduct(int id) async {
    await customStatement('DELETE FROM products WHERE id = ?', [id]);
    await deleteScheduledNotifications(id);
    await saveProductReminderOverrides(id, null);
  }

  Future<void> setStatus(int id, ProductStatus status) async {
    await customStatement('UPDATE products SET status=? WHERE id=?', [status.name, id]);
  }

  Future<Map<ProductStatus, int>> getStatusCounts() async {
    final rows = await customSelect('SELECT status, COUNT(*) AS c FROM products GROUP BY status').get();
    final result = <ProductStatus, int>{
      ProductStatus.active: 0,
      ProductStatus.consumed: 0,
      ProductStatus.wasted: 0,
    };
    for (final row in rows) {
      final status = ProductStatus.values.firstWhere(
        (value) => value.name == row.data['status'],
        orElse: () => ProductStatus.active,
      );
      result[status] = row.data['c'] as int? ?? 0;
    }
    return result;
  }

  Future<List<CategoryStat>> getCategoryStats() async {
    final rows = await customSelect('''
      SELECT category,
             COUNT(*) as total,
             SUM(CASE WHEN status = 'wasted' THEN 1 ELSE 0 END) as wasted
      FROM products
      GROUP BY category
      ORDER BY total DESC;
    ''').get();
    return rows
        .map(
          (row) => CategoryStat(
            category: row.data['category'] as String,
            total: row.data['total'] as int? ?? 0,
            wasted: row.data['wasted'] as int? ?? 0,
          ),
        )
        .toList();
  }

  Future<List<int>> getGlobalReminderOffsets() async {
    final rows = await customSelect('SELECT offset_days FROM reminder_rules ORDER BY offset_days DESC').get();
    return rows.map((row) => row.data['offset_days'] as int).toList();
  }

  Future<void> saveGlobalReminderOffsets(List<int> offsets) async {
    await customStatement('DELETE FROM reminder_rules');
    for (final offset in offsets.toSet()) {
      await customStatement('INSERT INTO reminder_rules(offset_days) VALUES (?)', [offset]);
    }
  }

  Future<List<int>?> getProductReminderOverrides(int productId) async {
    final rows = await customSelect(
      'SELECT offset_days FROM product_reminder_overrides WHERE product_id = ? ORDER BY offset_days DESC',
      variables: [Variable.withInt(productId)],
    ).get();
    if (rows.isEmpty) return null;
    return rows.map((row) => row.data['offset_days'] as int).toList();
  }

  Future<void> saveProductReminderOverrides(int productId, List<int>? offsets) async {
    await customStatement('DELETE FROM product_reminder_overrides WHERE product_id = ?', [productId]);
    if (offsets == null || offsets.isEmpty) return;
    for (final offset in offsets.toSet()) {
      await customStatement(
        'INSERT INTO product_reminder_overrides(product_id, offset_days) VALUES (?, ?)',
        [productId, offset],
      );
    }
  }

  Future<List<ReminderSchedule>> getScheduledNotifications(int productId) async {
    final rows = await customSelect(
      'SELECT notification_id, scheduled_at, offset_days FROM scheduled_notifications WHERE product_id = ?',
      variables: [Variable.withInt(productId)],
    ).get();
    return rows
        .map(
          (row) => ReminderSchedule(
            notificationId: row.data['notification_id'] as int,
            scheduledAt: DateTime.fromMillisecondsSinceEpoch(row.data['scheduled_at'] as int),
            offsetDays: row.data['offset_days'] as int,
          ),
        )
        .toList();
  }

  Future<void> saveScheduledNotifications(int productId, List<ReminderSchedule> schedules) async {
    await deleteScheduledNotifications(productId);
    for (final schedule in schedules) {
      await customStatement(
        'INSERT INTO scheduled_notifications(product_id, notification_id, scheduled_at, offset_days) VALUES (?, ?, ?, ?)',
        [
          productId,
          schedule.notificationId,
          schedule.scheduledAt.millisecondsSinceEpoch,
          schedule.offsetDays,
        ],
      );
    }
  }

  Future<void> deleteScheduledNotifications(int productId) async {
    await customStatement('DELETE FROM scheduled_notifications WHERE product_id = ?', [productId]);
  }

  Product _mapProduct(QueryRow row) {
    return Product(
      id: row.data['id'] as int,
      barcode: row.data['barcode'] as String,
      name: row.data['name'] as String,
      brand: row.data['brand'] as String,
      category: row.data['category'] as String,
      quantity: row.data['quantity'] as int,
      expiryDate: DateTime.fromMillisecondsSinceEpoch(row.data['expiry_date'] as int),
      fridgeId: row.data['fridge_id'] as String,
      status: ProductStatus.values.firstWhere(
        (status) => status.name == row.data['status'],
        orElse: () => ProductStatus.active,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.data['created_at'] as int),
    );
  }
}
