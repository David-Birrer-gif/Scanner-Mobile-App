import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_providers.dart';
import '../widgets/product_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Fridge Items')),
      body: products.when(
        data: (list) {
          final sorted = [...list]
            ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
          if (sorted.isEmpty) {
            return const Center(child: Text('No products yet. Start scanning.'));
          }
          return ListView.builder(
            itemCount: sorted.length,
            itemBuilder: (_, i) => ProductTile(product: sorted[i]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-edit-product'),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }
}
