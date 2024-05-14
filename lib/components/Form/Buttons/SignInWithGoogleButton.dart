import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:tasktrove/helpers/SignWithGoogleHelper.dart';
import 'package:tasktrove/providers/theme_provider.dart';

class SignWithGoogleButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final l = AppLocalizations.of(context)!;
    ThemeProvider currentTheme = Provider.of<ThemeProvider>(context);

    return Container(
      width: double.infinity,
      child: SignInButton(
        currentTheme.isDarkTheme() ? Buttons.googleDark : Buttons.google,
        text: l.signin_with_google,
        onPressed: ()  async{
          await SignWithGoogleHelper.signInWithGoogle(context);
        },
      ),
    );
  }
}
