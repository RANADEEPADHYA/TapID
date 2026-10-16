
import 'dart:async';

import 'package:flutter/foundation.dart';

class WelcomeController extends ChangeNotifier {
  WelcomeController({
    this.initializeApp,
    this.minimumDuration = const Duration(seconds: 3),
    this.onFinished,
  });

  final Future<void> Function()? initializeApp;
  final Duration minimumDuration;
  final VoidCallback? onFinished;

  int _currentStep = 0;
  double _progress = 0.0;
  bool _finished = false;
  bool _started = false;

  int get currentStep => _currentStep;
  double get progress => _progress;
  bool get finished => _finished;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    final stopwatch = Stopwatch()..start();

    // Update the progress smoothly over three seconds.
    final progressTimer = Timer.periodic(
      const Duration(milliseconds: 30),
          (_) {
        if (_finished) return;

        final elapsed = stopwatch.elapsedMilliseconds;
        final total = minimumDuration.inMilliseconds;

        _progress = total <= 0
            ? 1.0
            : (elapsed / total).clamp(0.0, 1.0);

        // Four startup stages.
        _currentStep = (_progress * 4)
            .floor()
            .clamp(0, 3);

        notifyListeners();
      },
    );

    try {
      if (initializeApp != null) {
        await initializeApp!();
      } else {
        await simulateInitialization();
      }
    } catch (error) {
      debugPrint('Welcome initialization error: $error');
    }

    // Wait until three seconds have elapsed.
    final remaining = minimumDuration - stopwatch.elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }

    progressTimer.cancel();

    if (_finished) return;

    _progress = 1.0;
    _currentStep = 3;
    _finished = true;
    notifyListeners();

    onFinished?.call();
  }

  Future<void> simulateInitialization() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 700),
    );
    await Future<void>.delayed(
      const Duration(milliseconds: 600),
    );
    await Future<void>.delayed(
      const Duration(milliseconds: 700),
    );
    await Future<void>.delayed(
      const Duration(milliseconds: 700),
    );
  }
}
