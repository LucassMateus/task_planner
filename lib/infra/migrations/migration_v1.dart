import 'package:sqflite_common/sqlite_api.dart';
import 'package:task_planner/common/database/migrations/migration.dart';

class MigrationV1 implements Migration {
  @override
  void execute(Batch batch) {
    batch.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        date TEXT,
        startTime TEXT,
        endTime TEXT,
        description TEXT,
        category TEXT,
        status TEXT        
      )
    ''');
  }
}
