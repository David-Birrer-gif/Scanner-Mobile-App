import '../repositories/product_repository.dart';

class GetEffectiveReminderRulesUseCase {
  GetEffectiveReminderRulesUseCase(this._repository);

  final ProductRepository _repository;

  Future<List<int>> call(int productId) async {
    final overrides = await _repository.getProductReminderOverrides(productId);
    if (overrides != null && overrides.isNotEmpty) {
      final sorted = [...overrides]..sort((a, b) => b.compareTo(a));
      return sorted;
    }
    final global = await _repository.getGlobalReminderOffsets();
    final sorted = [...global]..sort((a, b) => b.compareTo(a));
    return sorted;
  }
}
