import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
    NotificationResponse notificationResponse,
  ) async {
    print("Notification receive");
  }

  @pragma('vm:entry-point')
  static Future<void> onDidReceiveBackgroundNotification(
    NotificationResponse notificationResponse,
  ) async {
    print("Notification receive");
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    tz.initializeTimeZones();
  }

  static Future<void> showInstantNotification(String title, String body,
      [String? payload]) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
          'task_notification_channel_id',
          'Task Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime,
      [String? payload]) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          'reminder_task_notification_channel',
          'Reminder Task Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  static Future<void> cancelNotification(int id) async =>
      flutterLocalNotificationsPlugin.cancel(id);

  static Future<void> cancelAllNotifications() async =>
      flutterLocalNotificationsPlugin.cancelAll();

  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async =>
          flutterLocalNotificationsPlugin.pendingNotificationRequests();
}
