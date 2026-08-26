import 'package:flutter/material.dart';

class OnboardingController extends ChangeNotifier {
  OnboardingController();

  /// ─────────────────────────────────────────────
  /// Page Controller
  final PageController pageController = PageController();

  /// ─────────────────────────────────────────────
  /// Total onboarding pages
  static const int totalPages = 5;

  /// ─────────────────────────────────────────────
  /// Current page
  int _currentPage = 0;
  int get currentPage => _currentPage;

  /// ─────────────────────────────────────────────
  /// Is first page?
  bool get isFirstPage => _currentPage == 0;

  /// ─────────────────────────────────────────────
  /// Is last page?
  bool get isLastPage => _currentPage == totalPages - 1;

  /// ─────────────────────────────────────────────
  /// Update current page
  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  /// ─────────────────────────────────────────────
  /// NEXT
  Future<void> nextPage() async {
    if (isLastPage) {
      await finishOnboarding();
      return;
    }
    await pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  /// ─────────────────────────────────────────────
  /// PREVIOUS
  Future<void> previousPage() async {
    if (isFirstPage) return;
    await pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  /// ─────────────────────────────────────────────
  /// SKIP
  Future<void> skip() async {
    await finishOnboarding();
  }

  /// ─────────────────────────────────────────────
  /// FINISH ONBOARDING
  Future<void> finishOnboarding() async {
    // TODO:
    // Save onboarding completed state.
    //
    // Example:
    // await storage.write(
    //   key: 'onboarding_completed',
    //   value: true,
    // );

    // TODO:
    // Navigate to your main/home screen.
  }

  /// ─────────────────────────────────────────────
  /// Dispose
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}