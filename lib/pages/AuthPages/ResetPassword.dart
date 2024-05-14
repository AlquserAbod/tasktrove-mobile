import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasktrove/components/Form/Inputs/EmailInput.dart';

import 'package:tasktrove/components/Form/Buttons/FormSubmitButton.dart';
import 'package:tasktrove/components/toasts/FieldsErrorsToast.dart';
import 'package:tasktrove/components/toasts/PasswordResetLinkSentedToast.dart';
import 'package:tasktrove/config.dart' as config;
import 'package:tasktrove/Singletons/DioSingleton.dart';
import 'package:tasktrove/pages/AuthPages/Login.dart';
import 'package:tasktrove/response_types.dart';


class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  GlobalKey<EmailInputState> emailInputKey = GlobalKey<EmailInputState>();

  bool isLoading = false;

  FToast fToast = FToast();

  final GlobalKey<FormState> _formKey = GlobalKey(); 
  
  void onSubmit(AppLocalizations l) async {    
    if (_formKey.currentState!.validate()) {

      setState(() => isLoading = true );

      Dio dio = DioSingleton().dioInstance;

      try {
        var response = await dio.post('${config.apiUrl}/auth/password-reset', data: {
          "email": emailInputKey.currentState!.getController().text,
        });

        Map<String, dynamic> data = response.data;

        if(data['success']) {
          emailInputKey.currentState!.getController().clear();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );

          fToast.showToast(
            child: PasswordResetLinkSentedToast(email: emailInputKey.currentState!.getController().text),
            gravity: ToastGravity.TOP,
            toastDuration: Duration(seconds: 4),
          );
        }

      } catch (e) {

        if (e is DioException) {
          var errorResponse = e.response;

          if (errorResponse != null) {
            try {
              var errorJson = errorResponse.data;
              String message = '';  
              
              if (errorJson.containsKey('type') ) {

                switch(errorTypeMap[errorJson['type']]) {
                  case ResponseTypes.FIELD_ERRORS: 
                    message = errorJson['errors'].map((error) => '${error['path']}: ${error['msg']}').join('\n');
                    break;
                  case ResponseTypes.INTERNAL_ERROR:
                    message = l.internal_error;
                  case ResponseTypes.USER_WITH_EMAIL_NOTFOUND:
                    message = l.user_with_email_notFound(emailInputKey.currentState!.getController().text);
                    break;
                  default:
                }

                fToast.showToast(
                  child: ErrorToast(message: message),
                  gravity: ToastGravity.TOP,
                  toastDuration: Duration(seconds: 2),
                );
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
      } finally {setState(() => isLoading = false );}

    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context)!;

    fToast.init(context);

    return Scaffold(
      appBar: AppBar( title: Text(l.reset_password) ),
      body: Center( // Wrap with Center widget
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      EmailInput(key: emailInputKey,enabled: !isLoading),
                      SizedBox(height: 16),
                      FormSubmitButton(onPressed: () => onSubmit(l),enabled: !isLoading)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
