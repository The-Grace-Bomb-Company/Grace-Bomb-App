import 'package:flutter/material.dart';
import 'package:grace_bomb/home.dart';

const primaryOrange = Color.fromARGB(255, 232, 81, 36);
const lightYellow = Color.fromARGB(255, 249, 242, 188);

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Home(),
      ),
    ),
  );
}
