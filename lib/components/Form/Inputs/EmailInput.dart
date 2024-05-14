import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:email_validator/email_validator.dart';

class EmailInput extends StatefulWidget {
  final bool enabled;
  final String? labelText;
  final String initialValue;

  const EmailInput({
    Key? key,
    this.enabled = true,
    this.labelText,
    this.initialValue = ''
  }) : super(key: key);

  @override
  EmailInputState createState() => EmailInputState();




}

class EmailInputState extends State<EmailInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.initialValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _emailValidator(String? email, AppLocalizations l) {
    if (email == null || email.isEmpty) {
      return '${l.email} ${l.is_required}';
    } else if (!EmailValidator.validate(email)) {
      return l.valid_email_format;
    }
    return null; // No error
  }
  
  TextEditingController getController() {
    return _controller;
  }
  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;

    return TextFormField(
      enabled: widget.enabled,
      controller: _controller,
      validator: (value) => _emailValidator(value, l),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: widget.labelText ?? l.email,
      ),
    );
  }
}
