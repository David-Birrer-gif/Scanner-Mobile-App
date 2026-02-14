import '../../../notifications/domain/reminder_rule.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/app_database.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<Product>> watchProducts({bool activeOnly = false}) {
    return _database.watchProducts(activeOnly: activeOnly);
  }

  @override
  Future<int> upsert(Product product) => _database.upsertProduct(product);

  @override
  Future<void> delete(int id) => _database.deleteProduct(id);

  @override
  Future<void> updateStatus(int id, ProductStatus status) => _database.setStatus(id, status);

  @override
  Future<List<int>> getGlobalReminderOffsets() => _database.getGlobalReminderOffsets();

  @override
  Future<void> saveGlobalReminderOffsets(List<int> offsets) =>
      _database.saveGlobalReminderOffsets(offsets);

  @override
  Future<List<int>?> getProductReminderOverrides(int productId) =>
      _database.getProductReminderOverrides(productId);

  @override
  Future<void> saveProductReminderOverrides(int productId, List<int>? offsets) =>
      _database.saveProductReminderOverrides(productId, offsets);

  @override
  Future<void> saveScheduledNotifications(int productId, List<ReminderSchedule> schedules) =>
      _database.saveScheduledNotifications(productId, schedules);

  @override
  Future<List<ReminderSchedule>> getScheduledNotifications(int productId) =>
      _database.getScheduledNotifications(productId);

  @override
  Future<void> deleteScheduledNotifications(int productId) =>
      _database.deleteScheduledNotifications(productId);

  @override
  Future<List<Product>> getActiveProducts() => _database.getActiveProducts();

  @override
  Future<List<Product>> getExpiringSoon({required int days}) => _database.getExpiringSoon(days);

  @override
  Future<List<Product>> getExpired() => _database.getExpired();

  @override
  Future<Map<ProductStatus, int>> getStatusCounts() => _database.getStatusCounts();

  @override
  Future<List<CategoryStat>> getCategoryStats() => _database.getCategoryStats();
}
