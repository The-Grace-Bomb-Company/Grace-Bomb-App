import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grace_bomb/app_styles.dart';
import 'package:grace_bomb/assets.dart';
import 'package:grace_bomb/map.dart';

class AddedBombPopup extends StatelessWidget {
  final String title;
  final String description;

  const AddedBombPopup(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bottomMargin = screenSize.height / 5 +
        (DroppedBombMarker.defaultHeight *
            DroppedBombMarker.selectedScaleFactor /
            2);

    return Stack(
      children: [
        Positioned(
          bottom: bottomMargin,
          left: (screenSize.width - 220) / 2, // Center the popup
          width: 220,
          child: Stack(
            children: [
              SvgPicture.asset(Assets.bombExplosionShadow), // Shadow SVG
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Stack(
                  children: [
                    SvgPicture.asset(
                        Assets.bombExplosionBackground), // Background SVG
                    Padding(
                      padding: const EdgeInsets.only(top: 70), // Move text down
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 25),
                                      width: 180, // Limit title width
                                      child: Text(
                                        title,
                                        style: AppStyles.heading,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            width: 180, // Limit text width
                            child: Text(
                              description,
                              maxLines: 3,
                              style: AppStyles.body,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
