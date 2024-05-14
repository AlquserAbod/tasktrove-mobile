import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tasktrove/LocalStorage/AuthStorage.dart';
import 'package:tasktrove/components/Form/Buttons/SignInWithGoogleButton.dart';
import 'package:tasktrove/components/Form/Inputs/EmailInput.dart';
import 'package:tasktrove/components/Form/Inputs/PasswordInput.dart';

import 'package:tasktrove/components/Form/Buttons/FormSubmitButton.dart';
import 'package:tasktrove/components/toasts/EmailVerifyeToast.dart';
import 'package:tasktrove/components/toasts/FieldsErrorsToast.dart';
import 'package:tasktrove/config.dart' as config;
import 'package:tasktrove/Singletons/DioSingleton.dart';
import 'package:tasktrove/pages/AuthPages/ResetPassword.dart';
import 'package:tasktrove/pages/SettingsScreen.dart';
import 'package:tasktrove/response_types.dart';
import 'package:tasktrove/pages/AuthPages/Registration.dart';
import 'package:tasktrove/providers/theme_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GlobalKey<EmailInputState> emailInputKey = GlobalKey<EmailInputState>();
  GlobalKey<PasswordInputState> passwordInputKey = GlobalKey<PasswordInputState>();

  bool isLoading = false;

  FToast fToast = FToast();

  final GlobalKey<FormState> _formKey = GlobalKey(); 
  
  void onSubmit(BuildContext context,AppLocalizations l) async {    
    if (_formKey.currentState!.validate()) {

      setState(() => isLoading = true );

      Dio dio = DioSingleton().dioInstance;

      try {

        var response = await dio.post('${config.apiUrl}/auth/login', data: {
          "email": emailInputKey.currentState!.getController().text,
          "password": passwordInputKey.currentState!.getController().text,
        });

        Map<String, dynamic> data = response.data;

        if(data['success']) {
          emailInputKey.currentState!.getController().clear();
          passwordInputKey.currentState!.getController().clear();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
          (route) => false, 
        );

         if(errorTypeMap[data['type']] == ResponseTypes.WAITING_VERIFY_EMAIL) {
            fToast.showToast(
              child: EmailVerifyeToast(email: emailInputKey.currentState!.getController().text),
              gravity: ToastGravity.TOP,
              toastDuration: Duration(seconds: 4),
            );
          }
          
          AuthStorage.setUserInStorage(data['token']);
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
                  case ResponseTypes.INVALID_CREDENTIALS:
                    message = l.invalid_credentials;
                    break;
                  case ResponseTypes.WAITING_VERIFY_EMAIL:
                    message = l.verification_email_sent(emailInputKey.currentState!.getController().text);
                    break;
                  case ResponseTypes.INTERNAL_ERROR:
                    message = l.internal_error;
                  default:
                }

                fToast.showToast(
                  child: errorTypeMap[errorJson['type']]  == ResponseTypes.WAITING_VERIFY_EMAIL ? 
                      EmailVerifyeToast(email: emailInputKey.currentState!.getController().text) :
                      ErrorToast(message: message),
                  gravity: ToastGravity.TOP,
                  toastDuration: Duration(seconds: 2),
                );

                if(errorTypeMap[errorJson['type']] == ResponseTypes.WAITING_VERIFY_EMAIL) {
                  emailInputKey.currentState!.getController().clear();
                  passwordInputKey.currentState!.getController().clear();
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
      } finally {setState(() => isLoading = false );}

    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context)!;

    fToast.init(context);

    return Scaffold(
      appBar: AppBar( title: Text(l.login) ),
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
                      PasswordInput(key: passwordInputKey,enabled:  !isLoading,),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                        },
                        child: Text(
                          l.dont_have_account,
                          style: TextStyle(
                            color: Provider.of<ThemeProvider>(context).themeData.dividerColor, 
                            fontSize: 16, 
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
            
                      GestureDetector(
                        onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResetPasswordPage()));
                        },
                        child: Text(
                          l.forget_password,
                          style: TextStyle(
                            color: Provider.of<ThemeProvider>(context).themeData.dividerColor, 
                            fontSize: 16, 
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      FormSubmitButton(onPressed: () => onSubmit(context,l),enabled: !isLoading),
                      SizedBox(height: 8),
                      SignWithGoogleButton()
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
