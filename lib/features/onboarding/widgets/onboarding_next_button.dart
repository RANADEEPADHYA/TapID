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
        height: 80,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.primaryPurple,
              AppColors.nextButtonPurple,
            ],
          ),
          borderRadius: BorderRadius.circular(36),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// ─────────────────────────────────
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

            /// ─────────────────────────────────
            /// ARROW — RIGHTMOST
            const Positioned(
              right: 0,
              child: AnimatedArrow(
                size: 40,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}