import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/startup_step.dart';

class IntroStartupStatusRow extends StatelessWidget {
  const IntroStartupStatusRow ({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.width,
    required this.height,
  });

  final List<StartupStep> steps;
  final int currentStep;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bool compact = width < 370;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        steps.length,
            (index) {
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _StatusItem(
                    step: steps[index],
                    active: index <= currentStep,
                    compact: compact,
                    height: height,
                  ),
                ),

                /// Divider between status items
                if (index < steps.length - 1)
                  Container(
                    width: 1,
                    height: compact ? 58 : 72,
                    color: const Color(0xFF383246),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({
    required this.step,
    required this.active,
    required this.compact,
    required this.height,
  });

  final StartupStep step;
  final bool active;
  final bool compact;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: active ? 1.0 : 0.45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// ─────────────────────────────────────────
          /// Status Icon Circle
          Container(
            width: compact ? 38 : 44,
            height: compact ? 38 : 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? const Color(0xFF7051F5).withValues(alpha: 0.15)
                  : const Color(0xFF383246).withValues(alpha: 0.5),
              border: Border.all(
                color: active
                    ? const Color(0xFF875DFF).withValues(alpha: 0.6)
                    : const Color(0xFF514A5D),
                width: 1.5,
              ),
            ),
            child: Center(
              child: active
                  ? ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF43D9),
                      Color(0xFF875DFF),
                      Color(0xFF438CFF),
                    ],
                  ).createShader(
                    Rect.fromLTWH(
                      0,
                      0,
                      bounds.width,
                      bounds.height,
                    ),
                  );
                },
                blendMode: BlendMode.srcIn,
                child: Icon(
                  step.icon,
                  size: compact ? 21 : 25,
                  color: Colors.white,
                ),
              )
                  : Icon(
                step.icon,
                size: compact ? 21 : 25,
                color: const Color(0xFF979797),
              ),
            ),
          ),

          /// ─────────────────────────────────────────
          /// Responsive spacing
          SizedBox(
            height: (height * 0.01).clamp(10.0, 20.0).toDouble(),
          ),

          /// ─────────────────────────────────────────
          /// Title
          Text(
            step.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              color: active
                  ? Colors.white
                  : const Color(0xFF777386),
              fontSize: 14 ,
              fontWeight: FontWeight.w500,
            ),
          ),

          /// ─────────────────────────────────────────
          /// Subtitle
          Text(
            step.subtitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              color: active
                  ? Colors.white
                  : const Color(0xFF696474),
              fontSize: 14 ,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}