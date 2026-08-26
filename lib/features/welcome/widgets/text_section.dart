import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/app_name.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
    required this.width,
    required this.height,
  });
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// ─────────────────────────────────────────────
              /// Welcome Title
              Text(
                'Welcome to',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(
                width: (width * 0.08)
                    .clamp(10.0, 20.0)
                    .toDouble(),
              ),

              /// ─────────────────────────────────────────
              /// Image + App Name
              Image.asset(
                'assets/images/TabID_round.png',
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),

              /// ─────────────────────────────────────────
              /// App Name (TapID)
              const AppName(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                splitColor: true,
              ),
            ],
          ),
        ),

        /// ─────────────────────────────────────────────
        /// Subtitle
        Text(
          'Tap. Share. Connect.',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            color: const Color(0xFF9C9494),
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),

        /// ─────────────────────────────────────────────
        /// Space
        SizedBox(
          height: (height * 0.01)
              .clamp(20.0, 40.0)
              .toDouble(),
        ),

        /// ─────────────────────────────────────────────
        /// Gradient Divider
        Container(
          width: 60,
          height: 2,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFF43D9),
                Color(0xFF875DFF),
                Color(0xFF438CFF),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}