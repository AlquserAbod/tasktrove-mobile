import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final bool enabled;

  const SubmitButton({
    Key? key,
    required this.onPressed,
    this.enabled = true,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green[500]),
        ),
        
        child: Text(
          text ?? l.submit,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
        ),
      ),
    );
  }
}
