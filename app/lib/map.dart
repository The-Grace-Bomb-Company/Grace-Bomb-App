import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grace_bomb/app_colors.dart';
import 'package:grace_bomb/app_styles.dart';
import 'package:grace_bomb/assets.dart';
import 'package:grace_bomb/dropped_bomb.dart';
import 'package:grace_bomb/selected_bomb_popup.dart';
import 'package:grace_bomb/apis/get_dropped_bombs.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  static const defaultPosition = LatLng(30.41216, -91.18401);

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> with TickerProviderStateMixin {
  final mapController = MapController();
  late final animatedMapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    mapController: mapController,
  );

  final Map<String, DroppedBomb> droppedBombs = {};

  DroppedBomb? selectedBomb;
  bool droppingStarted = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final buttonPadding = EdgeInsets.only(
      left: mediaQuery.size.width * 0.2,
      right: mediaQuery.size.width * 0.2,
      bottom: mediaQuery.size.height * 0.05,
    );
//++++
    final dropBombMarginBottom = mediaQuery.size.height * 0.25;
    final dropBombMarginLeft = mediaQuery.size.width * 0.5 -
        (DroppedBombMarker.defaultWidth *
            DroppedBombMarker.selectedScaleFactor /
            2);
    final dropBombPopupMarginBottom = dropBombMarginBottom +
        (DroppedBombMarker.defaultHeight *
            DroppedBombMarker.selectedScaleFactor /
            2);
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    const double dropBombPopupMargin = 10;
    const double dropBombPopupPadding = 10;
    const bombLogoWidth = 40;
    final dropBombPopupbodyWidth =
        screenWidth - dropBombPopupMargin * 2 - dropBombPopupPadding * 2;
    final dropBombPopupheaderWidth = dropBombPopupbodyWidth - bombLogoWidth;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              droppingStarted = false;
            });
          },
          child: FlutterMap(
            mapController: animatedMapController.mapController,
            options: MapOptions(
              initialCenter: MapView.defaultPosition,
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
                markers: DroppedBombMarker.createMarkers(
                    droppedBombs.values, selectedBomb, handleBombTap),
              ),
            ],
          ),
        ),
        selectedBomb == null
            ? const SizedBox.shrink()
            : SelectedBombPopup(bomb: selectedBomb!),
        if (!droppingStarted)
          Positioned(
            bottom: buttonPadding.bottom,
            left: buttonPadding.left,
            right: buttonPadding.right,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    droppingStarted = !droppingStarted;
                  });
                },
                child: SvgPicture.asset(
                  Assets.bombAddNew,
                ),
              ),
            ),
          ),
        if (droppingStarted)
          Positioned(
            bottom: dropBombPopupMarginBottom,
            width: screenWidth,
            child: Container(
              margin: const EdgeInsets.all(dropBombPopupMargin),
              padding: const EdgeInsets.all(dropBombPopupPadding),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [standardShadow]),
              child: Column(children: [
                Row(
                  children: [
                    SvgPicture.asset(Assets.wildBombOnMapSvg),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      width: dropBombPopupheaderWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Grace Bomb',
                            maxLines: 1,
                            style: AppStyles.heading,
                          ),
                          Row(
                            children: [
                              Column(children: [
                                SizedBox(
                                    width: dropBombPopupheaderWidth * 0.6,
                                    child: Text(
                                      "p.holder 111111",
                                      maxLines: 1,
                                      style: AppStyles.subHeading,
                                    ))
                              ]),
                              Column(children: [
                                SizedBox(
                                    width: dropBombPopupheaderWidth * 0.4,
                                    child: Text(
                                      ' placeholder',
                                      maxLines: 1,
                                      style: AppStyles.subHeading,
                                    ))
                              ])
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        if (droppingStarted)
          Positioned(
            bottom: dropBombMarginBottom,
            left: dropBombMarginLeft,
            child: Center(
              child: SvgPicture.asset(
                Assets.wildBombOnMapSvg,
              ),
            ),
          ),
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
      // position two-thirds down the screen. Subtract half screen height to account for map positioning relative to center.
      final yOffset =
          mediaQuery.size.height * 3 / 4 - mediaQuery.size.height / 2;
      animatedMapController.animateTo(
          dest: LatLng(tappedBomb.latitude, tappedBomb.longitude),
          offset: Offset(0, yOffset),
          zoom: 15);
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
    final newBombs = (await getDroppedBombs(
      mapController.camera.visibleBounds.north,
      mapController.camera.visibleBounds.east,
      mapController.camera.visibleBounds.south,
      mapController.camera.visibleBounds.west,
    ))
        .map((bomb) => MapEntry(bomb.id, bomb));
    setState(() {
      droppedBombs.addEntries(newBombs);
    });
  }
}

class DroppedBombMarker extends StatelessWidget {
  final DroppedBomb droppedBomb;
  final void Function(DroppedBomb tappedBomb)? onTap;

  static const defaultHeight = 52.0;
  static const defaultWidth = 28.0;
  static const selectedScaleFactor = 1.1;

  const DroppedBombMarker({
    super.key,
    required this.droppedBomb,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [standardShadow]),
      child: GestureDetector(
        onTap: () => onTap?.call(droppedBomb),
        child: SvgPicture.asset(
          Assets.wildBombOnMapSvg,
        ),
      ),
    );
  }

  static List<Marker> createMarkers(Iterable<DroppedBomb> droppedBombs,
      DroppedBomb? selectedBomb, void Function(DroppedBomb) handleBombTap) {
    return droppedBombs.map(
      (droppedBomb) {
        final isSelected = droppedBomb == selectedBomb;
        final (height, width) = switch (isSelected) {
          true => (
              defaultHeight * selectedScaleFactor,
              defaultWidth * selectedScaleFactor
            ),
          _ => (defaultHeight, defaultWidth)
        };

        return Marker(
          point: LatLng(droppedBomb.latitude, droppedBomb.longitude),
          height: height,
          width: width,
          child: DroppedBombMarker(
            droppedBomb: droppedBomb,
            onTap: handleBombTap,
          ),
        );
      },
    ).toList();
  }
}

final standardShadow = BoxShadow(
    color: AppColors.black.withOpacity(0.25),
    blurRadius: 10,
    spreadRadius: 0,
    offset: const Offset(0, 4));
