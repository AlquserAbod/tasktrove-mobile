import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:tasktrove/helpers/TasksHelper.dart';
import 'package:tasktrove/utils/getColor.dart';

class TaskRow extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskRow({Key? key, required this.task}) : super(key: key);

  @override
  _TaskRowState createState() => _TaskRowState();
}

class _TaskRowState extends State<TaskRow> {
  bool _isCompletedCheckbox = false;

  @override
  void initState() {
    super.initState();

    _isCompletedCheckbox = widget.task['isCompleted'];
  }
  
  @override
  Widget build(BuildContext context) {
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
              Row(
                children: [
                  Text('Color :  '),
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
                size: 25
              ),
              SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  print(widget.task);
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
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          )
        ],
      ),
    );
  }
}
