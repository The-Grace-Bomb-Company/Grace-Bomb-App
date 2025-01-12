import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grace_bomb/app_settings.dart';
import 'package:grace_bomb/app_styles.dart';
import 'package:grace_bomb/app_methods.dart';
import 'package:grace_bomb/assets.dart';
import 'package:grace_bomb/dropped_bomb.dart';
import 'package:intl/intl.dart';

final dateFormat = DateFormat('M/d/yy');

class BombDetailsPage extends StatelessWidget {
  final DroppedBomb bomb;

  const BombDetailsPage({super.key, required this.bomb});

  @override
  Widget build(BuildContext context) {
    String bombTitleTemp = '';
    String bombDescription = AppSettings.pendingApprovalDescription;
    if (bomb.isApproved) {
      bombTitleTemp = bomb.title;
      bombDescription = bomb.description;
    }
    final bombTitle = AppMethods.formatBombTitle(bombTitleTemp);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(Assets.wildBombWhiteHorizontalSvg),
            const SizedBox(width: 16.0),
            Text(
              bombTitle,
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
        child: SingleChildScrollView(
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
                bombDescription,
                style: AppStyles.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
