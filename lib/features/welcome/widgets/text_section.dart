
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_id/theme/app_colors.dart';

import '../../../widgets/app_name.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
    required this.width,
    required this.height,
    this.logoSize,
    this.compact = false,
  });

  final double width;
  final double height;
  final double? logoSize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final effectiveLogoSize = logoSize ?? (width * 0.40);

    final appNameSize = (width * 0.105)
        .clamp(30.0, compact ? 40.0 : 48.0)
        .toDouble();

    final subtitleSize = (width * 0.045)
        .clamp(15.0, 22.0)
        .toDouble();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/TabID_round.png',
          width: effectiveLogoSize,
          height: effectiveLogoSize,
          fit: BoxFit.contain,
        ),

        SizedBox(height: compact ? 10 : 18),

        FittedBox(
          fit: BoxFit.scaleDown,
          child: AppName(
            fontSize: appNameSize,
            fontWeight: FontWeight.w900,
            splitColor: true,
          ),
        ),

        SizedBox(height: compact ? 8 : 14),

        Text(
          'Tap. Share. Connect.',
          textAlign: TextAlign.center,
          softWrap: true,
          style: GoogleFonts.roboto(
            color: AppColors.textSecondary,
            fontSize: subtitleSize,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: compact ? 16 : 26),

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
