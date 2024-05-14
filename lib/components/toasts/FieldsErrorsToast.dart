import 'package:flutter/material.dart';

class ErrorToast extends StatelessWidget {
  final String message;

  ErrorToast({required this.message});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded),
          SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: Text(
              message,
              
              softWrap: true, // Enable word wrapping
            ),
          ),
        ],
      ),
    );
  }
}
