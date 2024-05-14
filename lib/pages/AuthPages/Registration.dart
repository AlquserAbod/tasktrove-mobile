import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tasktrove/components/Form/Buttons/SignInWithGoogleButton.dart';
import 'package:tasktrove/components/Form/Inputs/EmailInput.dart';
import 'package:tasktrove/components/Form/Inputs/PasswordInput.dart';

import 'package:tasktrove/components/Form/Buttons/FormSubmitButton.dart';
import 'package:tasktrove/components/Form/ProfileImageField.dart';
import 'package:tasktrove/components/toasts/EmailVerifyeToast.dart';
import 'package:tasktrove/components/toasts/FieldsErrorsToast.dart';
import 'package:tasktrove/config.dart' as config;
import 'package:tasktrove/Singletons/DioSingleton.dart';
import 'package:tasktrove/pages/SettingsScreen.dart';
import 'package:tasktrove/response_types.dart';
import 'package:tasktrove/pages/AuthPages/Login.dart';
import 'package:tasktrove/providers/theme_provider.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegistrationPage> {
  TextEditingController _usernameController = TextEditingController();
  io.File? _selectedAvatar;
  bool isLoading = false;

  GlobalKey<EmailInputState> emailInputKey = GlobalKey<EmailInputState>();
  GlobalKey<PasswordInputState> passwordInputKey = GlobalKey<PasswordInputState>();
  GlobalKey<PasswordInputState> verifyPasswordInputKey = GlobalKey<PasswordInputState>();


  FToast fToast = FToast();


  String? _usernameValidator(value, AppLocalizations l){
    if (value == null || value.isEmpty) {
      return '${l.username} ${l.is_required}';
    }
    return null;
  }


  final GlobalKey<FormState> _formKey = GlobalKey(); 
  
  void onSubmit(AppLocalizations l) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Dio dio = DioSingleton().dioInstance;

      try {
        var formData = FormData.fromMap({
          "username": _usernameController.value.text,
          "email": emailInputKey.currentState!.getController().text,
          "password": passwordInputKey.currentState!.getController().text,
          "passwordVerify": verifyPasswordInputKey.currentState!.getController().text,
          "avatar": _selectedAvatar != null ? await MultipartFile.fromFile(_selectedAvatar!.path, filename: "avatar.jpg") : null, 
        });
        
        var response = await dio.post('${config.apiUrl}/auth', data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ));

        Map<String, dynamic> data = response.data;

        if(data['success']) {

          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SettingsPage()));

          fToast.showToast(
            child: EmailVerifyeToast(email: emailInputKey.currentState!.getController().text),
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
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context)!;

    fToast.init(context);

    return Scaffold(
      appBar: AppBar( title: Text(l.register) ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  ProfileImageField(
                    onImageSelected: (_selectedImage) => 
                      setState(() => _selectedAvatar = _selectedImage)
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    enabled: !isLoading,
                    controller: _usernameController,
                    validator: (value) => _usernameValidator(value,l),
                    decoration: InputDecoration(
                      labelText: l.username,
                    ),
                  ),
                  SizedBox(height: 16),
                  EmailInput(key: emailInputKey,enabled: !isLoading),
                  SizedBox(height: 16),
                  PasswordInput(key: passwordInputKey,enabled: !isLoading,),
                  SizedBox(height: 16),
                  PasswordInput(key: verifyPasswordInputKey,enabled: !isLoading,type: PasswordInputTypes.verifyPassword),


                  SizedBox(height: 16),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      l.already_have_account,
                      style: TextStyle(
                        color: Provider.of<ThemeProvider>(context).themeData.dividerColor, 
                        fontSize: 16, 
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  FormSubmitButton(onPressed: () => onSubmit(l),enabled: !isLoading),

                  SizedBox(height: 8),
                  SignWithGoogleButton()
                  
                ],
              ),
            )
          ],
        ),
        ),
      )
    );
  }
}
