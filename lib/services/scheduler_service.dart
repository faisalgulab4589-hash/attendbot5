import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'prefs_service.dart';

class SchedulerService {
  static final _notif = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios     = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
    );
    await _notif.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  /// Schedule daily CHECK IN and CHECK OUT
  static Future<void> schedule(
      int inH24, int inMin, int outH24, int outMin) async {

    await Workmanager().cancelAll();

    final now = DateTime.now();

    // CHECK IN
    var inTime = DateTime(now.year, now.month, now.day, inH24, inMin);
    if (inTime.isBefore(now)) inTime = inTime.add(const Duration(days: 1));
    final inDelay = inTime.difference(now);

    await Workmanager().registerOneOffTask(
      'checkin_${DateTime.now().millisecondsSinceEpoch}',
      'checkin',
      initialDelay: inDelay,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );

    // CHECK OUT
    var outTime = DateTime(now.year, now.month, now.day, outH24, outMin);
    if (outTime.isBefore(now)) outTime = outTime.add(const Duration(days: 1));
    final outDelay = outTime.difference(now);

    await Workmanager().registerOneOffTask(
      'checkout_${DateTime.now().millisecondsSinceEpoch}',
      'checkout',
      initialDelay: outDelay,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }

  static Future<void> showNotification(String title, String body) async {
    await _notif.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title, body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'attendbot_ch', 'AttendBot',
          importance: Importance.high, priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(presentAlert: true),
      ),
    );
  }
}
