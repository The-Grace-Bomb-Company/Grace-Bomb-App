import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:grace_bomb/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromPath("assets/app-settings.json");
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Home(),
      ),
    ),
  );
}
