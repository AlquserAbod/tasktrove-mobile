import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

const String serverUrl = "https://tasktrove-server.vercel.app";
const String apiUrl = 'https://tasktrove-server.vercel.app/api';
final SecretKey jwtSecretKey = SecretKey('d1mR8nniTwmd1QAecOMF2chbiyyQxHxCQx6j7cJT');

enum Color {
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

const Map<Color, String> colorValues = {
  Color.RED: 'red',
  Color.BLUE: 'blue',
  Color.GREEN: 'green',
  Color.YELLOW: 'yellow',
  Color.ORANGE: 'orange',
  Color.PURPLE: 'purple',
  Color.CYAN: 'cyan',
  Color.MAGENTA: 'magenta',
  Color.TEAL: 'teal',
  Color.PINK: 'pink',
};