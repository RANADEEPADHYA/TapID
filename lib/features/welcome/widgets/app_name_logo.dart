import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppNameLogo extends StatelessWidget {
  const AppNameLogo({
    super.key,
    this.fontSize = 40,
    this.fontWeight = FontWeight.w800,
    this.color = Colors.white,
  });

  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'TapID',
      style: GoogleFonts.lobsterTwo(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.italic,
        shadows: const [
          /// Blue outer glow
          Shadow(
            color: Color(0xFF245DFF),
            blurRadius: 25,
            offset: Offset.zero,
          ),

          /// Purple glow
          Shadow(
            color: Color(0xFF8A35FF),
            blurRadius: 15,
            offset: Offset.zero,
          ),

          /// Pink inner glow
          Shadow(
            color: Color(0xFFFF20D4),
            blurRadius: 8,
            offset: Offset.zero,
          ),
        ],
      ),
    );
  }
}