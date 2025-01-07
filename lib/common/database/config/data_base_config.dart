import 'package:task_planner/common/database/migrations/migration.dart';

import '../connection/sqlite_adm_connection.dart';
import '../connection/sqlite_connection_factory.dart';
import '../migrations/sqlite_migration_factory.dart';

class DataBaseConfig {
  final String name;
  final int version;
  final List<Migration> migrations;

  static DataBaseConfig? _instance;

  static DataBaseConfig get i {
    if (_instance == null) {
      throw Exception(
          'DataBaseConfig não foi inicializado. Chame DataBaseConfig.initialize().');
    }
    return _instance!;
  }

  DataBaseConfig._({
    required this.name,
    required this.version,
    required this.migrations,
  }) {
    _initialize();
  }

  void _initialize() {
    SqliteMigrationFactory.initialize(migrations: migrations);
    SqliteConnectionFactory.initialize(name: name, version: version);
    SqliteAdmConnection.initialize(SqliteConnectionFactory.i);
  }

  static void initialize({
    required String name,
    required int version,
    required List<Migration> migrations,
  }) {
    _instance ??= DataBaseConfig._(
      name: name,
      version: version,
      migrations: migrations,
    );
  }
}
