import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tasktrove/pages/SettingsScreen.dart';
import 'package:tasktrove/providers/language_provider.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({Key? key}) : super(key: key);

  @override
  LanguageDropdownState createState() => LanguageDropdownState();
}

class LanguageDropdownState extends State<LanguageDropdown> {
  late String _selectedLanguage;
  late Map<String,String> _availableLanguages = {
    "en": 'English',
    "tr": 'Turkish',
    "ar": 'Arabic'
  };
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLanguage = _availableLanguages[Provider.of<LanguageProvider>(context).currentLocale.toString()] ?? 'English';
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${l.app_language} :",
            style: TextStyle(fontSize: 20),
          ),

          SizedBox(height: 5),
          
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>( 
              isExpanded: true,
              items: _availableLanguages.values
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
                  
              value: _selectedLanguage,

              onChanged: (String? value) {
                if(value != null ) {
                  setState(() => _selectedLanguage = value );
                  Provider.of<LanguageProvider>(context, listen: false).currentLocale = 
                    getLocaleByIndex(_availableLanguages.values.toList().indexWhere((element) => element == _selectedLanguage));
                }
              },
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                width: MediaQuery.of(context).size.width * 0.7
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
            ),
          ),
      ]
    )
  );
  }
}

