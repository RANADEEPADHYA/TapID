import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tab_id/features/onboarding/screens/onboarding_screen.dart';
import '../controllers/startup_step.dart';
import 'loading_status_button.dart';
import 'logo_card_section.dart';
import 'progress_section.dart';
import 'intro_startup_status_row.dart';
import 'welcome_background.dart';
import 'text_section.dart';

class ResponsiveWelcomeLayout extends StatelessWidget {
  const ResponsiveWelcomeLayout({
    super.key,
    required this.constraints,
    required this.logoScale,
    required this.logoOpacity,
    required this.logoGlow,
    required this.progress,
    required this.progressAnimation,
    required this.loadingAnimation,
    required this.dotsAnimation,
    required this.currentStep,
    required this.steps,
  });
  final BoxConstraints constraints;
  final Animation<double> logoScale;
  final Animation<double> logoOpacity;
  final Animation<double> logoGlow;
  final double progress;
  final Animation<double> progressAnimation;
  final Animation<double> loadingAnimation;
  final Animation<double> dotsAnimation;
  final int currentStep;
  final List<StartupStep> steps;

  @override
  Widget build(BuildContext context) {
    final double width = constraints.maxWidth;
    final double height = constraints.maxHeight;

    final bool isWide = width >= 700;
    final bool isTablet =
        width >= 600 && width < 1000;

    final double contentWidth = isWide
        ? math.min(width * 0.62, 560)
        : width * 0.92;

    final double logoSize = isWide
        ? 320
        : isTablet
        ? math.min(width * 0.48, 310)
        : math.min(width * 0.56, 290);

    return Stack(
      children: [

        /// ─────────────────────────────────────────
        /// BACKGROUND
        WelcomeBackground(
          animation: dotsAnimation,
        ),

        /// ─────────────────────────────────────────
        /// CONTENT
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: contentWidth,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 24 : 18,
                ),

                /// ─────────────────────────────────────────
                /// This centers everything vertically.
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [

                    /// ─────────────────────────────────────────
                    /// LOGO
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        logoScale,
                        logoOpacity,
                        logoGlow,
                      ]),
                      builder: (_, __) {
                        return Opacity(
                          opacity: logoOpacity.value,
                          child: Transform.scale(
                            scale: logoScale.value,
                            child: NeonLogo(
                              size: logoSize,
                              glowIntensity: logoGlow.value,
                            ),
                          ),
                        );
                      },
                    ),

                    /// ─────────────────────────────────────────
                    /// SPACING
                    SizedBox(
                      height: (height * 0.02)
                          .clamp(20.0, 40.0)
                          .toDouble(),
                    ),

                    /// ─────────────────────────────────────────
                    /// WELCOME TEXT
                    WelcomeText(
                      width: contentWidth,
                      height: height,
                    ),

                    /// ─────────────────────────────────────────
                    /// SPACING
                    SizedBox(
                      height: (height * 0.03)
                          .clamp(20.0, 40.0)
                          .toDouble(),
                    ),

                    /// ─────────────────────────────────────────
                    /// STARTUP STATUS
                    IntroStartupStatusRow(
                      steps: steps,
                      currentStep: currentStep,
                      width: contentWidth,
                      height: height,
                    ),

                    /// ─────────────────────────────────────────
                    /// BOTTOM SPACING
                    SizedBox(
                      height: (height * 0.06)
                          .toDouble(),
                    ),

                    /// ─────────────────────────────────────────
                    /// PROGRESS / LOADING
                    ProgressSection(
                      progress: progress,
                      progressAnimation: progressAnimation,
                      loadingAnimation: loadingAnimation,
                      width: contentWidth,
                    ),

                    /// ─────────────────────────────────────────
                    /// BOTTOM SPACING
                    SizedBox(
                      height: (height * 0.01)
                          .clamp(12.0, 24.0)
                          .toDouble(),
                    ),

                    /// ─────────────────────────────────────────
                    /// LOADING STATUS BUTTON
                    LoadingStatusButton(
                      duration: const Duration(seconds: 10),
                      loadingText: 'Loading...',
                      finishedText: 'Next',
                      onFinished: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OnboardingScreen()
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}