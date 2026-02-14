import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../notifications/presentation/reminder_settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  static const route = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderDays = ref.watch(reminderDaysProvider);
    final locale = ref.watch(appLocaleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(title: Text('Reminder rules (days before expiry)')),
          Wrap(
            spacing: 8,
            children: [1, 2, 3, 5, 7]
                .map(
                  (day) => FilterChip(
                    label: Text('$day'),
                    selected: reminderDays.contains(day),
                    onSelected: (selected) {
                      final next = [...reminderDays];
                      if (selected) {
                        next.add(day);
                      } else {
                        next.remove(day);
                      }
                      ref.read(reminderDaysProvider.notifier).state = next..sort();
                    },
                  ),
                )
                .toList(),
          ),
          const Divider(),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(locale.languageCode.toUpperCase()),
            trailing: DropdownButton<Locale>(
              value: locale,
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('EN')),
                DropdownMenuItem(value: Locale('de'), child: Text('DE')),
              ],
              onChanged: (newLocale) {
                if (newLocale != null) {
                  ref.read(appLocaleProvider.notifier).state = newLocale;
                }
              },
            ),
          ),
          const ListTile(
            title: Text('TODO'),
            subtitle: Text('Add background daily check with workmanager/alarm manager.'),
          ),
        ],
      ),
    );
  }
}
