import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class OnboardingAuthButtons extends StatelessWidget {
  const OnboardingAuthButtons({
    super.key,
    required this.onSignIn,
    required this.onSignUp,
  });
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// ═══════════════════════════════════════════════════════
        /// SIGN IN — PRIMARY BUTTON

        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onSignIn,
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.primaryPurple,
                    AppColors.skyBlue,
                  ],
                ),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(
                      alpha: .22,
                    ),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        /// ═══════════════════════════════════════════════════════
        /// SIGN UP — SECONDARY BUTTON

        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onSignUp,
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: .55),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: AppColors.primaryPurple,
                  width: 1.5,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}