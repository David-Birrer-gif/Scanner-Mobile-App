import '../../domain/entities/product.dart';

class ProductPrefill {
  const ProductPrefill({
    required this.barcode,
    required this.name,
    required this.brand,
    required this.category,
    required this.found,
  });

  final String barcode;
  final String name;
  final String brand;
  final String category;
  final bool found;

  factory ProductPrefill.manual(String barcode) => ProductPrefill(
        barcode: barcode,
        name: '',
        brand: '',
        category: '',
        found: false,
      );
}

extension ProductStatusX on ProductStatus {
  String get value => name;

  static ProductStatus fromValue(String value) {
    return ProductStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => ProductStatus.active,
    );
  }
}
