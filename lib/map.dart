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
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> with TickerProviderStateMixin {
  late final animatedMapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );

  @override
  Widget build(BuildContext context) => FlutterMap(
        mapController: animatedMapController.mapController,
        options: const MapOptions(
            initialCenter: Map.defaultPosition,
            initialZoom: 15,
            interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all ^ InteractiveFlag.rotate)),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          DroppedBombsLayer(
            animatedMapController: animatedMapController,
          )
        ],
      );
}

class DroppedBombsLayer extends StatefulWidget {
  final AnimatedMapController animatedMapController;

  const DroppedBombsLayer({super.key, required this.animatedMapController});

  @override
  State<StatefulWidget> createState() => DroppedBombsLayerState();
}

class DroppedBombsLayerState extends State<DroppedBombsLayer> {
  final List<DroppedBomb> droppedBombs = [];
  DroppedBomb? selectedBomb;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final controller = MapController.of(context);
      controller.mapEventStream.listen(handleMapPositionChange);
      final camera = MapCamera.of(context);
      await loadBombsInCameraView(camera);
    });
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
              isSelected: droppedBomb == selectedBomb,
              onTap: handleBombTap,
            ),
          ),
        )
        .toList();

    return MarkerLayer(markers: markers);
  }

  void handleBombTap(DroppedBomb tappedBomb) => setState(() {
        if (tappedBomb == selectedBomb) {
          selectedBomb = null;
        } else {
          selectedBomb = tappedBomb;

          widget.animatedMapController.animateTo(
              dest: LatLng(tappedBomb.latitude, tappedBomb.longitude));
        }
      });

  Future<void> handleMapPositionChange(MapEvent event) async {
    switch (event) {
      case MapEventMoveEnd():
      case MapEventRotateEnd():
      case MapEventDoubleTapZoomEnd():
      case MapEventFlingAnimationEnd():
        await loadBombsInCameraView(event.camera);
    }
  }

  Future<void> loadBombsInCameraView(MapCamera camera) async {
    final newBombs = await getDroppedBombs(
      camera.visibleBounds.north,
      camera.visibleBounds.east,
      camera.visibleBounds.south,
      camera.visibleBounds.west,
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
