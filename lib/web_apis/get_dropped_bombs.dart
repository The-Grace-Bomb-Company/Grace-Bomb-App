import 'dart:math';
import 'package:lorem_ipsum_generator/lorem_ipsum_generator.dart';

final random = Random();

Future<List<DroppedBomb>> getDroppedBombs(
  double northBoundary,
  double eastBoundary,
  double southBoundary,
  double westBoundary,
) async {
  final height = northBoundary - southBoundary;
  final width = westBoundary - eastBoundary;

  generateRandomBomb(int index) => DroppedBomb(
        random.nextInt(1 << 32).toString(),
        LoremIpsumGenerator.generate(words: 4),
        LoremIpsumGenerator.generate(words: 30),
        random.nextDouble() * height + southBoundary,
        random.nextDouble() * width + eastBoundary,
      );

  await Future.delayed(const Duration(milliseconds: 250));

  return List.generate(
    3,
    generateRandomBomb,
  );
}

class DroppedBomb {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  DroppedBomb(
      this.id, this.title, this.description, this.latitude, this.longitude);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is DroppedBomb) {
      return hashCode == other.hashCode;
    }
    return false;
  }
}
