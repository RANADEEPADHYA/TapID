import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class OtpVerificationButton extends StatelessWidget {
  const OtpVerificationButton({
    super.key,
    required this.enabled,
    required this.onTap,
    this.isLoading = false,
  });

  final bool enabled;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool isActive = enabled && !isLoading;

    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),

          border: Border.all(
            width: 1,
            color: isActive
                ? AppColors.primaryBlue.withValues(alpha: 0.55)
                : AppColors.textSecondary.withValues(alpha: 0.55),
          ),

          gradient: isActive
              ? AppColors.buttonGradient
              : null,

          color: isActive
              ? null
              : const Color(0xFFE5E5E7),
        ),

        child: Stack(
          alignment: Alignment.center,
          children: [
            /// BUTTON TEXT
            Text(
              isLoading ? 'Verifying...' : 'Verify OTP',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: isActive
                    ? AppColors.white
                    : AppColors.textSecondary,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}