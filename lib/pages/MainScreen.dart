import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tasktrove/components/Tasks/TaskRow.dart';
import 'package:tasktrove/helpers/DialogHelper.dart';
import 'package:tasktrove/helpers/TasksFilterHelper.dart';
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
        title: Text(l.my_tasks),
        actions: [
          IconButton(onPressed: () =>  DialogHelper.showFilterTasksDialog(context), icon: Icon(Icons.filter_alt))
        ],
      ),
      body: Consumer<TasksProvider>(
          builder: (context, provider, _) {
            int tasksLength = provider.tasks.length;

            if(tasksLength > 0) {
              return ListView.builder(
                  itemCount: provider.tasks.length,
                  itemBuilder: (context, index) {
                    Map<String,dynamic> task = provider.tasks[index];

                    return Column(
                      children: [
                        TaskRow(task: task),
                        index + 1 != provider.tasks.length ? Divider(indent: 15,endIndent: 15,) : Container()
                      ],
                    );
                  },
                );
            } else {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    SizedBox(height: 20),
                    Flexible( // Wrap Text widget with Flexible to allow text wrapping
                      child: Text(
                        l.no_tasks_founded,
                        softWrap: true,
                        textAlign: TextAlign.center, 
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          }
      )
  
    );
  }
}
