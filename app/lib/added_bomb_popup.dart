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
              Container(
                margin: const EdgeInsets.only(
                    top: 8, left: 16), // Move shadow 10px down
                child:
                    SvgPicture.asset(Assets.bombExplosionShadow), // Shadow SVG
              ),
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
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(left: 20),
                              width: 160, // Limit title width
                              child: Text(
                                title.isEmpty ? '#NewGraceBomb!' : title,
                                style: title.length > 15
                                    ? AppStyles.heading.copyWith(fontSize: 16)
                                    : AppStyles.heading,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            width: 160, // Limit text width
                            child: Text(
                              description.isEmpty
                                  ? 'No story provided...'
                                  : description,
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
