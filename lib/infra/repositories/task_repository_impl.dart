import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'package:task_planner/common/database/connection/sqlite_db_connection.dart';
import 'package:task_planner/common/enums/task_status.dart';
import 'package:task_planner/common/extensions/date_extension.dart';
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

    const query = '''
      SELECT status, count(1)
      FROM tasks
      GROUP BY status
    ''';
    final db = await connection.open();
    final results = await db.rawQuery(query);

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

  @override
  Future<List<TaskModel>> getWithFilter(
      {String? title, TaskStatus? status, DateTime? date}) async {
    final hasStatus = status != null;
    final hasDate = date != null;
    final hasTitle = title != null && title.isNotEmpty;

    final hasFilter = hasStatus || hasDate || hasTitle;
    final List<Object?> arguments = [];

    final db = await connection.open();

    var query = '''
      SELECT *
      FROM tasks
      WHERE 1 = 1
    ''';

    if (hasStatus) query += ' AND status = ?';
    if (hasDate) query += ' AND date = ?';
    if (hasTitle) query += ' AND title LIKE ?';

    if (hasFilter) {
      arguments.addAll([
        if (hasStatus) status.text,
        if (hasDate) date.toDateString(),
        if (hasTitle) '%$title%',
      ]);
    }

    final results = await db.rawQuery(
      query,
      arguments,
    );

    final tasks = results.map((task) => TaskModel.fromMap(task)).toList();

    return tasks;
  }
}
