import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:shared_preferences/shared_preferences.dart';

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
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
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