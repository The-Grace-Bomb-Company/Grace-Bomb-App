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
  Uri uri;
  String endpoint = 'api/getDroppedBombs';
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

  Response response;
  try {
    response = await http.get(uri);
  } catch (exception) {
    return [];
  }
  if (response.statusCode != 200) {
    return [];
  }

  final random = Random();
  final latOffset = (random.nextDouble() * 0.00018) - 0.00009;
  final lonOffset = (random.nextDouble() * 0.00018) - 0.00009;

  final List<dynamic> parsedJson = jsonDecode(response.body);
  final bombs = parsedJson
      .where((json) {
        final latitude = json['Latitude'];
        final longitude = json['Longitude'];
        return latitude >= southBoundary &&
            latitude <= northBoundary &&
            longitude >= westBoundary &&
            longitude <= eastBoundary;
      })
      .map((json) => DroppedBomb(
            json['Id'],
            json['Title'],
            json['Description'],
            json['Latitude'] + latOffset,
            json['Longitude'] - lonOffset,
            json['LocationName'],
            dateFormat.parse(json['CreatedDate']),
            json['IsApproved'],
          ))
      .toList();

  return bombs;
}
