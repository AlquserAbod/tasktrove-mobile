import 'package:flutter/material.dart';

Color getColor(String colorName) {
  switch (colorName) {
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'yellow':
      return Colors.yellow;
    case 'orange':
      return Colors.orange;
    case 'purple':
      return Colors.purple;
    case 'cyan':
      return Colors.cyan;
    case 'magenta':
      return Colors.pinkAccent;
    case 'teal':
      return Colors.teal;
    case 'pink':
      return Colors.pink;
    default:
      return Colors.grey;
  }
}