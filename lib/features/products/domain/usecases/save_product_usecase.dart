import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SaveProductUseCase {
  SaveProductUseCase(this.repository);
  final ProductRepository repository;

  Future<int> call(Product product) => repository.upsert(product);
}
