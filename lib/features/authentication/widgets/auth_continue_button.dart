import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';

class AuthContinueButton extends StatelessWidget {
  const AuthContinueButton({
    super.key,
    required this.enabled,
    required this.onTap,
  });

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 250,
        ),

        width: double.infinity,
        height: 82,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),

          gradient: enabled
              ? const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.primaryPurple1,
              AppColors.primaryBlue,
            ],
          )
              : null,

          color: enabled
              ? null
              : const Color(0xFFE5E5E7),
        ),

        child: Stack(
          alignment: Alignment.center,

          children: [

            /// ═══════════════════════════════════════════
            /// TEXT
            Text(
              'Continue',
              style: GoogleFonts.roboto(
                color: enabled
                    ? AppColors.white
                    : AppColors.textSecondary,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),

            /// ═══════════════════════════════════════════
            /// ARROW CIRCLE
            Positioned(
              right: 8,
              child: Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: enabled
                      ? AppColors.white.withValues(
                    alpha: 0.18,
                  )
                      : AppColors.white.withValues(
                    alpha: 0.65,
                  ),
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 42,
                  color: enabled
                      ? AppColors.white
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}