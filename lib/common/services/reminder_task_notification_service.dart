import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_planner/common/enums/task_status.dart';
import 'package:task_planner/common/extensions/time_extension.dart';
import 'package:task_planner/common/services/notification_service.dart';
import 'package:task_planner/models/task_model.dart';
import 'package:task_planner/repositories/task_repository.dart';

const timeBeforeStartTask = TimeOfDay(hour: 1, minute: 0);
const dailySummaryNotificationId = 0;
const dailySummaryTime = 7;

class ReminderTaskNotificationService {
  static Future<void> scheduleTaskAndCancelOld(TaskModel task) async {
    final schedulingDate = DateTime(
      task.date.year,
      task.date.month,
      task.date.day,
      task.startTime.hour - timeBeforeStartTask.hour,
      task.startTime.minute - timeBeforeStartTask.minute,
    );

    await NotificationService.cancelNotification(task.id);

    await NotificationService.scheduleNotification(
      task.id,
      'Task Reminder',
      'Your task ${task.title} starts soon at ${task.startTime.toTimeString()}',
      schedulingDate,
    );
  }

  static void scheduleDailySummaryNotification(
    TaskRepository taskRepository,
  ) async {
    final now = DateTime.now();
    final bool isBeforeTheDailySummaryTime =
        kDebugMode ? true : now.hour < dailySummaryTime;
    // final bool isBeforeTheDailySummaryTime = now.hour < dailySummaryTime;

    final day = isBeforeTheDailySummaryTime ? now.day : now.day + 1;
    final morningNotificationTime = DateTime(
      now.year,
      now.month,
      day,
      kDebugMode ? now.hour : dailySummaryTime,
      kDebugMode ? now.minute + 3 : 0,
    );

    final tasksForTomorrow = await taskRepository.getWithFilter(
      status: TaskStatus.todo,
      date: morningNotificationTime,
    );

    final taskSummary = tasksForTomorrow.isNotEmpty
        ? 'You have ${tasksForTomorrow.length} task(s) planned for today. Stay productive!'
        : 'No tasks planned for today. Enjoy your day!';

    await NotificationService.cancelNotification(dailySummaryNotificationId);

    await NotificationService.scheduleNotification(
      dailySummaryNotificationId,
      'Daily Task Summary',
      taskSummary,
      morningNotificationTime,
    );
  }
}
