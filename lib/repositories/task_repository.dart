import 'package:task_planner/common/enums/task_status.dart';
import 'package:task_planner/models/task_model.dart';

abstract interface class TaskRepository {
  Future<List<TaskModel>> getAll();
  Future<TaskModel> createTask(TaskModel task);
  Future<Map<TaskStatus, int>> getTaskStatusCount();
  Future<void> updateTaskStatus(int taskId, TaskStatus status);
}
