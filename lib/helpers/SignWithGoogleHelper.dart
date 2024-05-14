
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasktrove/LocalStorage/AuthStorage.dart';
import 'package:tasktrove/Singletons/DioSingleton.dart';
import 'package:tasktrove/Singletons/GoogleSignInSingleton.dart';
import 'package:tasktrove/components/toasts/EmailVerifyeToast.dart';
import 'package:tasktrove/components/toasts/FieldsErrorsToast.dart';
import 'package:tasktrove/config.dart' as config;
import 'package:tasktrove/pages/SettingsScreen.dart';
import 'package:tasktrove/response_types.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignWithGoogleHelper {
  static Future<GoogleSignInAccount?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignInSingleton().googleSignIn.signIn();

      if(googleSignInAccount == null) return null;
     
      Dio dio = DioSingleton().dioInstance;

      AppLocalizations l = AppLocalizations.of(context)!;

      FToast fToast = FToast();

      try {
        var response = await dio.post('${config.apiUrl}/auth/google/store', data: {
          "googleId": googleSignInAccount.id,
          "username": googleSignInAccount.displayName,
          "email": googleSignInAccount.email,
          "imagePath": googleSignInAccount.photoUrl
        });

        Map<String, dynamic> data = response.data;

        if(data['success']) {

          AuthStorage.setUserInStorage(data['token']);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
            (route) => false, 
          );
        
        }

      } catch (e) {
        if (e is DioException) {
          var errorResponse = e.response;
          if (errorResponse != null) {
            try {
              var errorJson = errorResponse.data;
              Widget? toastChild;  

              if (errorJson.containsKey('type') ) {

                switch(errorTypeMap[errorJson['type']]) {
                  case ResponseTypes.WAITING_VERIFY_EMAIL:
                    toastChild = EmailVerifyeToast(email: googleSignInAccount.email);
                    break;
                  case ResponseTypes.INTERNAL_ERROR:
                    toastChild = ErrorToast(message: l.internal_error);
                  default:
                }

                if(toastChild != null) {
                  fToast.showToast(
                    child: toastChild,
                    gravity: ToastGravity.TOP,
                    toastDuration: Duration(seconds: 2),
                  );
                }
              }

            } catch (errorParsingException) {
              print('Failed to parse error response as JSON: $errorParsingException');
            }
          } else {
            print('No error response received.');
          }
        } else {
          print('Unexpected exception: $e');
        }
      }

      return googleSignInAccount;
    } catch (error) {
      print("Error signing in with Google: $error");
      return null;
    }
  }

  static void signOutGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignInSingleton().googleSignIn;
      
      if (googleSignIn.currentUser != null) {
        await googleSignIn.signOut();
      } else {
        print("User is not logged in.");
      }
    } catch (error) {
      print("Error signing out with Google: $error");
    }
  }
}
