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
  late final WelcomeController _controller;
  late final AnimationController _entranceController;

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

    _controller = WelcomeController(
      initializeApp: widget.initializeApp,
      minimumDuration: widget.minimumDuration,
      onFinished: widget.onFinished,
    )..addListener(_onControllerChanged);

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _entranceController.forward();
      }
    });

    _controller.start();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerChanged)
      ..dispose();

    _entranceController.dispose();
    super.dispose();
  }

  void _goToOnboarding(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const OnboardingScreen(),
      ),
    );
  }

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
        final progress = animation.value;

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - progress)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            final isWide = screenWidth >= 600;
            final isCompact = screenHeight < 650;

            final horizontalPadding = isWide ? 28.0 : 16.0;

            final contentWidth = math.max(
              0.0,
              math.min(
                screenWidth - horizontalPadding * 2,
                isWide ? 520.0 : 480.0,
              ),
            );

            final logoWidth = math.min(
              contentWidth * (isCompact ? 0.34 : 0.43),
              isCompact ? 150.0 : 200.0,
            );

            final firstSpacing = (screenHeight * 0.025)
                .clamp(10.0, 24.0)
                .toDouble();

            final secondSpacing = (screenHeight * 0.045)
                .clamp(16.0, 36.0)
                .toDouble();

            final thirdSpacing = (screenHeight * 0.035)
                .clamp(12.0, 28.0)
                .toDouble();

            final lastSpacing = (screenHeight * 0.025)
                .clamp(10.0, 20.0)
                .toDouble();

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWide ? 576 : double.infinity,
                ),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: isCompact ? 12 : 20,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: math.max(
                        0.0,
                        screenHeight -
                            (isCompact ? 24.0 : 40.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildEntranceAnimation(
                          begin: 0.00,
                          end: 0.30,
                          child: WelcomeText(
                            width: contentWidth,
                            height: screenHeight,
                            logoSize: logoWidth,
                            compact: isCompact,
                          ),
                        ),

                        SizedBox(height: firstSpacing),

                        _buildEntranceAnimation(
                          begin: 0.15,
                          end: 0.45,
                          child: IntroStartupStatusRow(
                            steps: _steps,
                            currentStep: _controller.currentStep,
                            width: contentWidth,
                            height: screenHeight,
                          ),
                        ),

                        SizedBox(height: secondSpacing),

                        _buildEntranceAnimation(
                          begin: 0.35,
                          end: 0.65,
                          child: ProgressSection(
                            progress: _controller.progress,
                            width: contentWidth,
                          ),
                        ),

                        SizedBox(height: thirdSpacing),

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

                        SizedBox(height: lastSpacing),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
