import 'package:flutter/material.dart';
import 'package:grace_bomb/bottom_bar.dart';
import 'package:grace_bomb/map.dart';
import 'package:grace_bomb/top_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Map(),
                // TopBar(),
              ],
            ),
          ),
          // BottomBar()
        ],
      );
}
