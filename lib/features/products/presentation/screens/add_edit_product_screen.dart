import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/date_parser.dart';
import '../../domain/entities/product.dart';
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
  final _customOffsets = TextEditingController();
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 7));
  bool _useCustomReminder = false;
  int? _editingId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scanned = ref.read(scannedPrefillProvider).valueOrNull;
    if (_barcode.text.isNotEmpty) return;
    final editing = ModalRoute.of(context)?.settings.arguments;
    if (editing is Product) {
      _editingId = editing.id;
      _barcode.text = editing.barcode;
      _name.text = editing.name;
      _brand.text = editing.brand;
      _category.text = editing.category;
      _quantity.text = '${editing.quantity}';
      _expiryDate = editing.expiryDate;
      return;
    }
    if (scanned != null) {
      _barcode.text = scanned.barcode;
      _name.text = scanned.name;
      _brand.text = scanned.brand;
      _category.text = scanned.category;
    }
  }

  @override
  void dispose() {
    _barcode.dispose();
    _name.dispose();
    _brand.dispose();
    _category.dispose();
    _quantity.dispose();
    _customOffsets.dispose();
    super.dispose();
  }

  Future<void> _detectDateWithOcr() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null || !mounted) return;

    final inputImage = InputImage.fromFilePath(image.path);
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognized = await recognizer.processImage(inputImage);
    await recognizer.close();

    final candidates = DateParser.extractDates(recognized.text);
    if (candidates.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No date found')));
      return;
    }

    DateTime? selected;
    if (candidates.length == 1) {
      selected = candidates.first.date;
    } else {
      selected = await showDialog<DateTime>(
        context: context,
        builder: (_) => SimpleDialog(
          title: const Text('Select detected date'),
          children: candidates
              .map(
                (candidate) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, candidate.date),
                  child: Text(candidate.original),
                ),
              )
              .toList(),
        ),
      );
    }

    if (selected == null || !mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Use this date?'),
        content: Text(selected!.toLocal().toString().split(' ').first),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _expiryDate = selected!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.t('addProduct'))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _barcode, decoration: const InputDecoration(labelText: 'Barcode')),
            TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name'), validator: _required),
            TextFormField(controller: _brand, decoration: const InputDecoration(labelText: 'Brand')),
            TextFormField(controller: _category, decoration: const InputDecoration(labelText: 'Category')),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantity,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    final q = (int.tryParse(_quantity.text) ?? 1) - 1;
                    _quantity.text = '${q < 1 ? 1 : q}';
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final q = (int.tryParse(_quantity.text) ?? 1) + 1;
                    _quantity.text = '$q';
                  },
                ),
              ],
            ),
            ListTile(
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
                    child: Text(s.t('pickDate')),
                  ),
                  OutlinedButton(onPressed: _detectDateWithOcr, child: Text(s.t('scanExpiryDate'))),
                ],
              ),
            ),
            SwitchListTile(
              value: _useCustomReminder,
              onChanged: (v) => setState(() => _useCustomReminder = v),
              title: const Text('Use custom reminder offsets (e.g. 5,2,0)'),
            ),
            if (_useCustomReminder)
              TextField(
                controller: _customOffsets,
                decoration: const InputDecoration(labelText: 'Custom reminder offsets'),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                final offsets = _useCustomReminder
                    ? _customOffsets.text
                        .split(',')
                        .map((e) => int.tryParse(e.trim()))
                        .whereType<int>()
                        .toList()
                    : null;
                await ref.read(saveProductControllerProvider).saveProduct(
                      id: _editingId,
                      barcode: _barcode.text,
                      name: _name.text,
                      brand: _brand.text,
                      category: _category.text,
                      quantity: int.tryParse(_quantity.text) ?? 1,
                      expiryDate: _expiryDate,
                      customReminderOffsets: offsets,
                    );
                if (mounted) Navigator.pop(context);
              },
              child: Text(s.t('save')),
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) => (value == null || value.trim().isEmpty) ? 'Required' : null;
}
