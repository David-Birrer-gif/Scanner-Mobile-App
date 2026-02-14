import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get barcode => text()();
  TextColumn get name => text()();
  TextColumn get brand => text()();
  TextColumn get category => text()();
  IntColumn get quantity => integer()();
  DateTimeColumn get expiryDate => dateTime()();
  TextColumn get fridgeId => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Product>> watchProducts() => select(products).watch();

  Future<void> upsertProduct(ProductsCompanion data) => into(products).insertOnConflictUpdate(data);

  Future<void> setStatus(int id, String status) async {
    await (update(products)..where((tbl) => tbl.id.equals(id))).write(
      ProductsCompanion(status: Value(status)),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'scanner.sqlite'));
    return NativeDatabase(file);
  });
}
