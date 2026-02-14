import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_mobile_app/features/notifications/data/notification_orchestrator.dart';
import 'package:scanner_mobile_app/features/notifications/data/notification_service.dart';
import 'package:scanner_mobile_app/features/products/domain/repositories/product_repository.dart';

class _FakeRepo implements ProductRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('notification ID generation is stable', () {
    final orchestrator = NotificationOrchestrator(
      _FakeRepo(),
      NotificationService(FlutterLocalNotificationsPlugin()),
    );
    expect(orchestrator.computeNotificationId(10, 3), orchestrator.computeNotificationId(10, 3));
  });
}
