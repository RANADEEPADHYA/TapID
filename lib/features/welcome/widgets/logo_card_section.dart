import 'package:flutter/material.dart';
import 'app_name_logo.dart';

class NeonLogo extends StatelessWidget {
  const NeonLogo({
    super.key,
    required this.size,
    required this.glowIntensity,
  });

  final double size;
  final double glowIntensity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 45,
      height: size + 75,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _FloorGlow(
            size: size,
            intensity: glowIntensity,
          ),

          _LightBeam(
            color: const Color(0xFF315CFF),
            left: size * 0.22,
            bottom: size * 0.13,
            intensity: glowIntensity,
          ),

          _LightBeam(
            color: const Color(0xFFFF28D7),
            right: size * 0.22,
            bottom: size * 0.13,
            intensity: glowIntensity,
          ),

          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.115,),
              color: const Color(0xFF05050E),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25),),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF245DFF).withValues(alpha: 0.50 * glowIntensity,),
                  blurRadius: 38,
                ),
                BoxShadow(
                  color: const Color(0xFFFF20D4).withValues(alpha: 0.40 * glowIntensity,),
                  blurRadius: 38,
                ),
              ],
            ),
            child: CustomPaint(
              painter: NeonBorderPainter(
                radius: size * 0.115,
                glowIntensity: glowIntensity,
              ),
              child: Center(
            child: Column(
            mainAxisSize: MainAxisSize.min,
              children: [

                /// ─────────────────────────────────────────
                /// Logo
                Container(
                  width: size * 0.45,
                  height: size * 0.45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3D67FF).withValues(
                          alpha: 0.55,
                        ),
                        blurRadius: 25,
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: const Color(0xFF9A35FF).withValues(
                          alpha: 0.35,
                        ),
                        blurRadius: 35,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/TabID_round.png',
                    fit: BoxFit.contain,
                  ),
                ),

                /// ─────────────────────────────────────────
                /// Space
                SizedBox(
                  height: size * 0.015,
                ),

                /// ─────────────────────────────────────────
                /// App Logo
                const AppNameLogo(
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                )
              ],
            ),
          ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloorGlow extends StatelessWidget {
  const _FloorGlow({
    required this.size,
    required this.intensity,
  });

  final double size;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: size * 0.12,
      right: size * 0.12,
      child: Container(
        height: size * 0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9A35FF).withValues(alpha: 0.65 * intensity),
              blurRadius: 38,
              spreadRadius: 12,
            ),
            BoxShadow(
              color: const Color(0xFF306CFF).withValues(alpha: 0.55 * intensity),
              blurRadius: 50,
              spreadRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class _LightBeam extends StatelessWidget {
  const _LightBeam({
    required this.color,
    required this.bottom,
    required this.intensity,
    this.left,
    this.right,
  });

  final Color color;
  final double bottom;
  final double intensity;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              color,
              Colors.transparent,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.7 * intensity,),
              blurRadius: 25,
              spreadRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class NeonBorderPainter extends CustomPainter {
  const NeonBorderPainter({
    required this.radius,
    required this.glowIntensity,
  });

  final double radius;
  final double glowIntensity;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final rrect = RRect.fromRectAndRadius(
      rect.deflate(2),
      Radius.circular(radius),
    );

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        9,
      )
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF3A65FF),
          Color(0xFF7A5CFF),
          Color(0xFFFF25D9),
          Color(0xFF3B6EFF),
        ],
      ).createShader(rect);

    canvas.drawRRect(
      rrect,
      glowPaint,
    );

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF8DB5FF),
          Color(0xFF416BFF),
          Color(0xFFFF5BE6),
          Color(0xFFB348FF),
          Color(0xFF69A3FF),
        ],
      ).createShader(rect);

    canvas.drawRRect(
      rrect,
      linePaint,
    );

    final innerRRect =
    RRect.fromRectAndRadius(
      rect.deflate(7),
      Radius.circular(radius - 5),
    );

    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFE5EDFF),
          Color(0xFF536EFF),
          Color(0xFFFF66E9),
          Color(0xFF6CA0FF),
        ],
      ).createShader(rect);

    canvas.drawRRect(
      innerRRect,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant NeonBorderPainter oldDelegate,) {
    return oldDelegate.glowIntensity != glowIntensity;
  }
}