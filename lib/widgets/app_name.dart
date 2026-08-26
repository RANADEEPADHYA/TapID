import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppName extends StatelessWidget {
  const AppName({
    super.key,
    this.fontSize = 40,
    this.fontWeight = FontWeight.w600,
    this.color = Colors.white,
    this.splitColor = false,
    this.tapColor = Colors.white,
    this.idColor = const Color(0xFF7051F5),
  });

  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final bool splitColor;
  final Color tapColor;
  final Color idColor;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.lobsterTwo(
      fontSize: fontSize,
      fontWeight: fontWeight,
    );

    if (splitColor) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Tap',
              style: textStyle.copyWith(
                color: tapColor,
                fontStyle: FontStyle.italic
              ),
            ),
            TextSpan(
              text: 'ID',
              style: textStyle.copyWith(
                color: idColor,
                  fontStyle: FontStyle.italic
              ),
            ),
          ],
        ),
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