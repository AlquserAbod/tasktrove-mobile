import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
    final String key = "languageIdentifier";
  Locale _currentLocale = Locale('en');
  late SharedPreferences _sharedPrefs;

  Locale get currentLocale => _currentLocale;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await loadLanguage();
  }

  set currentLocale(Locale newLocale) {
    _currentLocale = newLocale;
    notifyListeners();
    saveLanguage(); 
  }

  // sharedPrefs  save load language functions
  Future<void> loadLanguage() async {
    currentLocale = Locale(_sharedPrefs.getString(key) ?? 'en');
    notifyListeners();
  }

  Future<void> saveLanguage() async  => _sharedPrefs.setString(key, currentLocale.languageCode);
}
