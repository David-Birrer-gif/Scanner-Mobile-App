import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../products/domain/entities/product.dart';

class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(const InitializationSettings(android: android));
  }

  Future<void> scheduleReminders({
    required Product product,
    required List<int> daysBefore,
  }) async {
    for (final days in daysBefore) {
      final scheduledDate = product.expiryDate.subtract(Duration(days: days));
      if (scheduledDate.isBefore(DateTime.now())) continue;
      await _plugin.zonedSchedule(
        (product.id ?? product.hashCode) + days,
        'Product expiring soon',
        '${product.name} expires in $days day(s).',
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'expiry_reminders',
            'Expiry reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}
