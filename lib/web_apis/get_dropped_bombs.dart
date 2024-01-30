import 'dart:math';

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
        random.nextDouble() * height + southBoundary,
        random.nextDouble() * width + eastBoundary,
      );

  await Future.delayed(const Duration(milliseconds: 250));

  return List.generate(
    10,
    generateRandomBomb,
  );
}

class DroppedBomb {
  final double latitude;
  final double longitude;

  DroppedBomb(this.latitude, this.longitude);
}
