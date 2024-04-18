import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../keys.dart';

class HttpService {
  // Hier hole ich mir die API URL aus der keys.dart Datei
  final String? baseUrl = apiKey;
  final storage = const FlutterSecureStorage();

  // der getHeader ist in den meistenfällen der gleiche, deswegen habe ich ihn in eine Methode ausgelagert
  Future<Map<String, String>> getHeaders() async {
    String? jwtToken = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };
  }

  // getAccessToken() gibt den access_token zurück
  Future<String?> getAccessToken() async {
    return null;
  }
}
