import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:grace_bomb/app_settings.dart';

class SaveNewBombRequest {
  final double latitude;
  final double longitude;
  final String title;
  final String description;
  final String locationName;

  SaveNewBombRequest({
    required this.latitude,
    required this.longitude,
    this.title = '',
    this.description = '',
    this.locationName = '',
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'title': title,
        'description': description,
        'locationName': locationName,
      };
}

Future<void> saveNewBomb(SaveNewBombRequest request) async {
  final url = Uri.parse('${AppSettings.apiAuthority}/api/SaveNewBomb');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-functions-key': AppSettings.apiCode,
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save bomb: ${response.body}');
    }
  } catch (e) {
    throw Exception('Network error while saving bomb: $e');
  }
}
