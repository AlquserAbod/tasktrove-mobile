import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tasktrove/LocalStorage/AuthStorage.dart';
import 'package:tasktrove/components/Form/Inputs/EmailInput.dart';

import 'package:tasktrove/components/Form/Buttons/FormSubmitButton.dart';
import 'package:tasktrove/components/Form/ProfileImageField.dart';
import 'package:tasktrove/components/toasts/EmailVerifyeToast.dart';
import 'package:tasktrove/components/toasts/FieldsErrorsToast.dart';
import 'package:tasktrove/components/toasts/SuccessToast.dart';
import 'package:tasktrove/config.dart' as config;
import 'package:tasktrove/Singletons/DioSingleton.dart';
import 'package:tasktrove/pages/AuthPages/ChangePassword.dart';
import 'package:tasktrove/pages/SettingsScreen.dart';
import 'package:tasktrove/providers/theme_provider.dart';
import 'package:tasktrove/response_types.dart';


class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  TextEditingController _usernameController = TextEditingController();
  io.File? _selectedAvatar;
  bool isLoading = false;
  Map<String, dynamic>? user;

  GlobalKey<EmailInputState> emailInputKey = GlobalKey<EmailInputState>();


  FToast fToast = FToast();

  @override
  void initState() {
    super.initState();

    _initializeUser();
  }

  Future<void> _initializeUser() async {
    Map<String, dynamic>? userData = await AuthStorage.currentUser();
    
    setState(() {
      user = userData;
      _usernameController.text = user?['username'];
    });
  }



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
        MultipartFile? avatarFile; // Declare avatarFile outside of the if block

        if (_selectedAvatar != null) {
          avatarFile = await MultipartFile.fromFile(_selectedAvatar!.path, filename: "avatar.jpg");
        }



        var formData = FormData.fromMap({
          "username": _usernameController.value.text,
          "email": emailInputKey.currentState!.getController().text,
          "avatar": avatarFile, 
        });
        
        var response = await dio.put('${config.apiUrl}/auth/update', data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ));

        Map<String, dynamic> data = response.data;

        print(data);
        if(data['success']) {
          if(errorTypeMap[data['type']] == ResponseTypes.WAITING_VERIFY_EMAIL) {
            AuthStorage.removeUserFromStorage(context);
            Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => SettingsPage()),(_) => false);
            fToast.showToast(
              child: EmailVerifyeToast(email: emailInputKey.currentState!.getController().text),
              gravity: ToastGravity.TOP,
              toastDuration: Duration(seconds: 4),
            );
          }else {
          AuthStorage.setUserInStorage(data['token']);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            fToast.showToast(
              child: SuccessToast(text: l.updated_profile_successfuly),
              gravity: ToastGravity.TOP,
              toastDuration: Duration(seconds: 4),
            );
          } 
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

    if(user == null) return Container();

    return Scaffold(
      appBar: AppBar( title: Text(l.updateProfile) ),
      body: Center( 
        child: SingleChildScrollView(
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
                        setState(() => _selectedAvatar = _selectedImage),
                      imageUrl: user?['imagePath'] != null && user!['imagePath'].startsWith('http')
                        ? user!['imagePath']
                        : user?['imagePath'] != null
                          ? '${config.serverUrl}/${user!['imagePath']}'
                          : null,
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
                    EmailInput(key: emailInputKey,enabled: !isLoading, initialValue: user?['email']),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));
                      },
                      child: Text(
                        l.changePassword,
                        style: TextStyle(
                          color: Provider.of<ThemeProvider>(context).themeData.dividerColor, 
                          fontSize: 16, 
                        ),
                      ),
                    ),
                    FormSubmitButton(onPressed: () => onSubmit(l),enabled: !isLoading)
                  ],
                ),
              )
            ],
          ),
          ),
      )
    ));
  }
}
