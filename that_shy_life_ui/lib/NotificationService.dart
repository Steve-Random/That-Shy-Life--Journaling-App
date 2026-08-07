import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

/// Manages local notification scheduling for daily check-in reminders,
/// using flutter_local_notifications with per-timezone scheduling.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification plugin,creates the Android notification
  /// channel, and requests permissions.Exact-alarm permission is only
  /// requested on Android 12+ --guarded by [KIsWeb]/[defaultTargetPlatform]
  /// since permission_handler's exact-alarm APIs aren't supported on web.
  static Future<void> init() async {
    tzdata.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);
    //...............
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
            'daily_check_channel',
            'Daily Check-in',
            description: 'Daily reminder to journal and check in',
            importance: Importance.max,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(channel);

    //Requesting the user for permission (for Android 13 and above)
    await _plugin
    .resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();

    //Requesting exact alarm permission from user (for Android 12+)
    if(!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
      if (!exactAlarmStatus.isGranted) {
        await Permission.scheduleExactAlarm.request();
      }
    }
  }

  /// Schedules a repeating daily notification at [hour]:[minute].
  ///
  /// Tries exact scheduling first ('exactAllowWhileIdle') for precise
  /// timing. If that throws (e.g. user denied the exact-alarm permission),
  /// falls back to 'inexactAllowWhileIdle' so the reminder still fires,
  /// just without exact-timing guarantees.
  static Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
}) async {
    try{
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
} catch (e){
      // falls back to inexact alarm notifications if permission not granted
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
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, //repeats daily
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );

    }
}


  static Future<void> cancelDailyReminder() async {
    await _plugin.cancel(0);
  }

  /// Returns the next occurrence of [hour]:[minute] in the local timezone --
  /// today if that time hasn't passed yet, otherwise tomorrow.
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if(scheduled.isBefore(now)){
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static Future<void> saveReminderTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', hour);
    await prefs.setInt('reminder_minute', minute);
  }

  static Future<TimeOfDay?> getSavedReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour =  prefs.getInt('reminder_hour');
    final minute =  prefs.getInt('reminder_minute');

    if ((hour == null) || (minute == null)) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static Future<void> clearSavedReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('reminder_hour');
    await prefs.remove('reminder_minute');
  }
}