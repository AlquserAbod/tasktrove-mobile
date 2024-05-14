import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktrove/config.dart' as config;
import 'package:tasktrove/Singletons/DioSingleton.dart';
import 'package:tasktrove/helpers/TasksHelper.dart';

class AuthStorage {
  static const userToken_session_id = 'user_doc_id';
  static const isLoggedIn_session_id = 'isLoggedIn';

  static void setUserInStorage(String userToken) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setBool(isLoggedIn_session_id, true);

      prefs.setString(userToken_session_id, userToken);

      Dio _dio = DioSingleton().dioInstance;
      
      _dio.options.headers['Authorization'] = 'Bearer ${userToken}';

      TasksHelper.getAllTasks();
    }catch (e) {
      print(e);
    }
  }

  static void removeUserFromStorage(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final user = await currentUser();
    if (user == null) return null;

    prefs.setBool(isLoggedIn_session_id, false);
    prefs.remove(userToken_session_id);

    // Clear Storage tasks 
    TasksHelper.clearStorageTasks(context);
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedIn_session_id) ?? false;
  }

  static Future<Map<String, dynamic>?> currentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString(userToken_session_id);

    if (jwtToken == null) return null;

    final jwt = JWT.verify(jwtToken, config.jwtSecretKey);
    Map<String, dynamic> payload = await jwt.payload;

    dynamic user = payload['user'];

    if (user is Map<String, dynamic>) {
      return user;
    } else {
      return null; 
    }
  }

  static Future<String?> userJWT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(userToken_session_id);
  }
}
