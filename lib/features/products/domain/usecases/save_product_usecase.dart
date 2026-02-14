import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SaveProductUseCase {
  SaveProductUseCase(this.repository);
  final ProductRepository repository;

  Future<void> call(Product product) => repository.save(product);
}
