import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grace_bomb/web_apis/get_dropped_bombs.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  static const defaultPosition = LatLng(30.41216, -91.18401);

  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> with TickerProviderStateMixin {
  final mapController = MapController();
  late final animatedMapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    mapController: mapController,
  );

  final List<DroppedBomb> droppedBombs = [];

  DroppedBomb? selectedBomb;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: animatedMapController.mapController,
          options: MapOptions(
            initialCenter: Map.defaultPosition,
            initialZoom: 15,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all ^ InteractiveFlag.rotate,
            ),
            onMapEvent: handleMapEvent,
            onMapReady: loadBombsInCameraView,
            onTap: handleMapTap,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
            ),
            MarkerLayer(
              markers: droppedBombs
                  .map(
                    (droppedBomb) => Marker(
                      point:
                          LatLng(droppedBomb.latitude, droppedBomb.longitude),
                      height: 60,
                      child: DroppedBombMarker(
                        droppedBomb: droppedBomb,
                        isSelected: droppedBomb == selectedBomb,
                        onTap: handleBombTap,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        selectedBomb == null
            ? const SizedBox.shrink()
            : Stack(
                children: [
                  Center(
                    child: SvgPicture.asset('assets/bomb-preview-shadow.svg'),
                  ),
                  Center(
                    child:
                        SvgPicture.asset('assets/bomb-preview-background.svg'),
                  ),
                  Center(
                    child: Text(
                      selectedBomb!.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
      ],
    );
  }

  void handleMapTap(tapPosition, point) {
    setState(() {
      selectedBomb = null;
    });
  }

  void handleBombTap(DroppedBomb tappedBomb) {
    if (tappedBomb == selectedBomb) {
      setState(() {
        selectedBomb = null;
      });
    } else {
      setState(() {
        selectedBomb = tappedBomb;
      });

      final mediaQuery = MediaQuery.of(context);
      final yOffset =
          mediaQuery.size.height * 2 / 3 - mediaQuery.size.height / 2;
      animatedMapController.animateTo(
          dest: LatLng(tappedBomb.latitude, tappedBomb.longitude),
          offset: Offset(0, yOffset));
    }
  }

  Future<void> handleMapEvent(MapEvent event) async {
    switch (event) {
      case MapEventMoveEnd():
      case MapEventDoubleTapZoomEnd():
      case MapEventFlingAnimationEnd():
        await loadBombsInCameraView();
        break;
      case MapEventMoveStart():
      case MapEventDoubleTapZoomStart():
      case MapEventFlingAnimationStart():
        setState(() {
          selectedBomb = null;
        });
        break;
    }
  }

  Future<void> loadBombsInCameraView() async {
    final newBombs = await getDroppedBombs(
      mapController.camera.visibleBounds.north,
      mapController.camera.visibleBounds.east,
      mapController.camera.visibleBounds.south,
      mapController.camera.visibleBounds.west,
    );
    setState(() {
      droppedBombs.addAll(newBombs);
    });
  }
}

class DroppedBombMarker extends StatelessWidget {
  final DroppedBomb droppedBomb;
  final bool isSelected;
  final void Function(DroppedBomb tappedBomb)? onTap;

  const DroppedBombMarker(
      {super.key,
      required this.droppedBomb,
      this.onTap,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final assetPath =
        isSelected ? 'assets/wild-bomb-outlined.svg' : 'assets/wild-bomb.svg';

    return GestureDetector(
      onTap: () => onTap?.call(droppedBomb),
      child: SvgPicture.asset(
        assetPath,
      ),
    );
  }
}
