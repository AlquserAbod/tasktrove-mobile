import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

const String serverUrl = "https://tasktrove-server.vercel.app";
const String apiUrl = 'https://tasktrove-server.vercel.app/api';
final SecretKey jwtSecretKey = SecretKey('d1mR8nniTwmd1QAecOMF2chbiyyQxHxCQx6j7cJT');

enum TaskColor {
  RED,
  BLUE,
  GREEN,
  YELLOW,
  ORANGE,
  PURPLE,
  CYAN,
  MAGENTA,
  TEAL,
  PINK,
}

const Map<TaskColor, String> colorValues = {
  TaskColor.RED: 'red',
  TaskColor.BLUE: 'blue',
  TaskColor.GREEN: 'green',
  TaskColor.YELLOW: 'yellow',
  TaskColor.ORANGE: 'orange',
  TaskColor.PURPLE: 'purple',
  TaskColor.CYAN: 'cyan',
  TaskColor.MAGENTA: 'magenta',
  TaskColor.TEAL: 'teal',
  TaskColor.PINK: 'pink',
};

TaskColor? getColorByName(String colorName) {
  for (var entry in colorValues.entries) {
    if (entry.value == colorName) {
      return entry.key;
    }
  }
  return null; // Return null if colorName is not found
}