import 'package:flutter/material.dart';
import 'package:tab_id/theme/app_colors.dart';

class OnboardingMainIllustration extends StatelessWidget {
  const OnboardingMainIllustration({
    super.key,
    required this.imagePath,
  });
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final illustrationHeight = (size.height * 0.43).clamp(
      240.0,
      430.0,
    );

    return SizedBox(
      width: double.infinity,
      height: illustrationHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [

          /// Soft circular background
          Container(
            width: size.width * 0.82,
            height: size.width * 0.82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onboardingMainIllusion.withValues(alpha: 0.15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onboardingMainIllusion.withValues(alpha: 0.05),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),

          /// Decorative ring
          Container(
            width: size.width * 0.98,
            height: size.width * 0.98,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.onboardingMainIllusion.withValues(alpha: 0.15),
                width: 2,
              ),
            ),
          ),

          /// Main onboarding illustration
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              imagePath,
              width: size.width,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}