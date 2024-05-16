import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tasktrove/LocalStorage/AuthStorage.dart';
import 'package:tasktrove/LocalStorage/TaskStorage.dart';
import 'package:tasktrove/Services/NavigationService.dart';
import 'package:tasktrove/Singletons/DioSingleton.dart';
import 'package:tasktrove/config.dart' as config;
import 'package:tasktrove/providers/tasks_provider.dart';


class TasksHelper {
  static void createTask(context, String title,config.TaskColor color,{bool isCompleted = false}) async {
    Map<String, dynamic>? currentUser = await AuthStorage.currentUser();
    bool isAuthenticated = currentUser != null;
    List<Map<String, dynamic>> tasks = [];

    String string_color = config.colorValues[color] ?? "red";

    if(isAuthenticated) {
      Dio dio = DioSingleton().dioInstance;

      await dio.post('${config.apiUrl}/tasks', data: {
        "title" : title,
        "color": string_color,
        "isCompleted": isCompleted

      }).then((res) async {
        Response response = await dio.get('${config.apiUrl}/tasks');

        if (response.data is List) {
          tasks = (response.data as List).map((item) => item as Map<String, dynamic>).toList();
        } else {
          print('Invalid data format received from the server');
        }
      }).catchError((error) {
        print(error);
      });

    }else {
      tasks = await TaskStorage.addTask(title, string_color,isCompleted);
    }

    Provider.of<TasksProvider>(context, listen: false).setTasks(tasks);    
  }

  static Future<List<Map<String, dynamic>>> getAllTasks() async {

    List<Map<String, dynamic>> tasks = [];

    try {
      Map<String, dynamic>? currentUser = await AuthStorage.currentUser();
      bool isAuthenticated = currentUser != null;
      if (isAuthenticated) {
        Dio dio = DioSingleton().dioInstance;

        Response response = await dio.get('${config.apiUrl}/tasks');
        if (response.data is List) {
          tasks = (response.data as List).map((item) => item as Map<String, dynamic>).toList();
        } else {
          print('Invalid data format received from the server');
        }
      } else {
        tasks = await TaskStorage.getAllTasks();
      }
      Provider.of<TasksProvider>(NavigationService.navigatorKey.currentContext!, listen: false).setTasks(tasks);

      return tasks;

    } catch (e) {
      print(e);
      return []; // Return an empty list or handle the error appropriately
    }
  }
  
  static void clearStorageTasks(BuildContext context) async {
    TaskStorage.clearAllTasks();

    Provider.of<TasksProvider>(context, listen: false).setTasks([]);
  }

  static void deleteTask(String taskId) async {

      try {
        Map<String, dynamic>? currentUser = await AuthStorage.currentUser();
        bool isAuthenticated = currentUser != null;
        
        if(isAuthenticated){
          Dio dio = DioSingleton().dioInstance;
          await dio.delete('${config.apiUrl}/tasks/${taskId }');

        }else {
          TaskStorage.deleteTask(taskId);
        }
      } catch (e) {
        print(e);
      }finally {
          Provider.of<TasksProvider>(NavigationService.navigatorKey.currentContext!, listen: false).deleteTask(taskId);

      }
  }

  static void toggleCompleted(Map<String, dynamic> task) async {
    try {
      Map<String, dynamic>? currentUser = await AuthStorage.currentUser();
      bool isAuthenticated = currentUser != null;
      String taskId = task['_id'];

      Map<String, dynamic> updatedTask = task;
      updatedTask.update('isCompleted', (value) => !task['isCompleted']);

      if(isAuthenticated){
        Map<String, dynamic> dataToSend =  Map.from(updatedTask);

        dataToSend.remove('_id');

        Dio dio = DioSingleton().dioInstance;
        await dio.put(
          '${config.apiUrl}/tasks/${taskId}', 
          data: dataToSend
        );
      } else {
        TaskStorage.updateTask(taskId,isCompleted: updatedTask['isCompleted']);
      }

      Provider.of<TasksProvider>(NavigationService.navigatorKey.currentContext!, listen: false).updateTask(updatedTask);
    } catch (e) {
      print(e);
    }
  }

  static void updateTask(Map<String, dynamic> task, {String? newTitle,config.TaskColor? newColor, bool? isCompleted}) async {
    try {
      Map<String, dynamic>? currentUser = await AuthStorage.currentUser();
      bool isAuthenticated = currentUser != null;
      String taskId = task['_id'];
      String? color_string = config.colorValues[newColor];

      Map<String, dynamic> updatedTask = {
        "_id": taskId,
        "title": newTitle ?? task['title'],
        "color": config.colorValues[newColor] ?? task['color'],
        "isCompleted": isCompleted ?? task['isCompleted']
      };

      if(isAuthenticated){
        Map<String, dynamic> dataToSend =  Map.from(updatedTask);
        dataToSend.remove('_id');
        
        Dio dio = DioSingleton().dioInstance;
        await dio.put(
          '${config.apiUrl}/tasks/${taskId}', 
          data: dataToSend
        );
        
      } else {
        TaskStorage.updateTask(taskId,isCompleted: isCompleted, color: color_string, title: newTitle);
      }

      Provider.of<TasksProvider>(NavigationService.navigatorKey.currentContext!, listen: false).updateTask(updatedTask);
    } catch (e) {
      print(e);
    }
  }
}

