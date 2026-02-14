import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/app_database.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<Product>> watchProducts() {
    return _database.watchProducts().map(
          (rows) => rows
              .map(
                (row) => Product(
                  id: row.id,
                  barcode: row.barcode,
                  name: row.name,
                  brand: row.brand,
                  category: row.category,
                  quantity: row.quantity,
                  expiryDate: row.expiryDate,
                  fridgeId: row.fridgeId,
                  status: ProductStatusX.fromValue(row.status),
                  createdAt: row.createdAt,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<void> save(Product product) {
    return _database.upsertProduct(
      ProductsCompanion(
        id: product.id == null ? const Value.absent() : Value(product.id!),
        barcode: Value(product.barcode),
        name: Value(product.name),
        brand: Value(product.brand),
        category: Value(product.category),
        quantity: Value(product.quantity),
        expiryDate: Value(product.expiryDate),
        fridgeId: Value(product.fridgeId),
        status: Value(product.status.value),
        createdAt: Value(product.createdAt),
      ),
    );
  }

  @override
  Future<void> updateStatus(int id, ProductStatus status) {
    return _database.setStatus(id, status.value);
  }
}
