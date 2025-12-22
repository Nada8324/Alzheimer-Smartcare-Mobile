import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global_models/login_model.dart';



class CacheHelper {
  static late SharedPreferences sharedPreferences;

  // Initialize SharedPreferences
  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  String? getDataString({required String key}) {
    return sharedPreferences.getString(key);
  }

  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else if (value is double) {
      return await sharedPreferences.setDouble(key, value);
    } else {
      throw Exception('Unsupported value type');
    }
  }

  Future<bool> saveUserInfo(dynamic user) async {
    // Convert user object to JSON and save it
    return await saveData(key: 'userInfo', value: jsonEncode(user.toJson()));
  }

  LogInModel? getUserInfo() {
    final jsonString = getDataString(key: 'userInfo');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      return LogInModel.fromJson(jsonMap);
    }
    return null;
  }

  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  Future<bool> containsKey({required String key}) async {
    return sharedPreferences.containsKey(key);
  }

  Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }
}
