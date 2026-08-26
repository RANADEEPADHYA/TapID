import 'package:flutter/material.dart';
import 'onboarding_next_button.dart';

class OnboardingBottomNavigation extends StatelessWidget {
  const OnboardingBottomNavigation({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final bool isLastPage =
        currentPage == totalPages - 1;

    return OnboardingNextButton(
      label: isLastPage
          ? 'Get Started'
          : 'Next',
      onTap: onNext,
    );
  }
}