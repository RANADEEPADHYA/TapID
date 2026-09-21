import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class AppName extends StatelessWidget {
  const AppName({
    super.key,
    this.fontSize = 40,
    this.fontWeight = FontWeight.w600,
    this.color = AppColors.white,
    this.splitColor = false,
    this.tapColor = AppColors.white,
  });

  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final bool splitColor;
  final Color tapColor;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.lobsterTwo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: FontStyle.italic,
    );

    if (splitColor) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tap',
            style: textStyle.copyWith(
              color: tapColor,
            ),
          ),

          ShaderMask(
            shaderCallback: (bounds) {
              return AppColors.appNameGradient.createShader(
                Rect.fromLTWH(
                  0,
                  0,
                  bounds.width,
                  bounds.height,
                ),
              );
            },
            child: Text(
              'ID',
              style: textStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    return Text(
      'TapID',
      style: textStyle.copyWith(
        color: color,
      ),
    );
  }
}