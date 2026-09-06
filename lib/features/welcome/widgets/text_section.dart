import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_id/theme/app_colors.dart';

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


        /// APP LOGO
        Image.asset(
          'assets/images/TabID_round.png',
          width: (width * 0.50),
          height: (width * 0.50),
          fit: BoxFit.contain,
        ),

        SizedBox(
          height: (height * 0.01).clamp(20.0, 40.0).toDouble(),
        ),



        /// App Name (TapID)
        const AppName(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          splitColor: true,
        ),

        SizedBox(
          height: (height * 0.01).clamp(10.0, 30.0).toDouble(),
        ),



        /// Subtitle
        Text(
          'Tap. Share. Connect.',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            color: AppColors.textSecondary,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),


        /// Space
        SizedBox(
          height: (height * 0.01).clamp(20.0, 40.0).toDouble(),
        ),


        /// Gradient Divider
        Container(
          width: 60,
          height: 2,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
              AppColors.brandPink,
              AppColors.primaryPurple,
              AppColors.primaryBlue,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}