import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../notifications/presentation/reminder_settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  static const route = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final reminderState = ref.watch(reminderSettingsControllerProvider);
    final locale = ref.watch(appLocaleProvider);
    return Scaffold(
      appBar: AppBar(title: Text(s.t('settings'))),
      body: reminderState.when(
        data: (days) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Global reminder offsets (days before expiry)'),
            Wrap(
              spacing: 8,
              children: days
                  .map(
                    (d) => InputChip(
                      label: Text('$d'),
                      onDeleted: () {
                        final next = [...days]..remove(d);
                        ref.read(reminderSettingsControllerProvider.notifier).save(next);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                final value = await _showOffsetDialog(context);
                if (value == null) return;
                final next = [...days, value]..sort((a, b) => b.compareTo(a));
                ref.read(reminderSettingsControllerProvider.notifier).save(next);
              },
              child: const Text('Add offset'),
            ),
            const Divider(height: 32),
            ListTile(
              title: const Text('Language'),
              trailing: DropdownButton<Locale>(
                value: locale,
                items: const [
                  DropdownMenuItem(value: Locale('en'), child: Text('EN')),
                  DropdownMenuItem(value: Locale('de'), child: Text('DE')),
                ],
                onChanged: (next) {
                  if (next != null) ref.read(appLocaleProvider.notifier).state = next;
                },
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<int?> _showOffsetDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add reminder offset'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Days'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, int.tryParse(controller.text.trim())),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
