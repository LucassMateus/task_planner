// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class BackgroundNotificationService {
  BackgroundNotificationService._();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int checkInNotificationId = 1001;

  static Future<void> init() async {
    tz.initializeTimeZones();
  }

  static Future<void> scheduleSilentNotification() async {
    try {
      final DateTime now = DateTime.now();
      final tz.TZDateTime scheduledTime = tz.TZDateTime.from(
        now.add(const Duration(minutes: 1)),
        tz.local,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        checkInNotificationId,
        "Silent Check-In",
        "Waking up the app...",
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'silent_channel',
            'Silent Notifications',
            channelDescription: 'Channel for silent notifications',
            importance: Importance.min,
            priority: Priority.min,
            playSound: false,
          ),
          iOS: DarwinNotificationDetails(
            presentSound: false,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: "check_in",
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> cancelSilentNotification() async {
    try {
      await flutterLocalNotificationsPlugin.cancel(checkInNotificationId);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

//   static void _onDidReceiveNotification(NotificationResponse details) {
//     debugPrint(details.payload ?? "No payload");
//   }

//   static void _onDidReceiveBackgroundNotificationResponse(
//     NotificationResponse details,
//   ) {
//     debugPrint(details.payload ?? "No payload");
//   }
// }
}
