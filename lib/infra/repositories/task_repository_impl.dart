import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'package:task_planner/common/database/connection/sqlite_db_connection.dart';
import 'package:task_planner/common/enums/task_status.dart';
import 'package:task_planner/models/task_model.dart';
import 'package:task_planner/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({
    required this.connection,
  });

  @protected
  final SqliteDbConnection connection;

  @override
  Future<Map<TaskStatus, int>> getTaskStatusCount() async {
    final result = <TaskStatus, int>{
      TaskStatus.todo: 0,
      TaskStatus.inProgress: 0,
      TaskStatus.done: 0,
    };

    final db = await connection.open();

    final results = await db.rawQuery('''
                                      Select status
                                            ,count(1)
                                      from tasks 
                                      group by status
                                          ''');

    for (final e in results) {
      final status = TaskStatus.fromMap(e['status'] as String);
      final count = e['count(1)'] as int;
      result[status] = count;
    }

    return result;
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    final db = await connection.open();

    final id = await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (id == 0) {
      throw Exception('Failed to insert task');
    }

    return task.copyWith(id: id);
  }

  @override
  Future<List<TaskModel>> getAll() async {
    final db = await connection.open();

    final results = await db.query('tasks');

    final tasks = results.map((task) => TaskModel.fromMap(task)).toList();

    return tasks;
  }

  @override
  Future<void> updateTaskStatus(int taskId, TaskStatus status) async {
    final db = await connection.open();

    await db.rawUpdate(
      '''
      UPDATE tasks
      SET status = ?
      WHERE id = ?
    ''',
      [status.text, taskId],
    );
  }
}
