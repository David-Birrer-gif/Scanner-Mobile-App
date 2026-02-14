import '../../../notifications/data/notification_orchestrator.dart';
import '../repositories/product_repository.dart';

class DeleteProductUseCase {
  DeleteProductUseCase(this._repository, this._orchestrator);

  final ProductRepository _repository;
  final NotificationOrchestrator _orchestrator;

  Future<void> call(int productId) async {
    await _orchestrator.cancelForProduct(productId);
    await _repository.delete(productId);
  }
}
