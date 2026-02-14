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

final productsStreamProvider = StreamProvider<List<Product>>(
  (ref) => ref.watch(getProductsUseCaseProvider).call(),
);

final saveProductControllerProvider = Provider(
  (ref) => SaveProductController(ref),
);

class SaveProductController {
  SaveProductController(this.ref);
  final Ref ref;

  Future<void> saveProduct({
    int? id,
    required String barcode,
    required String name,
    required String brand,
    required String category,
    required int quantity,
    required DateTime expiryDate,
    List<int> reminderDays = const [3, 1],
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

    await ref.read(saveProductUseCaseProvider).call(product);
    await ref
        .read(notificationServiceProvider)
        .scheduleReminders(product: product, daysBefore: reminderDays);
  }
}
