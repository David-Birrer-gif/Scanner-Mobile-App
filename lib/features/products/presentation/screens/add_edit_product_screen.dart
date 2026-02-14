import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../../../core/utils/date_parser.dart';
import '../../data/models/product_model.dart';
import '../providers/product_providers.dart';

class AddEditProductScreen extends ConsumerStatefulWidget {
  const AddEditProductScreen({super.key});
  static const route = '/add-edit-product';

  @override
  ConsumerState<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends ConsumerState<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _barcode = TextEditingController();
  final _name = TextEditingController();
  final _brand = TextEditingController();
  final _category = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 7));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final prefill = ref.read(scannedPrefillProvider).valueOrNull;
    if (prefill != null && _barcode.text.isEmpty) {
      _setPrefill(prefill);
    }
  }

  void _setPrefill(ProductPrefill prefill) {
    _barcode.text = prefill.barcode;
    _name.text = prefill.name;
    _brand.text = prefill.brand;
    _category.text = prefill.category;
  }

  Future<void> _detectDateWithOcr() async {
    // TODO: wire camera/gallery picker and create InputImage from captured file.
    // ML Kit recognizer is initialized now so only capture plumbing is missing.
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    recognizer.close();
    final parsed = parseDateFromText('EXP 24.11.2026');
    if (parsed != null) {
      setState(() => _expiryDate = parsed);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OCR demo parsed sample date. Connect camera input next.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add product')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _barcode, decoration: const InputDecoration(labelText: 'Barcode')),
            TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
            TextFormField(controller: _brand, decoration: const InputDecoration(labelText: 'Brand')),
            TextFormField(controller: _category, decoration: const InputDecoration(labelText: 'Category')),
            TextFormField(
              controller: _quantity,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Expiry: ${_expiryDate.toLocal().toString().split(' ').first}'),
              trailing: Wrap(
                spacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                        initialDate: _expiryDate,
                      );
                      if (picked != null) setState(() => _expiryDate = picked);
                    },
                    child: const Text('Pick date'),
                  ),
                  OutlinedButton(
                    onPressed: _detectDateWithOcr,
                    child: const Text('OCR'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                await ref.read(saveProductControllerProvider).saveProduct(
                      barcode: _barcode.text,
                      name: _name.text,
                      brand: _brand.text,
                      category: _category.text,
                      quantity: int.tryParse(_quantity.text) ?? 1,
                      expiryDate: _expiryDate,
                    );
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Save product'),
            ),
          ],
        ),
      ),
    );
  }
}
