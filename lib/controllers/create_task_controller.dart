import 'package:flutter/material.dart';
import 'package:task_planner/common/enums/task_category.dart';
import 'package:task_planner/common/enums/task_status.dart';
import 'package:task_planner/common/extensions/time_extension.dart';
import 'package:task_planner/models/task_model.dart';

import 'package:task_planner/repositories/task_repository.dart';

enum CreateTaskState { none, loading, created, error }

class CreateTaskController extends ChangeNotifier {
  CreateTaskController({required this.taskRepository});

  @protected
  final TaskRepository taskRepository;

  CreateTaskState taskState = CreateTaskState.none;
  String message = '';
  TaskModel? createdTask;

  Future<void> addTask({
    required String title,
    required String date,
    required String startTime,
    required String endTime,
    required String description,
    required TaskCategory category,
  }) async {
    taskState = CreateTaskState.loading;
    try {
      final newTask = TaskModel(
        id: 0,
        title: title,
        description: description,
        date: DateTime.now(),
        startTime: TimeExtension.stringToTime(startTime),
        endTime: TimeExtension.stringToTime(endTime),
        category: TaskCategory.fromMap(category.text),
        status: TaskStatus.todo,
      );

      createdTask = await taskRepository.createTask(newTask);

      message = 'Task ${createdTask!.title} created successfully';
      taskState = CreateTaskState.created;
    } on Exception catch (e) {
      message = 'Error creating task: $e';
      taskState = CreateTaskState.error;
    } finally {
      notifyListeners();
    }
  }
}
