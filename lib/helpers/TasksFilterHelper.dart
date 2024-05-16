
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:tasktrove/LocalStorage/AuthStorage.dart';
import 'package:tasktrove/LocalStorage/TaskStorage.dart';
import 'package:tasktrove/Services/NavigationService.dart';
import 'package:tasktrove/Singletons/DioSingleton.dart';
import 'package:tasktrove/config.dart';
import 'package:tasktrove/providers/tasks_provider.dart';
import 'package:tasktrove/config.dart' as config;

class TaskFilterData {
  String titleSearch;
  List<TaskColor?> colors;
  bool isCompleted;
  bool isNotCompleted;

  TaskFilterData({
    this.titleSearch = '',
    this.colors = const [],
    this.isCompleted = true,
    this.isNotCompleted = true,
  });
}


class TasksFilterHelper {
  static TaskFilterData savedFilterData = TaskFilterData();

  static void resetFilters() {
    savedFilterData = TaskFilterData();
  }    


  static void filterTasks(TaskFilterData filterData) async {
    try {
      Map<String, dynamic>? currentUser = await AuthStorage.currentUser();
      bool isAuthenticated = currentUser != null;
      Map<String, dynamic> filterQurey = {};
      List<Map<String,dynamic>> filterdTasks = [];
      
      if(filterData.titleSearch.trim() != '') {
        filterQurey['title'] = filterData.titleSearch;
      }

      if(!filterData.colors.isEmpty) {
        filterQurey['colors'] = filterData.colors.map<String>((config.TaskColor? color) {
          String? colorName = config.colorValues[color];
          return colorName ?? ''; 
        }).toList();
      }

      if(filterData.isCompleted != filterData.isNotCompleted) {
        filterQurey['isCompleted'] = filterData.isCompleted == true ? true : filterData.isNotCompleted == true ? false : true;
      }

      if(isAuthenticated) {
        Dio dio = DioSingleton().dioInstance;
        Response response =  await dio.get(
          '${config.apiUrl}/tasks', 
          queryParameters: filterQurey
        );

        if (response.data is List) {
          filterdTasks = (response.data as List).map((item) => item as Map<String, dynamic>).toList();
        } else {
          print('Invalid data format received from the server');
        }
      } else {
        List<Map<String, dynamic>> allTasks = await TaskStorage.getAllTasks();
        
        // Apply filter on tasks from local storage
        filterdTasks = allTasks.where((task) {
          // Implement your filtering logic here
          bool match = true;

          // Check title filter
          if (filterQurey.containsKey('title')) {
            String title = task['title'] ?? '';
            if (!title.toLowerCase().contains(filterQurey['title'].toString().toLowerCase())) {
              match = false;
            }
          }

          // Check color filter
          if (filterQurey.containsKey('colors')) {

            if (!filterQurey['colors'].contains(task['color'])) {
              match = false;
            }
          }

          // Check completion status filter
          if (filterQurey.containsKey('isCompleted')) {
            bool isCompleted = task['isCompleted'] ?? false;
            bool expectedValue = filterQurey['isCompleted'];
            if (isCompleted != expectedValue) {
              match = false;
            } 
          }

          return match;
        }).toList();
      }

    
      Provider.of<TasksProvider>(NavigationService.navigatorKey.currentContext!, listen: false).setTasks(filterdTasks);

      
    } catch (e) {
      print(e);
    }
  }
  
}