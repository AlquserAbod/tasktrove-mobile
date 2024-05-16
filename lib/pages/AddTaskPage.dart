// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tasktrove/components/Buttons/SubmitButton.dart';
import 'package:tasktrove/components/toasts/FieldsErrorsToast.dart';
import 'package:tasktrove/helpers/TasksHelper.dart';
import 'package:tasktrove/providers/BottomNavBarProvider.dart';
import 'package:tasktrove/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tasktrove/config.dart' as config;
import 'package:tasktrove/utils/getColor.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';




class AddTaskPage extends StatefulWidget {
  final Map<String, dynamic>? task;

  AddTaskPage({this.task});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController _titleController = TextEditingController();
  config.TaskColor? _selectedColor;
  bool _isCompleted = false;

  FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!['title'];
      // Assuming getColor returns your custom color type defined in config.dart
      _selectedColor = config.getColorByName(widget.task!['color']);
      _isCompleted = widget.task!['isCompleted'];
    }
  }

  String? _titleValidator(value, AppLocalizations l){
    if (value == null || value.isEmpty) {
      return 'title ${l.is_required}';
    }
    return null;
  }

  Widget colorSelectSection(context, AppLocalizations l) {
    TextDirection textDirection = Directionality.of(context);


    return Container(
      alignment: textDirection == TextDirection.ltr ? Alignment.centerLeft : Alignment.centerRight,

      child: Column(
        children: [
        Row(
          children: [
            Text(
              l.select_task_color,
              style: TextStyle(
                fontSize: 16,
                
                fontWeight: FontWeight.bold
              ),
            
            ),
          ],
        ),
        SizedBox(height: 15),
        Wrap(          
            spacing: 10,
            runSpacing: 10,
            children: config.colorValues.entries.map((entry) {
              config.TaskColor colorEnum = entry.key;
              String colorName = entry.value;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = colorEnum;
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: getColor(colorName),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: _selectedColor == colorEnum
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 30,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
      ]),
    );
  }

  dynamic validateFields(AppLocalizations l) {
    if(_titleController.text == '') return "${l.title_field} ${l.is_required}";

    if(_selectedColor == null) return "${l.color_field} ${l.is_required}";

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Provider.of<ThemeProvider>(context).themeData;

    fToast.init(context);

    AppLocalizations l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: widget.task == null ? Alignment.center : null,
          child: Text(
                l.add_new_task,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
        )
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50,horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 30),
              TextFormField(
                controller: _titleController,
                validator: (value) => _titleValidator(value,l),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    fontSize: 25
                  ),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  labelText: l.task_title,
                ),
              ),
              SizedBox(height: 30),
              colorSelectSection(context, l),
              SizedBox(height: 30),
              LiteRollingSwitch(
                value: _isCompleted,
                width: 150,
                textOn: l.completed,
                textOff: l.incompleted,
                colorOn: Colors.green,
                colorOff: Colors.red,
                iconOn: Icons.lightbulb_outline,
                iconOff: Icons.power_settings_new,
                animationDuration: const Duration(milliseconds: 300),
                onChanged: (bool state) {
                  setState(() { _isCompleted = state; });
                },
                onDoubleTap: () {},
                onSwipe: () {},
                onTap: () {},
              ),
              SizedBox(height: 60),
              SubmitButton(text: widget.task == null ? l.create_task : l.update_task,onPressed: () {

                dynamic validate = validateFields(l);

                if(validate != true) {
                  return fToast.showToast(
                    child: ErrorToast(message: validate),
                    gravity: ToastGravity.TOP,
                    toastDuration: Duration(seconds: 1),
                  );
                }
                if(widget.task == null) {
                  TasksHelper.createTask(context,_titleController.text, _selectedColor ?? config.TaskColor.RED,isCompleted: _isCompleted);

                  Provider.of<BottomNavBarProvider>(context, listen: false).controller?.jumpToTab(0);
                } else {
                  TasksHelper.updateTask(
                    widget.task!,
                    newTitle: _titleController.text,
                    newColor:  _selectedColor ?? config.TaskColor.RED,
                    isCompleted: _isCompleted
                  );
                  Navigator.of(context).pop();
                }

                

                setState(() {
                  _selectedColor = null;
                  _isCompleted = false;
                  _titleController.clear();
                });
              })
            ],
          ),
        ),
      ),
    );
  }

}
