import 'dart:math' as math;

import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({
    super.key,
    required this.animation,
  });
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return CustomPaint(
            painter: WelcomeBackgroundPainter(
              animationValue: animation.value,
            ),
          );
        },
      ),
    );
  }
}

class WelcomeBackgroundPainter extends CustomPainter {
  const WelcomeBackgroundPainter({
    required this.animationValue,
  });

  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    _drawBaseBackground(canvas, rect);
    _drawGlow(
      canvas,
      Offset(size.width * 0.22, size.height * 0.36),
      size.width * 0.28,
      const Color(0xFF263FFF),
      0.18,
    );

    _drawGlow(
      canvas,
      Offset(size.width * 0.78, size.height * 0.43),
      size.width * 0.28,
      const Color(0xFFFF17D5),
      0.15,
    );

    _drawGlow(
      canvas,
      Offset(size.width * 0.50, size.height * 0.58),
      size.width * 0.34,
      const Color(0xFF612DFF),
      0.08,
    );

    _drawDotPattern(
      canvas,
      Offset(size.width * 0.08, size.height * 0.14),
    );

    _drawDotPattern(
      canvas,
      Offset(size.width * 0.86, size.height * 0.53),
    );

    _drawCurvedLine(canvas, size, true);
    _drawCurvedLine(canvas, size, false);
  }

  void _drawBaseBackground(
      Canvas canvas,
      Rect rect,
      ) {
    final double topSpacing = rect.height * 0.03;

    // Main dark background
    final Paint backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF010107),
          Color(0xFF02020B),
          Color(0xFF03020C),
          Color(0xFF010107),
        ],
        stops: [
          0.0,
          0.45,
          0.78,
          1.0,
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          topSpacing,
          rect.width,
          rect.height - topSpacing,
        ),
      );

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        topSpacing,
        rect.width,
        rect.height - topSpacing,
      ),
      backgroundPaint,
    );
  }

  void _drawGlow(
      Canvas canvas,
      Offset center,
      double radius,
      Color color,
      double opacity,
      ) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: opacity),
          color.withValues(alpha: opacity * 0.35),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
      );
    canvas.drawCircle(center, radius, paint);
  }

  void _drawDotPattern(
      Canvas canvas,
      Offset origin,
      ) {
    const rows = 7;
    const columns = 6;
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        final distance = math.sqrt(
          math.pow(row - 3, 2) +
              math.pow(column - 2.5, 2),
        );

        final opacity =
        (1 - distance / 4.5).clamp(0.0, 1.0);

        final pulse =
            0.65 +
                0.35 *
                    math.sin(
                      animationValue * math.pi * 2 +
                          distance,
                    );

        final paint = Paint()
          ..color = Color.lerp(
            const Color(0xFF5537FF),
            const Color(0xFFFF45DB),
            column / columns,
          )!
              .withValues(
            alpha: opacity * pulse * 0.6,
          );

        canvas.drawCircle(
          Offset(
            origin.dx + column * 18,
            origin.dy + row * 18,
          ),
          2,
          paint,
        );
      }
    }
  }

  void _drawCurvedLine(
      Canvas canvas,
      Size size,
      bool topRight,
      ) {
    final path = Path();

    if (topRight) {
      path.moveTo(
        size.width * 0.95,
        -10,
      );

      path.cubicTo(
        size.width * 0.76,
        size.height * 0.08,
        size.width * 0.73,
        size.height * 0.13,
        size.width * 0.92,
        size.height * 0.22,
      );
    } else {
      path.moveTo(
        -20,
        size.height * 0.76,
      );

      path.cubicTo(
        size.width * 0.12,
        size.height * 0.70,
        size.width * 0.16,
        size.height * 0.84,
        size.width * 0.01,
        size.height * 0.89,
      );
    }

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8,
      )
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF423DFF),
          Color(0xFFFF31D8),
          Color(0xFF5E65FF),
        ],
      ).createShader(
        Offset.zero & size,
      );

    canvas.drawPath(path, glow);

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF4A67FF),
          Color(0xFFFF3CDB),
          Color(0xFF5C8CFF),
        ],
      ).createShader(
        Offset.zero & size,
      );

    canvas.drawPath(path, line);
  }



  @override
  bool shouldRepaint(
      covariant WelcomeBackgroundPainter oldDelegate,
      ) {
    return oldDelegate.animationValue != animationValue;
  }
}