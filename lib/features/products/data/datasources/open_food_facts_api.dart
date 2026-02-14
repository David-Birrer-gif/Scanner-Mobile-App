import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/product_model.dart';

class OpenFoodFactsApi {
  OpenFoodFactsApi(this._dio);

  final Dio _dio;

  Future<ProductPrefill> fetchProduct(String barcode) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${AppConstants.openFoodFactsBaseUrl}/product/$barcode',
      );
      final body = response.data;
      if (body == null || body['status'] != 1) {
        return ProductPrefill.manual(barcode);
      }
      final product = (body['product'] as Map<String, dynamic>? ?? {});
      return ProductPrefill(
        barcode: barcode,
        name: (product['product_name'] ?? '').toString(),
        brand: (product['brands'] ?? '').toString(),
        category: (product['categories'] ?? '').toString(),
        found: true,
      );
    } catch (_) {
      return ProductPrefill.manual(barcode);
    }
  }
}
