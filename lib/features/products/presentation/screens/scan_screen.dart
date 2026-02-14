import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/l10n/app_strings.dart';
import '../providers/product_providers.dart';
import 'add_edit_product_screen.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});
  static const route = '/scan';

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool _handled = false;

  @override
  Widget build(BuildContext context) {
    final prefillState = ref.watch(scannedPrefillProvider);
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.t('scan'))),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                if (_handled) return;
                final barcode = capture.barcodes.firstOrNull?.rawValue;
                if (barcode == null || barcode.length != 13) return;
                _handled = true;
                ref.read(scannedPrefillProvider.notifier).resolveBarcode(barcode);
              },
            ),
          ),
          prefillState.when(
            data: (prefill) {
              if (prefill == null) return const SizedBox.shrink();
              return ListTile(
                title: Text(prefill.found ? 'Product found' : 'Unknown barcode'),
                subtitle: Text('${prefill.name} ${prefill.brand}'),
                trailing: FilledButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, AddEditProductScreen.route);
                    if (mounted) setState(() => _handled = false);
                  },
                  child: const Text('Continue'),
                ),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Scan error: $e'),
            ),
          ),
        ],
      ),
    );
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
