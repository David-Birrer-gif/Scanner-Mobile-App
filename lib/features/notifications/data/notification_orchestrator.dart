import '../../products/domain/entities/product.dart';
import '../../products/domain/repositories/product_repository.dart';
import '../domain/reminder_rule.dart';
import 'notification_service.dart';

class NotificationOrchestrator {
  NotificationOrchestrator(this._repository, this._service);

  final ProductRepository _repository;
  final NotificationService _service;

  int computeNotificationId(int productId, int offsetDays) {
    return (productId * 1000 + offsetDays).abs() % 2147483647;
  }

  Future<void> rescheduleForProductId(int productId) async {
    final product = (await _repository.getActiveProducts()).where((p) => p.id == productId).firstOrNull;
    if (product == null) return;
    await cancelForProduct(productId);
    if (product.status != ProductStatus.active) return;

    final offsets = await _effectiveOffsets(productId);
    final schedules = <ReminderSchedule>[];
    for (final offset in offsets) {
      final when = product.expiryDate.subtract(Duration(days: offset));
      if (when.isBefore(DateTime.now())) continue;
      final id = computeNotificationId(productId, offset);
      await _service.schedule(
        id: id,
        title: 'Expiry reminder',
        body: '${product.name} expires in $offset day(s)',
        when: when,
      );
      schedules.add(ReminderSchedule(notificationId: id, scheduledAt: when, offsetDays: offset));
    }
    await _repository.saveScheduledNotifications(productId, schedules);
  }

  Future<void> cancelForProduct(int productId) async {
    final existing = await _repository.getScheduledNotifications(productId);
    for (final schedule in existing) {
      await _service.cancel(schedule.notificationId);
    }
    await _repository.deleteScheduledNotifications(productId);
  }

  Future<void> reconcileAll() async {
    final active = await _repository.getActiveProducts();
    for (final product in active) {
      final id = product.id;
      if (id == null) continue;
      await rescheduleForProductId(id);
    }
  }

  Future<List<int>> _effectiveOffsets(int productId) async {
    final overrides = await _repository.getProductReminderOverrides(productId);
    if (overrides != null && overrides.isNotEmpty) {
      final values = [...overrides]..sort((a, b) => b.compareTo(a));
      return values;
    }
    final global = await _repository.getGlobalReminderOffsets();
    final values = [...global]..sort((a, b) => b.compareTo(a));
    return values;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
