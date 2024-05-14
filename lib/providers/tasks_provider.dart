
import 'package:flutter/material.dart';
import 'package:tasktrove/helpers/TasksHelper.dart';

class TasksProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get tasks => _tasks;

  Future<void> init() async {
    _tasks = await TasksHelper.getAllTasks();
  }

  void setTasks(List<Map<String, dynamic>> tasks) async { 
    _tasks = tasks;
    notifyListeners();
  }

  void deleteTask(String taskId) async {
    try {
      final index = _tasks.indexWhere((task) => task['_id'] == taskId);
      if (index != -1) {
        _tasks.removeAt(index);
        notifyListeners(); 
      }
    } catch (e) {
      print(e);
    } 
  }
  
  void updateTask(Map<String, dynamic> updatedTask) async {
    try {
      final index = _tasks.indexWhere((task) => task['_id'] == updatedTask['_id']);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
