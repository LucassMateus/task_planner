abstract interface class LocalStorage {
  Future<void> saveData(String key, String data);

  Future<dynamic> getData(String key);

  Future<void> removeData(String key);
}
