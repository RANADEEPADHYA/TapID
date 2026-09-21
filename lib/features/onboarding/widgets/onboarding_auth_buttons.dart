import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class OnboardingAuthButtons extends StatelessWidget {
  const OnboardingAuthButtons({
    super.key,
    required this.onSignIn,
  });
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
      ],
    );
  }
}