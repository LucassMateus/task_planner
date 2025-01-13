import 'package:flutter/material.dart';
import 'package:task_planner/common/enums/task_status.dart';
import 'package:task_planner/common/services/reminder_task_notification_service.dart';
import 'package:task_planner/models/task_model.dart';

import 'package:task_planner/repositories/task_repository.dart';

enum HomeState { none, loading, loaded, error }

class HomeController extends ChangeNotifier {
  HomeController({required this.taskRepository});

  HomeState taskState = HomeState.none;
  String errorMessage = '';

  final Map<TaskStatus, int> taskStatusCount = {
    TaskStatus.done: 0,
    TaskStatus.todo: 0,
    TaskStatus.inProgress: 0
  };

  final List<TaskModel> tasks = [];

  @protected
  final TaskRepository taskRepository;

  Future<void> init() async {
    taskState = HomeState.loading;

    await getTaskStatusCount();
    await getTasks();

    notifyListeners();
  }

  Future<void> getTaskStatusCount() async {
    try {
      taskStatusCount.clear();

      final result = await taskRepository.getTaskStatusCount();

      taskStatusCount.addAll(result);
    } catch (e) {
      errorMessage = 'Failed to load task status count';
      taskState = HomeState.error;
    }
  }

  Future<void> getTasks() async {
    taskState = HomeState.loading;

    try {
      final result = await taskRepository.getAll();

      tasks.clear();
      tasks.addAll(result);

      taskState = HomeState.loaded;
    } catch (e) {
      errorMessage = 'Failed to load tasks';
      taskState = HomeState.error;
    }
  }

  void addTasks(List<TaskModel> tasks) {
    this.tasks.addAll(tasks);
    for (var task in tasks) {
      final count = taskStatusCount[task.status] ?? 0;
      taskStatusCount[task.status] = count + 1;
    }

    notifyListeners();
  }

  Future<void> updateTaskStatus(TaskModel task, TaskStatus status) async {
    if (task.status == status) return;

    try {
      await taskRepository.updateTaskStatus(task.id, status);

      await getTaskStatusCount();
      await getTasks();
      ReminderTaskNotificationService.scheduleDailySummaryNotification(
        taskRepository,
      );
    } catch (e) {
      errorMessage = 'Failed to update task status';
      taskState = HomeState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> filterTasks(
    String text,
    TaskStatus? status,
    DateTime? date,
  ) async {
    taskState = HomeState.loading;

    try {
      final result = await taskRepository.getWithFilter(
        title: text,
        status: status,
        date: date,
      );

      tasks.clear();
      tasks.addAll(result);

      taskState = HomeState.loaded;
    } catch (e) {
      errorMessage = 'Failed to filter tasks';
      taskState = HomeState.error;
    } finally {
      notifyListeners();
    }
  }
}
