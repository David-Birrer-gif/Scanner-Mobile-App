import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
    this.onConsumed,
    this.onWasted,
    this.onEdit,
  });

  final Product product;
  final VoidCallback? onConsumed;
  final VoidCallback? onWasted;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final daysLeft = product.expiryDate.difference(DateTime.now()).inDays;
    final expired = daysLeft < 0;
    final expiringSoon = daysLeft >= 0 && daysLeft <= 3;
    final color = expired
        ? Colors.red.shade100
        : expiringSoon
            ? Colors.orange.shade100
            : Colors.green.shade50;

    return Card(
      color: color,
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(
          '${product.brand} • ${product.category} • x${product.quantity}\n'
          'Expiry: ${product.expiryDate.toLocal().toString().split(' ').first}',
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            if (onConsumed != null) IconButton(onPressed: onConsumed, icon: const Icon(Icons.check_circle)),
            if (onWasted != null) IconButton(onPressed: onWasted, icon: const Icon(Icons.delete_outline)),
            if (onEdit != null) IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined)),
          ],
        ),
      ),
    );
  }
}
