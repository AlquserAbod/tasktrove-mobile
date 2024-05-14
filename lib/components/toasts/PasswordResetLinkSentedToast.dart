import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordResetLinkSentedToast extends StatelessWidget {
  final String email;

  PasswordResetLinkSentedToast({required this.email});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mark_email_unread),
          SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: Text(
              style: TextStyle(color: Colors.white),
              l.reset_password_email_sented(email),
              softWrap: true, // Enable word wrapping
            ),
          ),
        ],
      ),
    );
  }
}
