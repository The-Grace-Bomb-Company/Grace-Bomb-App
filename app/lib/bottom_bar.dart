import 'package:flutter/material.dart';
import 'package:grace_bomb/app_colors.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final actionButtons = [
      Icons.map,
      Icons.groups,
      Icons.notifications,
      Icons.book,
      Icons.manage_accounts
    ]
        .map((icon) => IconButton(
              icon: Icon(icon),
              color: AppColors.lightYellow,
              onPressed: () {},
              iconSize: 30,
            ))
        .toList();

    return Container(
      color: AppColors.black,
      child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: actionButtons,
            ),
          )),
    );
  }
}
