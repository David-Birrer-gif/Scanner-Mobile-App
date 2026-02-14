import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/providers.dart';
import '../../data/models/product_model.dart';
import '../../domain/entities/product.dart';

final scannedBarcodeProvider = StateProvider<String?>((_) => null);

final scannedPrefillProvider =
    StateNotifierProvider<ScannedPrefillController, AsyncValue<ProductPrefill?>>(
  (ref) => ScannedPrefillController(ref),
);

class ScannedPrefillController extends StateNotifier<AsyncValue<ProductPrefill?>> {
  ScannedPrefillController(this.ref) : super(const AsyncData(null));

  final Ref ref;

  Future<void> resolveBarcode(String barcode) async {
    state = const AsyncLoading();
    final prefill = await ref.read(foodApiProvider).fetchProduct(barcode);
    ref.read(scannedBarcodeProvider.notifier).state = barcode;
    state = AsyncData(prefill);
  }
}

final allProductsProvider = StreamProvider<List<Product>>(
  (ref) => ref.watch(getProductsUseCaseProvider).call(),
);

final activeProductsProvider = StreamProvider<List<Product>>(
  (ref) => ref.watch(getProductsUseCaseProvider).call(activeOnly: true),
);

final expiringSoonProvider = FutureProvider<List<Product>>((ref) async {
  return ref.watch(productRepositoryProvider).getExpiringSoon(days: 3);
});

final expiredProductsProvider = FutureProvider<List<Product>>((ref) async {
  return ref.watch(productRepositoryProvider).getExpired();
});

final categoryGroupedProvider = FutureProvider<Map<String, List<Product>>>((ref) async {
  final products = await ref.watch(productRepositoryProvider).getActiveProducts();
  final grouped = <String, List<Product>>{};
  for (final product in products) {
    grouped.putIfAbsent(product.category, () => []).add(product);
  }
  return grouped;
});

class SaveProductController {
  SaveProductController(this.ref);
  final Ref ref;

  Future<int> saveProduct({
    int? id,
    required String barcode,
    required String name,
    required String brand,
    required String category,
    required int quantity,
    required DateTime expiryDate,
    List<int>? customReminderOffsets,
  }) async {
    final product = Product(
      id: id,
      barcode: barcode,
      name: name,
      brand: brand,
      category: category,
      quantity: quantity,
      expiryDate: expiryDate,
      fridgeId: AppConstants.fridgeId,
      status: ProductStatus.active,
      createdAt: DateTime.now(),
    );
    return ref.read(upsertProductUseCaseProvider).call(product, customOffsets: customReminderOffsets);
  }

  Future<void> deleteProduct(int id) async {
    await ref.read(deleteProductUseCaseProvider).call(id);
  }

  Future<void> markStatus(int id, ProductStatus status) async {
    await ref.read(updateProductStatusUseCaseProvider).call(id, status);
  }
}

final saveProductControllerProvider = Provider((ref) => SaveProductController(ref));
