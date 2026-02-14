import '../../../notifications/data/notification_orchestrator.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductStatusUseCase {
  UpdateProductStatusUseCase(this._repository, this._orchestrator);

  final ProductRepository _repository;
  final NotificationOrchestrator _orchestrator;

  Future<void> call(int id, ProductStatus status) async {
    await _repository.updateStatus(id, status);
    if (status != ProductStatus.active) {
      await _orchestrator.cancelForProduct(id);
    } else {
      await _orchestrator.rescheduleForProductId(id);
    }
  }
}
