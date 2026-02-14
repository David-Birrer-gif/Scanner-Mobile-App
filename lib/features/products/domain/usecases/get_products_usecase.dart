import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  GetProductsUseCase(this.repository);
  final ProductRepository repository;

  Stream<List<Product>> call() => repository.watchProducts();
}
