import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tasktrove/LocalStorage/AuthStorage.dart';
import 'package:tasktrove/Singletons/DioSingleton.dart';
import 'package:tasktrove/components/Tasks/FilterTasksDialogBody.dart';
import 'package:tasktrove/helpers/SignWithGoogleHelper.dart';
import 'package:tasktrove/helpers/TasksFilterHelper.dart';
import 'package:tasktrove/pages/SettingsScreen.dart';
import 'package:tasktrove/config.dart' as config;

class DialogHelper {

  static void showLogoutDialog(BuildContext context, {VoidCallback? onConfirm}) {
    AppLocalizations l = AppLocalizations.of(context)!;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      title: l.logout,
      desc: l.logout_confirm_message,
      btnCancelText: l.cancel,
      btnCancelOnPress: () {},
      btnOkText: l.logout,
      btnOkOnPress:  () async {
        AuthStorage.removeUserFromStorage(context);
        // on logout if user login using google logout from google
        SignWithGoogleHelper.signOutGoogle();

        if (onConfirm != null) {
          onConfirm();
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
          (route) => false, 
        );
      },
    )..show();
  }

  static void showRemoveAccountDialog(BuildContext context, {VoidCallback? onConfirm}) {
    AppLocalizations l = AppLocalizations.of(context)!;
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      title: l.remove_account,
      desc: l.remove_account_message,
      btnCancelText: l.cancel,
      btnCancelOnPress: () {},
      btnOkText: l.remove,
      btnOkOnPress: () async {
      AuthStorage.removeUserFromStorage(context);

      // on logout if user login using google logout from google
      SignWithGoogleHelper.signOutGoogle();

      if (onConfirm != null) {
        onConfirm();
      }

      // Remove Account api 
      try {
  
        // Send DELETE request
        Dio _dio = DioSingleton().dioInstance;
        await _dio.delete('${config.apiUrl}/auth');

        AuthStorage.removeUserFromStorage(context);

        // Navigate to settings page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
      } catch (error) {
        // Handle Dio errors
        print('Dio error: $error');
      }
    }
    )..show();
  }

  static void showUsingGoogleServiceDialog(BuildContext context,String username, {VoidCallback? onConfirm}) {
    AppLocalizations l = AppLocalizations.of(context)!;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      title: l.google_service_warning_title,
      desc: l.google_service_warning_desc(username),
      btnOkText: l.goBack,
      btnOkOnPress: () {},
    )..show();
  }

  static void showFilterTasksDialog(BuildContext context, {VoidCallback? onConfirm}) {
    AppLocalizations l = AppLocalizations.of(context)!;
    GlobalKey<FilterTasksState> bodyKey = GlobalKey<FilterTasksState>();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      body: FilterTasks(
        key: bodyKey,
        initialFilterData: TasksFilterHelper.savedFilterData,
      ),
      btnCancelColor: Colors.grey,
      btnCancelText: l.cancel,
      btnCancelOnPress: () => {},
      btnOkColor: Colors.blueAccent[400],
      btnOkText: l.filter_tasks,
      btnOkOnPress: () {
        TaskFilterData filterData = bodyKey.currentState!.getSelectedData();
        TasksFilterHelper.savedFilterData = filterData;
        TasksFilterHelper.filterTasks(filterData);
      },
    )..show();
  }
}
