import 'package:shared_preferences/shared_preferences.dart';
import 'prefs_service.dart';
import 'scheduler_service.dart';

class AttendanceService {
  // Called by Workmanager background task
  static Future<void> runBackground(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    final email    = prefs.getString('email')    ?? '';
    final password = prefs.getString('password') ?? '';
    if (email.isEmpty || password.isEmpty) return;

    final label = mode == 'checkin' ? 'CHECK IN' : 'CHECK OUT';

    // Show notification — tapping it opens app which runs WebView
    await SchedulerService.showNotification(
      'AttendBot — $label',
      'Auto attendance starting now. Tap to monitor.',
    );

    // Re-schedule for next day
    final s = await PrefsService.load();
    await SchedulerService.schedule(
      s.inHour24, s.inMin, s.outHour24, s.outMin,
    );
  }
}
