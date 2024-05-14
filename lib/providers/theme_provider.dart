import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktrove/theme/thems.dart';

class ThemeProvider with ChangeNotifier {
  final String key = "themeIdentifier";
  ThemeData _themeData = MyThemes.lightTheme;
  late SharedPreferences _sharedPrefs;

  ThemeData get themeData => _themeData;

  bool isDarkTheme() => _themeData.brightness == Brightness.dark;
  String themeString() => isDarkTheme() ? "dark" : "light";
  ThemeData stringToTheme(String text) => text == "dark" ?  MyThemes.darkTheme : MyThemes.lightTheme;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await loadTheme();
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
    saveTheme(); 
  }
  
  void toggleTheme() {
    if (_themeData == MyThemes.lightTheme) {
      themeData = MyThemes.darkTheme;
    } else {
      themeData = MyThemes.lightTheme;
    }
  }

  // sharedPrefs  save load theme functions
  Future<void> loadTheme() async {
    themeData = stringToTheme(_sharedPrefs.getString(key) ?? 'light');
    notifyListeners();
  }

  Future<void> saveTheme() async  => _sharedPrefs.setString(key, themeString());
}
