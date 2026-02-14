import '../../../notifications/data/notification_orchestrator.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpsertProductUseCase {
  UpsertProductUseCase(this._repository, this._orchestrator);

  final ProductRepository _repository;
  final NotificationOrchestrator _orchestrator;

  Future<int> call(Product product, {List<int>? customOffsets}) async {
    final id = await _repository.upsert(product);
    await _repository.saveProductReminderOverrides(id, customOffsets);
    await _orchestrator.rescheduleForProductId(id);
    return id;
  }
}
