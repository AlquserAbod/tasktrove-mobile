import 'package:flutter/material.dart';

class SuccessToast extends StatelessWidget {
  final String text;

  SuccessToast({required this.text});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: Text(
              style: TextStyle(color: Colors.white),
              text,
              softWrap: true, // Enable word wrapping
            ),
          ),
        ],
      ),
    );
  }
}

