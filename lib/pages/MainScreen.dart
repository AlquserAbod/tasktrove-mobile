import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tasktrove/components/Tasks/TaskRow.dart';
import 'package:tasktrove/providers/tasks_provider.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback? reloadTasks;

  MainScreen({Key? key, this.reloadTasks}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();

    TasksProvider tasksProvider = TasksProvider();

    tasksProvider.init().then((_) {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    AppLocalizations l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.mainscreen),
      ),
      body: Consumer<TasksProvider>(
          builder: (context, provider, _) {
            return ListView.builder(
              itemCount: provider.tasks.length,
              itemBuilder: (context, index) {
                Map<String,dynamic> task = provider.tasks[index];
                
                return TaskRow(task: task);
              },
            );
          }
      )

    );
  }
}
