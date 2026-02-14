import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../products/domain/entities/product.dart';
import '../../../products/presentation/providers/product_providers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});
  static const route = '/statistics';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: products.when(
        data: (list) {
          final consumed = list.where((p) => p.status == ProductStatus.consumed).length;
          final wasted = list.where((p) => p.status == ProductStatus.wasted).length;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatCard(label: 'Total products', value: list.length.toString()),
              _StatCard(label: 'Consumed', value: consumed.toString()),
              _StatCard(label: 'Wasted', value: wasted.toString()),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(value, style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
