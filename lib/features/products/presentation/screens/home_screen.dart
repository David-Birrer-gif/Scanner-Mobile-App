import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../domain/entities/product.dart';
import '../providers/product_providers.dart';
import '../widgets/product_tile.dart';
import 'add_edit_product_screen.dart';

enum HomeFilter { all, expiring, expired, category }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  HomeFilter filter = HomeFilter.all;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.t('home'))),
      body: Column(
        children: [
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(label: Text(s.t('all')), selected: filter == HomeFilter.all, onSelected: (_) => setState(() => filter = HomeFilter.all)),
              ChoiceChip(label: Text(s.t('expiring')), selected: filter == HomeFilter.expiring, onSelected: (_) => setState(() => filter = HomeFilter.expiring)),
              ChoiceChip(label: Text(s.t('expired')), selected: filter == HomeFilter.expired, onSelected: (_) => setState(() => filter = HomeFilter.expired)),
              ChoiceChip(label: Text(s.t('byCategory')), selected: filter == HomeFilter.category, onSelected: (_) => setState(() => filter = HomeFilter.category)),
            ],
          ),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AddEditProductScreen.route),
        icon: const Icon(Icons.add),
        label: Text(s.t('addProduct')),
      ),
    );
  }

  Widget _buildBody() {
    switch (filter) {
      case HomeFilter.expiring:
        return _productsList(ref.watch(expiringSoonProvider));
      case HomeFilter.expired:
        return _productsList(ref.watch(expiredProductsProvider));
      case HomeFilter.category:
        final grouped = ref.watch(categoryGroupedProvider);
        return grouped.when(
          data: (map) => ListView(
            children: map.entries
                .map(
                  (entry) => ExpansionTile(
                    title: Text(entry.key),
                    children: entry.value.map((product) => _tile(product)).toList(),
                  ),
                )
                .toList(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        );
      case HomeFilter.all:
        final all = ref.watch(activeProductsProvider);
        return all.when(
          data: (list) => ListView(children: list.map(_tile).toList()),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        );
    }
  }

  Widget _productsList(AsyncValue<List<Product>> state) {
    return state.when(
      data: (list) => ListView(children: list.map(_tile).toList()),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _tile(Product product) {
    return ProductTile(
      product: product,
      onConsumed: product.id == null
          ? null
          : () => ref.read(saveProductControllerProvider).markStatus(product.id!, ProductStatus.consumed),
      onWasted: product.id == null
          ? null
          : () => ref.read(saveProductControllerProvider).markStatus(product.id!, ProductStatus.wasted),
      onEdit: () => Navigator.pushNamed(context, AddEditProductScreen.route, arguments: product),
    );
  }
}
