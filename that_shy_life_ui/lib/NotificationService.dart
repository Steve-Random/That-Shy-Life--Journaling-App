import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzdata.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    //Requesting the user for permission (for Android 13 and above)
    await _plugin
    .resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();
  }

  static Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
}) async {
    await _plugin.zonedSchedule(
        0, //notification id
        'Time to check in',
        'How is your social battery doing today?',
         _nextInstanceOfTime(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
          'daily_check_channel',
          'Daily Check-in',
          channelDescription: 'Daily reminder to journal and check in',
          importance: Importance.high,
          priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, //repeats daily
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
  }

  static Future<void> cancelDailyReminder() async {
    await _plugin.cancel(0);
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if(scheduled.isBefore(now)){
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}