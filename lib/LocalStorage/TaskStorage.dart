import 'dart:convert'; // Import dart:convert to use jsonEncode and jsonDecode
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktrove/utils/generateTaskId.dart';

class TaskStorage {
  static const tasksKey = 'tasks';

  static Future<List<Map<String, dynamic>>> addTask(String title, String color, bool isCompleted) async {
    List<Map<String, dynamic>> tasksList = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      tasksList = (prefs.getStringList(tasksKey)?.map((task) => jsonDecode(task) as Map<String, dynamic>).toList() ?? []);

      tasksList.add({
        "_id": generateTaskId(),
        'title': title,
        'color': color,
        'isCompleted': isCompleted,
      });

      await prefs.setStringList(tasksKey, tasksList.map((task) => jsonEncode(task)).toList());

    } catch (e) {
      print(e);
    } finally {
      return tasksList;
    }
  }


  static void deleteTask(String taskId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> tasksList = [];

      // Retrieve existing tasks
      tasksList = (prefs.getStringList(tasksKey)?.map((task) => jsonDecode(task) as Map<String, dynamic>).toList() ?? []);

      // Filter tasks to keep only those with IDs different from taskId
      tasksList.removeWhere((task) => task['_id'] == taskId);

      // Update SharedPreferences with filtered tasks
      await prefs.setStringList(tasksKey, tasksList.map((task) => jsonEncode(task)).toList());
    } catch (e) {
      print(e); // Handle errors gracefully (e.g., display an error message)
    }
  }

  static Future<List<Map<String, dynamic>>> getAllTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String>? serializedTasks = prefs.getStringList(tasksKey);


      if (serializedTasks != null) {
        return serializedTasks.map((task) => jsonDecode(task)).toList().cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static void clearAllTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(tasksKey);
    } catch (e) {
      print(e);
    }
  }

  static void updateTask(String taskId, {String? title, String? color, bool? isCompleted}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> tasksList = [];

      tasksList = (prefs.getStringList(tasksKey)?.map((task) => jsonDecode(task) as Map<String, dynamic>).toList() ?? []);

      int index = tasksList.indexWhere((task) => task['_id'] == taskId);
      if (index != -1) { 
        if (title != null) tasksList[index]['title'] = title;
        if (color != null) tasksList[index]['color'] = color;
        if (isCompleted != null) tasksList[index]['isCompleted'] = isCompleted;

        await prefs.setStringList(tasksKey, tasksList.map((task) => jsonEncode(task)).toList());
      }
    } catch (e) {
      print(e); 
    }
  }

}
