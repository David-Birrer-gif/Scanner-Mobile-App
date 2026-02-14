import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';

final reminderDaysProvider = FutureProvider<List<int>>(
  (ref) => ref.watch(productRepositoryProvider).getGlobalReminderOffsets(),
);

class ReminderSettingsController extends StateNotifier<AsyncValue<List<int>>> {
  ReminderSettingsController(this.ref) : super(const AsyncLoading()) {
    _load();
  }

  final Ref ref;

  Future<void> _load() async {
    state = AsyncData(await ref.read(productRepositoryProvider).getGlobalReminderOffsets());
  }

  Future<void> save(List<int> offsets) async {
    final sorted = offsets.toSet().toList()..sort((a, b) => b.compareTo(a));
    await ref.read(productRepositoryProvider).saveGlobalReminderOffsets(sorted);
    await ref.read(notificationOrchestratorProvider).reconcileAll();
    state = AsyncData(sorted);
  }
}

final reminderSettingsControllerProvider =
    StateNotifierProvider<ReminderSettingsController, AsyncValue<List<int>>>(
  (ref) => ReminderSettingsController(ref),
);
