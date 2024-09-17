import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grace_bomb/app_colors.dart';
import 'package:grace_bomb/app_styles.dart';
import 'package:grace_bomb/assets.dart';
import 'package:grace_bomb/dropped_bomb.dart';
import 'package:grace_bomb/map.dart';
import 'package:intl/intl.dart';

final dateFormat = DateFormat('M/d/yy');

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
    final headerWidth = screenWidth - 80;

    return Stack(children: [
      Positioned(
        bottom: bottomMargin,
        width: screenWidth,
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
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
                  width: screenWidth - 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bomb.title,
                        maxLines: 1,
                        style: AppStyles.heading,
                      ),
                      Row(
                        children: [
                          Column(children: [
                            Container(
                                width: headerWidth * 0.6,
                                child: Text(
                                  bomb.locationName,
                                  maxLines: 1,
                                  style: AppStyles.subHeading,
                                ))
                          ]),
                          Column(children: [
                            Container(
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
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BombDetailPage(bomb: bomb),
                      ),
                    );
                  },
                  child: Text(
                    " read more...",
                    style: AppStyles.body.copyWith(color: Colors.blue),
                  ),
                ),
              ],
            ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(bomb.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bomb.description,
              style: AppStyles.body,
            ),
            SizedBox(height: 10),
            Text(
              'Location: ${bomb.locationName}',
              style: AppStyles.subHeading,
            ),
            SizedBox(height: 10),
            Text(
              'Date: ${dateFormat.format(bomb.createdDate)}',
              style: AppStyles.subHeading,
            ),
          ],
        ),
      ),
    );
  }
}
