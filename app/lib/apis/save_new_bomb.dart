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
        'Latitude': latitude,
        'Longitude': longitude,
        'Title': title,
        'Description': description,
        'LocationName': locationName,
        'IsAprroved': false,
      };
}

Future<void> saveNewBomb(SaveNewBombRequest request) async {
  Uri uri;
  String endpoint = 'api/SaveNewBomb';
  if (AppSettings.isDebug) {
    uri = Uri.http(
      AppSettings.apiAuthority,
      endpoint,
      {},
    );
  } else {
    uri = Uri.https(
      AppSettings.apiAuthority,
      endpoint,
      {
        'code': AppSettings.apiCode,
      },
    );
  }

  try {
    final response = await http.post(
      uri,
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
