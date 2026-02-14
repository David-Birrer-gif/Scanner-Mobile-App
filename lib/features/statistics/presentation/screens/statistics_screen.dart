import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../products/domain/entities/product.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});
  static const route = '/statistics';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final statsFuture = ref.watch(_statsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(s.t('stats'))),
      body: statsFuture.when(
        data: (stats) {
          final totalDone = stats.statusCounts[ProductStatus.consumed]! + stats.statusCounts[ProductStatus.wasted]!;
          final ratio = totalDone == 0 ? 0.0 : stats.statusCounts[ProductStatus.wasted]! / totalDone;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatCard(label: 'Total active', value: '${stats.statusCounts[ProductStatus.active]}'),
              _StatCard(label: s.t('consumed'), value: '${stats.statusCounts[ProductStatus.consumed]}'),
              _StatCard(label: s.t('wasted'), value: '${stats.statusCounts[ProductStatus.wasted]}'),
              _StatCard(label: 'Waste ratio', value: '${(ratio * 100).toStringAsFixed(1)}%'),
              const SizedBox(height: 12),
              const Text('By category'),
              ...stats.categories.map((c) => ListTile(
                    title: Text(c.category),
                    subtitle: Text('total: ${c.total} / wasted: ${c.wasted}'),
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _StatsVm {
  const _StatsVm({required this.statusCounts, required this.categories});

  final Map<ProductStatus, int> statusCounts;
  final List<CategoryStat> categories;
}

final _statsProvider = FutureProvider<_StatsVm>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return _StatsVm(
    statusCounts: await repo.getStatusCounts(),
    categories: await repo.getCategoryStats(),
  );
});

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
