import '../entities/product.dart';

abstract class ProductRepository {
  Stream<List<Product>> watchProducts();
  Future<void> save(Product product);
  Future<void> updateStatus(int id, ProductStatus status);
}
