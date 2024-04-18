import 'package:flutter_dotenv/flutter_dotenv.dart';

// Laden der .env Datei
String? apiKey = dotenv.env['APIURL'];
bool debugMode = dotenv.env['DEBUG'] == 'true';
