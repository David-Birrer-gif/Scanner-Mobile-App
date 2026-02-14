enum ProductStatus { active, consumed, wasted }

class Product {
  const Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.brand,
    required this.category,
    required this.quantity,
    required this.expiryDate,
    required this.fridgeId,
    required this.status,
    required this.createdAt,
  });

  final int? id;
  final String barcode;
  final String name;
  final String brand;
  final String category;
  final int quantity;
  final DateTime expiryDate;
  final String fridgeId;
  final ProductStatus status;
  final DateTime createdAt;

  Product copyWith({
    int? id,
    String? barcode,
    String? name,
    String? brand,
    String? category,
    int? quantity,
    DateTime? expiryDate,
    String? fridgeId,
    ProductStatus? status,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      expiryDate: expiryDate ?? this.expiryDate,
      fridgeId: fridgeId ?? this.fridgeId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
