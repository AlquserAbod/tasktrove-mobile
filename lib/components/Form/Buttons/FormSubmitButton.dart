import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final bool enabled;

  const FormSubmitButton({
    Key? key,
    required this.onPressed,
    this.enabled = true,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0), 
      child: SizedBox(
        width: double.infinity,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child:  ElevatedButton(
            onPressed: enabled ? onPressed : null,
            child: Text(text ?? l.submit, style: TextStyle(fontSize: 22),),
          ) ,
        )
      ),
    );
  }
}
