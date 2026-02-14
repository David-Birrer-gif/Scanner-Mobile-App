import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final days = product.expiryDate.difference(DateTime.now()).inDays;
    final color = days < 0
        ? Colors.red
        : days <= 2
            ? Colors.orange
            : Colors.green;

    return Card(
      child: ListTile(
        title: Text(product.name.isEmpty ? product.barcode : product.name),
        subtitle: Text(
          '${product.brand} • ${DateFormat.yMd().format(product.expiryDate)} • qty ${product.quantity}',
        ),
        trailing: Chip(
          label: Text(days < 0 ? 'Expired' : '$days d'),
          backgroundColor: color.withOpacity(0.15),
        ),
      ),
    );
  }
}
