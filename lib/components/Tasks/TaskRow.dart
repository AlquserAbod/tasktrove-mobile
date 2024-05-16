import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:tasktrove/helpers/TasksHelper.dart';
import 'package:tasktrove/pages/AddTaskPage.dart';
import 'package:tasktrove/utils/getColor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskRow extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskRow({Key? key, required this.task}) : super(key: key);

  @override
  _TaskRowState createState() => _TaskRowState();
}

class _TaskRowState extends State<TaskRow> {
  bool _isCompletedCheckbox = false;


  
  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context)!;
    _isCompletedCheckbox = widget.task['isCompleted'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task['title'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              Text(
                widget.task['isCompleted'] ? l.task_is_completed : l.task_is_not_completed
              ),
              Row(
                children: [
                  Text(l.task_color_is),
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: getColor(widget.task['color']),
                      shape: BoxShape.circle,
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            children: [
              RoundCheckBox(
                onTap: (selected) {
                  setState(() => _isCompletedCheckbox = selected ?? false);
                  TasksHelper.toggleCompleted(widget.task);
                },
                isChecked: _isCompletedCheckbox,
                animationDuration: Duration(milliseconds: 150),
                size: 25
              ),
              SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  TasksHelper.deleteTask(widget.task['_id']);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.red[500],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.delete, color: Colors.white, size: 18),
                ),
              ),
              SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTaskPage(task:  widget.task)),
                  );
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, color: Colors.white, size: 18),
                ),
              ),        
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          )
        ],
      ),
    );
  }
}
