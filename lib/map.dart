import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatelessWidget {
  const Map({super.key});

  static const defaultPosition = LatLng(30.41216, -91.18401);

  @override
  Widget build(BuildContext context) => FlutterMap(
        options:
            const MapOptions(initialCenter: defaultPosition, initialZoom: 15),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          DroppedBombsLayer()
        ],
      );
}

class DroppedBombsLayer extends StatelessWidget {
  const DroppedBombsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.of(context);
    final height = camera.visibleBounds.north - camera.visibleBounds.south;
    final width = camera.visibleBounds.west - camera.visibleBounds.east;

    final random = Random(camera.hashCode);
    randomPosition() => LatLng(
          random.nextDouble() * height + camera.visibleBounds.south,
          random.nextDouble() * width + camera.visibleBounds.east,
        );

    final randomBombs = List.generate(
      10,
      (index) => Marker(
        point: randomPosition(),
        height: 60,
        child: SvgPicture.asset(
          'assets/wild-bomb.svg',
        ),
      ),
    );

    return MarkerLayer(
      alignment: Alignment.topCenter,
      markers: randomBombs,
    );
  }
}
