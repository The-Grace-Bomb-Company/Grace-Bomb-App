import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grace_bomb/web_apis/get_dropped_bombs.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatelessWidget {
  const Map({super.key});

  static const defaultPosition = LatLng(30.41216, -91.18401);

  @override
  Widget build(BuildContext context) => FlutterMap(
        options: const MapOptions(
            initialCenter: defaultPosition,
            initialZoom: 15,
            interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all ^ InteractiveFlag.rotate)),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          const DroppedBombsLayer()
        ],
      );
}

class DroppedBombsLayer extends StatefulWidget {
  const DroppedBombsLayer({super.key});

  @override
  State<StatefulWidget> createState() => DroppedBombsLayerState();
}

class DroppedBombsLayerState extends State<DroppedBombsLayer> {
  final List<DroppedBomb> droppedBombs = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final controller = MapController.of(context);
      controller.mapEventStream.listen(handleMapPositionChange);

      final camera = MapCamera.of(context);
      final initBombs = await getDroppedBombs(
        camera.visibleBounds.north,
        camera.visibleBounds.east,
        camera.visibleBounds.south,
        camera.visibleBounds.west,
      );
      setState(() {
        droppedBombs.addAll(initBombs);
      });
    });
  }

  Future<void> handleMapPositionChange(MapEvent event) async {
    switch (event) {
      case MapEventMoveEnd():
      case MapEventRotateEnd():
      case MapEventDoubleTapZoomEnd():
      case MapEventFlingAnimationEnd():
        final newBombs = await getDroppedBombs(
          event.camera.visibleBounds.north,
          event.camera.visibleBounds.east,
          event.camera.visibleBounds.south,
          event.camera.visibleBounds.west,
        );
        setState(() {
          droppedBombs.addAll(newBombs);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final markers = droppedBombs
        .map(
          (droppedBomb) => Marker(
            point: LatLng(droppedBomb.latitude, droppedBomb.longitude),
            height: 60,
            child: DroppedBombMarker(
              droppedBomb: droppedBomb,
            ),
          ),
        )
        .toList();

    return MarkerLayer(markers: markers);
  }
}

class DroppedBombMarker extends StatefulWidget {
  final DroppedBomb droppedBomb;
  final void Function(DroppedBomb droppedBomb)? onTap;

  const DroppedBombMarker({super.key, required this.droppedBomb, this.onTap});

  @override
  State<StatefulWidget> createState() => DroppedBombMarkerState();
}

class DroppedBombMarkerState extends State<DroppedBombMarker> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final assetPath =
        isSelected ? 'assets/wild-bomb-outlined.svg' : 'assets/wild-bomb.svg';

    return GestureDetector(
      onTap: () => setState(() {
        isSelected = !isSelected;
      }),
      child: SvgPicture.asset(
        assetPath,
      ),
    );
  }
}
