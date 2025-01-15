import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_planner/common/local_storage/local_storage.dart';

class LocalStorageImpl implements LocalStorage {
  @override
  Future<dynamic> getData(String key) async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.get(key);

    return data;
  }

  @override
  Future<void> removeData(String key) async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(key);
  }

  @override
  Future<void> saveData(String key, String data) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(key, data);
  }
}
