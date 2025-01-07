// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';

abstract interface class Migration {
  void execute(Batch batch);
}
