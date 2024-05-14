import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasktrove/LocalStorage/AuthStorage.dart';
import 'package:tasktrove/components/ThemeToggle/ThemeToggle.dart';
import 'package:tasktrove/components/language_dropdown/LanguageDropdown.dart';
import 'package:tasktrove/helpers/DialogHelper.dart';
import 'package:tasktrove/pages/AuthPages/ChangePassword.dart';
import 'package:tasktrove/pages/AuthPages/Login.dart';
import 'package:tasktrove/pages/AuthPages/Registration.dart';
import 'package:tasktrove/pages/AuthPages/ResetPassword.dart';
import 'package:tasktrove/pages/AuthPages/UpdateProfile.dart';
import 'package:tasktrove/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tasktrove/config.dart' as config;


Locale getLocaleByIndex(int index) {
  switch (index) {
    case 0:
      return Locale('en');
    case 1:
      return Locale('tr');
    case 2:
      return Locale('ar');
    default:
      return Locale('en');
  }
}

class SettingsPage extends StatefulWidget  {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<bool> selectedTheme = [true, false];

  Widget pageTitle(AppLocalizations l) => Text(
    l.settings,
    style: TextStyle(fontSize: 20),
  );

  Widget profileView(BuildContext context, Object? user) {
    if (user == null) {
      return SizedBox();
    }

    final Map<String, dynamic> userData = user as Map<String, dynamic>; // Cast user to Map<String, dynamic>

    // if profile image is default image set api url 
    String profilePic = userData['imagePath'];
    if(!profilePic.startsWith('http') || !profilePic.startsWith('https')) {
      profilePic = '${config.serverUrl}/${profilePic}';
    }

    return Container(

      child: Directionality(
        textDirection: TextDirection.ltr, // Set the text direction statically
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0), 
                    border: Border.all(
                      color: Provider.of<ThemeProvider>(context).themeData.dividerColor, 
                      width: 1.0, 
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0), 
                    child: Image.network(
                      profilePic,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData['username'],
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 3,),
                Text(
                  userData['email'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );

  }
 
  
  final divider = Container(
    height: 1, // Set the height of the divider
    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.grey, // Set the color of the divider
      borderRadius: BorderRadius.circular(5), // Set the border radius
    )
  );



  Widget settingRow(BuildContext context, IconData icon, String title,[VoidCallback? onTap]) => InkWell(
    onTap: onTap != null ? onTap : () {},
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Container(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Provider.of<ThemeProvider>(context).themeData.hoverColor,
                    ),
                    child: Icon(
                      icon,
                      size: 24.0,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    title,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            )
          ),
          Icon(Icons.arrow_forward_ios_rounded),
        ],
      ),
    ),
  );


  Widget settingSection(BuildContext context, AppLocalizations l, bool isLoggedIn, Object? user) {
    final Map<String, dynamic>? userData = user as Map<String, dynamic>?; // Cast user to Map<String, dynamic>

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.profile,
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          !isLoggedIn
            ? Column(
                children: [
                  settingRow(
                    context,
                    FontAwesomeIcons.solidUser,
                    l.register,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistrationPage()),
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  settingRow(
                    context,
                    FontAwesomeIcons.rightToBracket,
                    l.login,
                    () {
                      Navigator.push( 
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  settingRow(context,FontAwesomeIcons.unlock,l.reset_password,() {
                      Navigator.push( 
                        context,
                        MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                      );
                  }),
                ],
            )
          : Column(children: [
            SizedBox(height: 8),
            settingRow(context,FontAwesomeIcons.userPen,l.updateProfile,() {
              if(userData!['googleId'] != null) {
                return DialogHelper.showUsingGoogleServiceDialog(context,userData['username']);
              }

              Navigator.push( 
                context,
                MaterialPageRoute(builder: (context) => UpdateProfilePage()),
              );
            }),
            SizedBox(height: 8),
            settingRow(context,FontAwesomeIcons.lock,l.changePassword,() {
              if(userData!['googleId'] != null) {
                return DialogHelper.showUsingGoogleServiceDialog(context,userData['username']);
              }

              Navigator.push( 
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordPage()),
              );
            }),
            SizedBox(height: 8),
            settingRow(context,FontAwesomeIcons.rightFromBracket,l.logout,() => DialogHelper.showLogoutDialog(context)),
            SizedBox(height: 8),
            settingRow(context,FontAwesomeIcons.trash,l.remove_account,() => DialogHelper.showRemoveAccountDialog(context)),
          ],),
          SizedBox(height: 65),
          Text(
            l.app_settings,
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          ThemeToggle(),
          SizedBox(height: 15),
          LanguageDropdown(),
          SizedBox(height: 15),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object?>(
      future: AuthStorage.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold( 
            body:  Center(child:  CircularProgressIndicator(),),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          bool isLoggedIn = snapshot.data != null;

          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    pageTitle(AppLocalizations.of(context)!),
                    const SizedBox(height: 20),
                    isLoggedIn ? Column(
                      children: [
                        profileView(context, snapshot.data),
                        const SizedBox(height: 20),
                        divider,
                      ],
                    ) : SizedBox(),
                    const SizedBox(height: 10),
                    settingSection(context, AppLocalizations.of(context)!, isLoggedIn, snapshot.data),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}