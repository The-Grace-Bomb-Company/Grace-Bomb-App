import 'package:flutter/material.dart';
import 'package:grace_bomb/app_colors.dart';

class AppStyles {
  static const TextStyle body = TextStyle(
    fontSize: 12,
    height: 1.5,
    fontFamily: 'Montserrat',
  );

  static final TextStyle heading = body.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle subHeading =
      body.copyWith(height: 2, color: AppColors.textDarkGrey);
}
