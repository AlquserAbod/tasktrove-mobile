import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum PasswordInputTypes { password, verifyPassword }

class PasswordInput extends StatefulWidget {
  final bool enabled;
  final PasswordInputTypes type;
  final String? labelText;

  const PasswordInput({
    Key? key,
    this.enabled = true,
    this.type = PasswordInputTypes.password,
    this.labelText,
  }) : super(key: key);

  @override
  PasswordInputState createState() => PasswordInputState();
}

class PasswordInputState extends State<PasswordInput> {
  late TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _passwordValidator(value,  AppLocalizations l){
    if(widget.type == PasswordInputTypes.password) {
      if (value == null || value.isEmpty) {
        return '${l.password} ${l.is_required}';
      } else if(value.length < 8) {
        return l.password_8_character_error;
      }
    } else if(widget.type == PasswordInputTypes.verifyPassword) {
      if(value != value) {
        return l.passwords_not_match;
      }
    }
    return null;
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
      validator: (value) => _passwordValidator(value, l),
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText ?? 
          (widget.type == PasswordInputTypes.password ? l.password : l.password_confirmation),
        suffixIcon: GestureDetector(
          onTap: () { setState(() => _obscureText = !_obscureText);},
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}
