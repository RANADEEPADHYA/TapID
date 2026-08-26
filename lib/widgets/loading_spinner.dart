import 'dart:math' as math;
import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({
    super.key,
    required this.value,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: CustomPaint(
        painter: LoadingSpinnerPainter(
          progress: value,
        ),
      ),
    );
  }
}

class LoadingSpinnerPainter extends CustomPainter {
  const LoadingSpinnerPainter({
    required this.progress,
  });

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.38;

    for (int i = 0; i < 10; i++) {
      final angle =
          (math.pi * 2 / 10) * i +
              (progress * math.pi * 2);

      final offset = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      final paint = Paint()
        ..color = Color.lerp(
          const Color(0xFF3E7BFF),
          const Color(0xFFFF43D9),
          i / 9,
        )!.withValues(
          alpha: (i + 1) / 10,
        );

      canvas.drawCircle(
        offset,
        2.7,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant LoadingSpinnerPainter oldDelegate,
      ) {
    return oldDelegate.progress != progress;
  }
}