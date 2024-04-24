import 'package:flutter/material.dart';
import 'package:grace_bomb/map.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MapView(),
                // TopBar(),
              ],
            ),
          ),
          // BottomBar()
        ],
      );
}
