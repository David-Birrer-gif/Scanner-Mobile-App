import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_mobile_app/features/products/domain/entities/product.dart';
import 'package:scanner_mobile_app/features/products/presentation/widgets/product_tile.dart';

void main() {
  testWidgets('renders product name and expiry', (tester) async {
    final product = Product(
      id: 1,
      barcode: '1234567890123',
      name: 'Milk',
      brand: 'Brand',
      category: 'Dairy',
      quantity: 1,
      expiryDate: DateTime.now().add(const Duration(days: 1)),
      fridgeId: 'default_fridge',
      status: ProductStatus.active,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ProductTile(product: product)),
      ),
    );

    expect(find.text('Milk'), findsOneWidget);
    expect(find.textContaining('Expiry:'), findsOneWidget);
  });
}
