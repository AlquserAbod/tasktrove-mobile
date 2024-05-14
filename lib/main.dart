import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:tasktrove/LocalStorage/AuthStorage.dart';
import 'package:tasktrove/Services/NavigationService.dart';
import 'package:tasktrove/Singletons/DioSingleton.dart';
import 'package:tasktrove/Singletons/GoogleSignInSingleton.dart';
import 'package:tasktrove/pages/AddTaskPage.dart';
import 'package:tasktrove/providers/BottomNavBarProvider.dart';
import 'package:tasktrove/providers/language_provider.dart';
import 'package:tasktrove/providers/tasks_provider.dart';
import 'package:tasktrove/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// Import your custom screens
import 'pages/MainScreen.dart';
import 'pages/SettingsScreen.dart';

PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens(context,_mainScreenKey) {
    return [
      MainScreen(
        key: _mainScreenKey,
      ),
      AddTaskPage(),
      SettingsPage(),
    ];
  }

List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
  ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.home),
      inactiveColorPrimary: Colors.grey,
      title: "Home",
      activeColorPrimary: themeProvider.themeData.primaryColor,
      
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.add),
      inactiveColorPrimary: Colors.grey,
      title: "Add",
      activeColorPrimary: themeProvider.themeData.primaryColor,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.settings),
      inactiveColorPrimary: Colors.grey,
      title: "Settings",
      activeColorPrimary: themeProvider.themeData.primaryColor,
    ),
  ];
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key); // Not declared as const



  @override
  MyAppState createState() => MyAppState();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Dio _dio = DioSingleton().dioInstance;

  ThemeProvider themeProvider = ThemeProvider();
  LanguageProvider languageProvider = LanguageProvider();
  TasksProvider tasksProvider = TasksProvider();
  BottomNavBarProvider bottomnavbarProvider = BottomNavBarProvider();

  _dio.options.baseUrl = 'https://tasktrove-server.vercel.app/api';

  String? userToken = await AuthStorage.userJWT();
  if(userToken != null) { _dio.options.headers['Authorization'] = 'Bearer ${userToken}'; }

  await themeProvider.init();
  await languageProvider.init();
  await bottomnavbarProvider.init(_controller);

  GoogleSignInSingleton();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeProvider),
        ChangeNotifierProvider(create: (context) => languageProvider),
        ChangeNotifierProvider(create: (context) => tasksProvider),
        ChangeNotifierProvider(create: (context) => bottomnavbarProvider),
      ],
      child: MyApp(),
    ),
  );

}

class MyAppState extends State<MyApp> {
  final GlobalKey<MainScreenState> _mainScreenStateKey = GlobalKey<MainScreenState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      locale: Provider.of<LanguageProvider>(context).currentLocale, // Set default locale
      localizationsDelegates: AppLocalizations.localizationsDelegates, // Add
      supportedLocales: AppLocalizations.supportedLocales, // Add
      theme: Provider.of<ThemeProvider>(context).themeData,
      navigatorKey: NavigationService.navigatorKey, // set property
      home: Scaffold(
        body: PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(context,_mainScreenStateKey),
            items: _navBarsItems(context),
            hideNavigationBarWhenKeyboardShows: true, 
            handleAndroidBackButtonPress: true,
            stateManagement: true,
            decoration:  NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: Colors.white,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            onItemSelected: (int) {
              setState(() {});
            },
            itemAnimationProperties: const ItemAnimationProperties(
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle.style13,
          )
        )     
    );
  }
}