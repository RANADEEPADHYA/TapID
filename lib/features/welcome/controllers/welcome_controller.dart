import 'package:flutter/foundation.dart';

class WelcomeController extends ChangeNotifier {
  WelcomeController({
    this.initializeApp,
    this.minimumDuration = const Duration(seconds: 4),
    this.onFinished,
  });
  final Future<void> Function()? initializeApp;
  final Duration minimumDuration;
  final VoidCallback? onFinished;
  int _currentStep = 0;
  double _progress = 0.0;
  bool _finished = false;
  int get currentStep => _currentStep;
  double get progress => _progress;
  bool get finished => _finished;

  Future<void> start() async {
    final stopwatch = Stopwatch()..start();
    try {
      if (initializeApp != null) {
        await initializeApp!();
      } else {
        await simulateInitialization();
      }
    } catch (error) {
      debugPrint(
        'Welcome initialization error: $error',
      );
    }

    stopwatch.stop();
    final Duration remaining = minimumDuration - stopwatch.elapsed;

    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
    if (_finished) return;
    _finished = true;
    notifyListeners();
    onFinished?.call();
  }

  Future<void> simulateInitialization() async {
    await updateStep(
      step: 0,
      progress: 0.25,
      delay: const Duration(milliseconds: 700),
    );

    await updateStep(
      step: 1,
      progress: 0.50,
      delay: const Duration(milliseconds: 600),
    );

    await updateStep(
      step: 2,
      progress: 0.75,
      delay: const Duration(milliseconds: 700),
    );

    await updateStep(
      step: 3,
      progress: 1.0,
      delay: const Duration(milliseconds: 700),
    );
  }

  Future<void> updateStep({
    required int step,
    required double progress,
    required Duration delay,
  }) async {
    _currentStep = step;
    _progress = progress;
    notifyListeners();
    await Future<void>.delayed(delay);
  }
}