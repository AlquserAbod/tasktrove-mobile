import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInSingleton {
  static final GoogleSignInSingleton _instance = GoogleSignInSingleton._internal();

  factory GoogleSignInSingleton() {
    return _instance;
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['profile', 'email'],
    
  );

  GoogleSignIn get googleSignIn => _googleSignIn;

  GoogleSignInSingleton._internal();
}