import 'package:uuid/uuid.dart'; // Import the uuid package

String generateTaskId() {
  // Use the uuid package to generate a cryptographically secure random ID
  final uuid = Uuid();
  return uuid.v4(); // v4 generates a version 4 (random) UUID
}