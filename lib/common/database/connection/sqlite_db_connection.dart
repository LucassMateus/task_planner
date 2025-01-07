import 'sqlite_connection_factory.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';

class SqliteDbConnection {
  final SqliteConnectionFactory _cnx;

  SqliteDbConnection.get() : _cnx = SqliteConnectionFactory.i;

  Future<Database> open() async => _cnx.openConnection();

  Future<void> close() async => _cnx.closeConnection();

  Future<Batch> get getBatch async => (await open()).batch();

  Future<void> applyMigrations() async {
    await open();
    await close();
  }
}
