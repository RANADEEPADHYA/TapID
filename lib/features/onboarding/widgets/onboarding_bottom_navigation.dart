import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/animated_arrow.dart';

class OnboardingBottomNavigation extends StatelessWidget {
  const OnboardingBottomNavigation({
    super.key,
    required this.availableWidth,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
  });

  final double availableWidth;
  final int currentPage;
  final int totalPages;

  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = currentPage == totalPages - 1;

    /// ─────────────────────────────────────────────
    /// PAGE 5
    /// Full-width Get Started button
    if (isLastPage) {
      return GestureDetector(
        onTap: onNext,
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
                Color(0xFF7051F5),
                Color(0xFF7754ED),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Get Started — CENTER
              Center(
                child: Text(
                  'Get Started',
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),

              /// Arrow — RIGHTMOST
              const Positioned(
                right: 0,
                child: AnimatedArrow(
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    /// ─────────────────────────────────────────────
    /// PAGES 1–4
    /// Skip + Next
    final buttonWidth = (availableWidth * 0.55).clamp(
      200.0,
      360.0,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// ─────────────────────────────────────
        /// SKIP
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onSkip,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 4,
            ),
            child: Row(
              children: [
                Text(
                  'Skip',
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF646A74),
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  ' >',
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF646A74),
                  ),
                ),
              ],
            ),
          ),
        ),

        const Spacer(),

        /// ─────────────────────────────────────
        /// NEXT
        GestureDetector(
          onTap: onNext,
          child: Container(
            width: buttonWidth,
            height: 80,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF7051F5),
                  Color(0xFF7754ED),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [

                /// ─────────────────────────────────────
                /// Next — CENTER
                Center(
                  child: Text(
                    'Next',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),

                /// ─────────────────────────────────────
                /// Arrow — RIGHTMOST
                const Positioned(
                  right: 0,
                  child: AnimatedArrow(
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}