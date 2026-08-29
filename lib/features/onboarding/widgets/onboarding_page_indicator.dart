import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.currentPage,
    this.pageCount = 5,
  });
  final int currentPage;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
            (index) {
          final bool isActive = index == currentPage;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            margin: const EdgeInsets.symmetric(
              horizontal: 6,
            ),

            width: isActive ? 20 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primaryPurple
                  : AppColors.pageIndicatorInactive,
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}