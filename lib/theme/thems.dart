import 'package:flutter/material.dart';

Color hexToColor(String hexColor) {
  return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
}

enum MyThemeKeys { LIGHT, DARK }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: hexToColor('#1F4547'),
      brightness: Brightness.light,
      primary: hexToColor('#1F4547'),
      secondary: hexToColor("#BFA575"),
    ),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: hexToColor('#1F4547'),
      brightness: Brightness.dark,
      primary: hexToColor('#1F4547'),
      secondary: hexToColor("#BFA575"),
    ),
    useMaterial3: true,
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}