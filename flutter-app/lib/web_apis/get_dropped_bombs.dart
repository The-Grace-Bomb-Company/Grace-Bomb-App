import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:grace_bomb/dropped_bomb.dart';
import 'package:intl/intl.dart';
import 'package:lorem_ipsum_generator/lorem_ipsum_generator.dart';

import '../assets.dart';

final random = Random();
List<DroppedBomb>? jsonBombs;
final dateFormat = DateFormat('MM/dd/yyyy HH:mm:ss');

Future<List<DroppedBomb>> getDroppedBombs(
  double northBoundary,
  double eastBoundary,
  double southBoundary,
  double westBoundary,
) async {
  return await getJsonAssetBombs(
      northBoundary, southBoundary, westBoundary, eastBoundary);
  // return await getRandomBombs(
  //     northBoundary, southBoundary, westBoundary, eastBoundary);
}

Future<List<DroppedBomb>> getJsonAssetBombs(
  double northBoundary,
  double eastBoundary,
  double southBoundary,
  double westBoundary,
) async {
  loadAsset() async {
    final jsonString = await rootBundle.loadString(Assets.bombStoriesJson);
    final List<dynamic> parsedJson = jsonDecode(jsonString);
    return parsedJson
        .map((j) => DroppedBomb(
              random.nextInt(1 << 32).toString(),
              LoremIpsumGenerator.generate(words: 4),
              j['Story'],
              double.parse(j['Latitude']),
              double.parse(j['Longitude']),
              j['FixedLocation'],
              dateFormat.parse(j['Date']),
            ))
        .toList();
  }

  jsonBombs ??= await loadAsset();

  return jsonBombs!
      .where((bomb) =>
          bomb.latitude >= southBoundary &&
          bomb.latitude <= northBoundary &&
          bomb.longitude >= westBoundary &&
          bomb.longitude <= eastBoundary)
      .toList();
}

Future<List<DroppedBomb>> getRandomBombs(
  double northBoundary,
  double southBoundary,
  double westBoundary,
  double eastBoundary,
) async {
  final height = northBoundary - southBoundary;
  final width = westBoundary - eastBoundary;

  generateRandomBomb(int index) => DroppedBomb(
        random.nextInt(1 << 32).toString(),
        LoremIpsumGenerator.generate(words: 4),
        LoremIpsumGenerator.generate(words: 30),
        random.nextDouble() * height + southBoundary,
        random.nextDouble() * width + eastBoundary,
        LoremIpsumGenerator.generate(words: 2),
        DateTime.now(),
      );

  await Future.delayed(const Duration(milliseconds: 250));

  return List.generate(
    3,
    generateRandomBomb,
  );
}
