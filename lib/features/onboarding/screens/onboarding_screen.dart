import 'package:flutter/material.dart';
import 'package:tab_id/main.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_bottom_navigation.dart';
import '../widgets/onboarding_page_indicator.dart';
import 'onboarding_1_one_tap_screen.dart';
import 'onboarding_2_nfc_screen.dart';
import 'onboarding_3_privacy_screen.dart';
import 'onboarding_4_share_screen.dart';
import 'onboarding_5_get_started_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
  });
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingController controller;

  @override
  void initState() {
    super.initState();
    controller = OnboardingController();
    controller.addListener(_onControllerChanged);
  }
  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    super.dispose();
  }

  /// ═════════════════════════════════════════════════════════════
  /// GO TO HOME
  void _goToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const MyHomePage(title: 'home'),
      ),
          (route) => false,
    );
  }

  /// ═════════════════════════════════════════════════════════════
  /// NEXT / GET STARTED
  void _handleNext() {
    if (controller.isLastPage) {
      _goToHome();
    } else {
      controller.nextPage();
    }
  }

  /// ═════════════════════════════════════════════════════════════
  /// SKIP
  void _handleSkip() {
    _goToHome();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            /// ═══════════════════════════════════════════════════
            /// ONBOARDING PAGES
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              physics: const BouncingScrollPhysics(),
              children: const [
                Onboarding1OneTapScreen(),
                Onboarding2NfcScreen(),
                Onboarding3PrivacyScreen(),
                Onboarding4ShareScreen(),
                Onboarding5GetStartedScreen(),
              ],
            ),

            /// ═══════════════════════════════════════════════════
            /// PAGE INDICATOR
            Positioned(
              left: 0,
              right: 0,
              /// Responsive bottom position
              bottom: 130.0,
              child: OnboardingPageIndicator(
                currentPage: controller.currentPage,
                pageCount: OnboardingController.totalPages,
              ),
            ),

            /// ═══════════════════════════════════════════════════
            /// BOTTOM NAVIGATION
            Positioned(
              left: 20,
              right: 20,
              bottom: 10.0,
              child: OnboardingBottomNavigation(
                availableWidth: size.width,
                currentPage: controller.currentPage,
                totalPages: OnboardingController.totalPages,
                /// Next / Get Started
                onNext: _handleNext,
                /// Skip → Home
                onSkip: _handleSkip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}