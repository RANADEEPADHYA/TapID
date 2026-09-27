import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/animated_arrow.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({
    super.key,
    required this.onTap,
    this.label = 'Next',
  });
  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppColors.primaryBlue.withValues(
              alpha: 0.55,
            ),
            width: 1,
          ),

          gradient: AppColors.buttonGradient,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [

            /// TEXT — CENTER
            Center(
              child: Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
            ),

            /// ARROW — RIGHTMOST
            const Positioned(
              right: 0,
              child: AnimatedArrow(
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}