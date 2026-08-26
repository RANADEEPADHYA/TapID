import 'package:flutter/material.dart';
import '../controllers/welcome_controller.dart';
import '../controllers/startup_step.dart';
import '../widgets/responsive_welcome_layout.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
    this.onFinished,
    this.initializeApp,
    this.minimumDuration =
    const Duration(seconds: 4),
  });
  final VoidCallback? onFinished;
  final Future<void> Function()? initializeApp;
  final Duration minimumDuration;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _glowController;
  late final AnimationController _progressController;
  late final AnimationController _dotsController;
  late final AnimationController _loadingController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoGlow;
  late final Animation<double> _progressAnimation;
  late final WelcomeController _controller;

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

    _initializeAnimations();
    _controller.start();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    );

    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut,),
    );

    _logoGlow = Tween<double>(
      begin: 0.65,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    );

    _logoController.forward();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {});
    _progressController.forward(from: 0);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerChanged)
      ..dispose();
    _logoController.dispose();
    _glowController.dispose();
    _progressController.dispose();
    _dotsController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFF020208),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ResponsiveWelcomeLayout(
            constraints: constraints,
            logoScale: _logoScale,
            logoOpacity: _logoOpacity,
            logoGlow: _logoGlow,
            progress: _controller.progress,
            progressAnimation:
            _progressAnimation,
            loadingAnimation:
            _loadingController,
            dotsAnimation: _dotsController,
            currentStep:
            _controller.currentStep,
            steps: _steps,
          );
        },
      ),
    );
  }
}