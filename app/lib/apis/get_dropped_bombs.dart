import 'dart:convert';
import 'dart:math';
import 'package:grace_bomb/app_settings.dart';
import 'package:grace_bomb/dropped_bomb.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

final random = Random();
List<DroppedBomb>? jsonBombs;
final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");

Future<List<DroppedBomb>> getDroppedBombs(
  double northBoundary,
  double eastBoundary,
  double southBoundary,
  double westBoundary,
) async {
  final uri = Uri.https(
    AppSettings.apiAuthority,
    'api/getDroppedBombs',
    {
      'code': AppSettings.apiCode,
    },
  );
  Response response;
  try {
    response = await http.get(uri);
  } catch (exception) {
    return [];
  }
  if (response.statusCode != 200) {
    return [];
  }

  final List<dynamic> parsedJson = jsonDecode(response.body);
  final bombs = parsedJson
      .map((json) => DroppedBomb(
            json['Id'],
            json['Title'],
            json['Description'],
            json['Latitude'],
            json['Longitude'],
            json['LocationName'],
            dateFormat.parse(json['CreatedDate']),
          ))
      .toList();

  return bombs
      .where((bomb) =>
          bomb.latitude >= southBoundary &&
          bomb.latitude <= northBoundary &&
          bomb.longitude >= westBoundary &&
          bomb.longitude <= eastBoundary)
      .toList();
}
