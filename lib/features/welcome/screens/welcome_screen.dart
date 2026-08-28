import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tab_id/features/onboarding/screens/onboarding_screen.dart';
import 'package:tab_id/theme/app_colors.dart';

import '../controllers/startup_step.dart';
import '../controllers/welcome_controller.dart';
import '../widgets/intro_startup_status_row.dart';
import '../widgets/loading_status_button.dart';
import '../widgets/progress_section.dart';
import '../widgets/text_section.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
    this.onFinished,
    this.initializeApp,
    this.minimumDuration = const Duration(seconds: 4),
  });

  final VoidCallback? onFinished;
  final Future<void> Function()? initializeApp;
  final Duration minimumDuration;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {

  /// ═══════════════════════════════════════════════════════════
  /// WELCOME CONTROLLER
  late final WelcomeController _controller;

  /// ═══════════════════════════════════════════════════════════
  /// ENTRANCE ANIMATION CONTROLLER
  late final AnimationController _entranceController;

  /// ═══════════════════════════════════════════════════════════
  /// STARTUP STEPS
  final List<StartupStep> _steps = const [
    StartupStep(
      title: 'Initializing',
      subtitle: 'Firebase',
      icon: Icons.cloud_done_outlined,
    ),
    StartupStep(
      title: 'Loading',
      subtitle: 'Theme',
      icon: Icons.palette_outlined,
    ),
    StartupStep(
      title: 'Checking',
      subtitle: 'Internet',
      icon: Icons.language_rounded,
    ),
    StartupStep(
      title: 'Checking',
      subtitle: 'Login State',
      icon: Icons.person_outline_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();

    /// ═══════════════════════════════════════════════════════════
    /// WELCOME CONTROLLER
    _controller = WelcomeController(
      initializeApp: widget.initializeApp,
      minimumDuration: widget.minimumDuration,
      onFinished: widget.onFinished,
    )..addListener(_onControllerChanged);

    /// ═══════════════════════════════════════════════════════════
    /// ENTRANCE ANIMATION
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    /// Start animation after screen is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _entranceController.forward();
      }
    });

    _controller.start();
  }

  /// ═══════════════════════════════════════════════════════════
  /// CONTROLLER UPDATE
  void _onControllerChanged() {
    if (!mounted) return;

    setState(() {});
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerChanged)
      ..dispose();

    _entranceController.dispose();

    super.dispose();
  }

  /// ═══════════════════════════════════════════════════════════
  /// GO TO ONBOARDING
  void _goToOnboarding(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OnboardingScreen(),
      ),
    );
  }

  /// ═══════════════════════════════════════════════════════════
  /// BOTTOM → TOP ITEM ANIMATION
  Widget _buildEntranceAnimation({
    required Widget child,
    required double begin,
    required double end,
  }) {
    final animation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(
        begin,
        end,
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final double progress = animation.value;

        /// Starts 60 pixels below its final position.
        final double offsetY = 100 * (1 - progress);

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, offsetY),
            child: child,
          ),
        );
      },
    );
  }

  /// ═══════════════════════════════════════════════════════════
  /// BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,

      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double height = constraints.maxHeight;

          /// ═══════════════════════════════════════════════════
          /// RESPONSIVE DEVICE TYPE
          final bool isWide = width >= 700;

          /// ═══════════════════════════════════════════════════
          /// CONTENT WIDTH
          final double contentWidth = isWide
              ? math.min(width * 0.62, 560)
              : width * 0.92;

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: contentWidth,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 24 : 18,
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [

                      /// ═══════════════════════════════════════
                      /// WELCOME TEXT
                      _buildEntranceAnimation(
                        begin: 0.00,
                        end: 0.30,
                        child: WelcomeText(
                          width: contentWidth,
                          height: height,
                        ),
                      ),

                      /// ═══════════════════════════════════════
                      /// SPACING
                      SizedBox(
                        height: (height * 0.03)
                            .clamp(20.0, 40.0)
                            .toDouble(),
                      ),

                      /// ═══════════════════════════════════════
                      /// STARTUP STATUS
                      _buildEntranceAnimation(
                        begin: 0.15,
                        end: 0.45,
                        child: IntroStartupStatusRow(
                          steps: _steps,
                          currentStep: _controller.currentStep,
                          width: contentWidth,
                          height: height,
                        ),
                      ),

                      /// ═══════════════════════════════════════
                      /// SPACING
                      SizedBox(
                        height: (height * 0.06).toDouble(),
                      ),

                      /// ═══════════════════════════════════════
                      /// PROGRESS
                      _buildEntranceAnimation(
                        begin: 0.35,
                        end: 0.65,
                        child: ProgressSection(
                          progress: _controller.progress,
                          width: contentWidth,
                        ),
                      ),

                      /// ═══════════════════════════════════════
                      /// SPACING
                      SizedBox(
                        height: (height * 0.01)
                            .clamp(12.0, 24.0)
                            .toDouble(),
                      ),

                      /// ═══════════════════════════════════════
                      /// LOADING BUTTON
                      _buildEntranceAnimation(
                        begin: 0.55,
                        end: 0.90,
                        child: LoadingStatusButton(
                          duration: const Duration(seconds: 4),
                          loadingText: 'Loading...',
                          finishedText: 'Next',
                          onFinished: () {
                            _goToOnboarding(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}