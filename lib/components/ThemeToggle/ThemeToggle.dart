import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tasktrove/providers/theme_provider.dart';
import 'package:tasktrove/theme/thems.dart';

class ThemeToggle extends StatefulWidget {
  const ThemeToggle({Key? key}) : super(key: key);

  @override
  ThemeToggleState createState() => ThemeToggleState();
}

class ThemeToggleState extends State<ThemeToggle> {
  List<bool> selectedTheme = [true, false];

  
  @override
  void initState() {
    super.initState();
    bool isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkTheme();
    selectedTheme = isDark ? [false,true] : [true,false]; 
  }


  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        
        children: [
          Text(
            "${l.app_theme} :",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 5),

          ToggleButtons(
            children: [
              Icon(Icons.wb_sunny),
              Icon(Icons.nightlight_round),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            constraints: const BoxConstraints(
            minHeight: 40.0,
            minWidth: 80.0,
            ),
            isSelected: selectedTheme,
            onPressed: (index) {
              setState(() {
                for (int i = 0; i < selectedTheme.length; i++) {
                  selectedTheme[i] = i == index;
                }
                Provider.of<ThemeProvider>(context, listen: false).themeData = index == 0 ? MyThemes.lightTheme : MyThemes.darkTheme;
              });
            },
          ),
        ],
      ),
    );
  }
}

