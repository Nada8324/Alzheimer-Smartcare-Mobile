import 'package:get_storage/get_storage.dart';

class SecureStorage {
  static write(String key, String value) async {
    await GetStorage.init();
    final storage = GetStorage();
    await storage.write(key, value);
  }

  static Future<String?> read(String key) async {
    await GetStorage.init();
    final storage = GetStorage();

    return storage.read(key);
  }

  static Future<dynamic> remove(String key) async {
    await GetStorage.init();
    final storage = GetStorage();

    await storage.remove(key);
  }

  static Future<dynamic> removeAll() async {
    await GetStorage.init();
    final storage = GetStorage();

    await storage.erase();
  }
}
