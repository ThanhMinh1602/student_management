import 'package:flutter_dotenv/flutter_dotenv.dart';

class RemoteConfig {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://localhost:3000/api';
}
