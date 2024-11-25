import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grace_bomb/app_colors.dart';
import 'package:grace_bomb/app_styles.dart';
import 'package:grace_bomb/assets.dart';
import 'package:grace_bomb/dropped_bomb.dart';
import 'package:grace_bomb/map.dart';
import 'package:intl/intl.dart';

final dateFormat = DateFormat('M/d/yy');

String getFormattedBombTitle(String title) {
  if (title.trim().isEmpty || title == 'no title') {
    return "GraceBomb";
  }

  // Remove spaces and capitalize first letter of each word
  final words = title.split(' ').where((word) => word.isNotEmpty);
  return words.map((word) => word[0].toUpperCase() + word.substring(1)).join();
}

class SelectedBombPopup extends StatelessWidget {
  final DroppedBomb bomb;

  const SelectedBombPopup({super.key, required this.bomb});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final bottomMargin = screenSize.height / 4 +
        (DroppedBombMarker.defaultHeight *
            DroppedBombMarker.selectedScaleFactor /
            2);
    const double margin = 10;
    const double padding = 10;
    const bombLogoWidth = 40;
    final bodyWidth = screenWidth - margin * 2 - padding * 2;
    final headerWidth = bodyWidth - bombLogoWidth;
    final bombTitle = getFormattedBombTitle(bomb.title);

    return Stack(children: [
      Positioned(
        bottom: bottomMargin,
        width: screenWidth,
        child: Container(
          margin: const EdgeInsets.all(margin),
          padding: const EdgeInsets.all(padding),
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
                  width: headerWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#$bombTitle',
                        maxLines: 1,
                        style: AppStyles.heading,
                      ),
                      Row(
                        children: [
                          Column(children: [
                            SizedBox(
                                width: headerWidth * 0.6,
                                child: Text(
                                  bomb.locationName,
                                  maxLines: 1,
                                  style: AppStyles.subHeading,
                                ))
                          ]),
                          Column(children: [
                            SizedBox(
                                width: headerWidth * 0.4,
                                child: Text(
                                  ' ${dateFormat.format(bomb.createdDate)}',
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    bomb.description,
                    maxLines: 4,
                    style: AppStyles.body,
                  ),
                )
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BombDetailPage(bomb: bomb),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: bodyWidth,
                    child: Text(
                      "READ MORE",
                      style: AppStyles.body.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    ]);
  }
}

class BombDetailPage extends StatelessWidget {
  final DroppedBomb bomb;

  const BombDetailPage({super.key, required this.bomb});

  @override
  Widget build(BuildContext context) {
    final bombTitle = getFormattedBombTitle(bomb.title);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(Assets.wildBombWhiteHorizontalSvg),
            const SizedBox(width: 16.0),
            Text(
              '#$bombTitle',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE85124),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16.0),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              bomb.locationName,
              style: AppStyles.subHeading,
            ),
            const SizedBox(height: 10),
            Text(
              dateFormat.format(bomb.createdDate),
              style: AppStyles.subHeading,
            ),
            const SizedBox(height: 12),
            Text(
              bomb.description,
              style: AppStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
