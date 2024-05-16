import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:tasktrove/config.dart' as config;
import 'package:tasktrove/helpers/TasksFilterHelper.dart';
import 'package:tasktrove/providers/theme_provider.dart';

class FilterTasks extends StatefulWidget {
  final TaskFilterData? initialFilterData;

  const FilterTasks({Key? key, required this.initialFilterData}) : super(key: key);

  @override
  FilterTasksState createState() => FilterTasksState();
}

class FilterTasksState extends State<FilterTasks> {
  TextEditingController _titleSearch = TextEditingController();
  List<config.TaskColor?> _selectedColors = [];
  bool _isCompletedCheckbox = true;
  bool _isNotCompletedCheckbox = true;

  late TaskFilterData? _initialFilterData;

  @override
  void initState() {
    super.initState();
    _initialFilterData = widget.initialFilterData;
    _isCompletedCheckbox = _initialFilterData!.isCompleted;
    _isNotCompletedCheckbox = _initialFilterData!.isNotCompleted;
    _titleSearch.text = _initialFilterData!.titleSearch;
  }

  List<MultiSelectItem<config.TaskColor>> getColorSelectItems() {
    return config.colorValues.entries.map((entry) {
      String colorName = entry.value;
      config.TaskColor colorValue = entry.key;
      return MultiSelectItem<config.TaskColor>(colorValue, colorName);
    }).toList();
  }

  TaskFilterData getSelectedData() {
    return TaskFilterData(
      titleSearch: _titleSearch.text,
      colors: _selectedColors,
      isCompleted: _isCompletedCheckbox,
      isNotCompleted: _isNotCompletedCheckbox,
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.filter_tasks,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              GestureDetector(
                onTap: () {
                  TasksFilterHelper.resetFilters();
                  setState(() {
                    _isCompletedCheckbox = true;
                    _isNotCompletedCheckbox = true;
                    _titleSearch.text = '';
                    _initialFilterData!.colors = [];
                  });
                },
                child:  Text(
                  l.reset_filters,
                  style: TextStyle(
                    color: Provider.of<ThemeProvider>(context,listen: false).themeData.disabledColor,
                              decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 5),
          Container(
            child: TextFormField(
              controller: _titleSearch,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  fontSize: 18
                ),
                labelText: l.search_in_title,
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            child: MultiSelectChipField<config.TaskColor?>(
              items: getColorSelectItems(),
              initialValue: _initialFilterData?.colors ?? [],
              icon: Icon(Icons.check),
              scroll: false,
              title: Text(
                l.select_search_colors,
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onTap: (values) { 
                _selectedColors = values ;
              },
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('${l.completed} : '),
                  RoundCheckBox(
                    
                    onTap: (selected) {
                      setState(() => _isCompletedCheckbox = selected ?? false);
                    },
                    isChecked: _isCompletedCheckbox,
                    animationDuration: Duration(milliseconds: 150),
                    size: 26
                    
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('${l.incompleted} : '),
                  RoundCheckBox(
                    onTap: (selected) {
                      setState(() => _isNotCompletedCheckbox = selected ?? false);
                    },
                    isChecked: _isNotCompletedCheckbox,
                    animationDuration: Duration(milliseconds: 150),
                    size: 26
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
