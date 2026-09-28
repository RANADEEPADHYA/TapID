import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_id/widgets/animated_arrow.dart';

import '../../../theme/app_colors.dart';

class ProfileSaveContinueButton extends StatelessWidget {
  const ProfileSaveContinueButton({
    super.key,
    required this.enabled,
    required this.onTap,
    this.text = 'Save & Continue',
  });

  final bool enabled;
  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        gradient: enabled ? AppColors.buttonGradient : null,
        color: enabled ? null : const Color(0xFFE5E5E7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          width: 1,
          color: enabled
              ? AppColors.primaryBlue.withValues(alpha: 0.35)
              : AppColors.textSecondary.withValues(alpha: 0.25),
        ),
        boxShadow: enabled
            ? [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(18),
          splashColor: AppColors.white.withValues(alpha: 0.15),
          highlightColor: AppColors.white.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                /// Button text
                Expanded(
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: enabled
                            ? AppColors.white
                            : AppColors.textSecondary,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),

                /// Animated right arrow
                const Positioned(
                  right: 0,
                  child: AnimatedArrow(
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}