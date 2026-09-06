import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
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
                    color: AppColors.iconCircleDarkFull,
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


          /// Status Icon Circle
          Container(
            width: compact ? 38 : 44,
            height: compact ? 38 : 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? AppColors.primaryPurple.withValues(alpha: 0.15)
                  : AppColors.iconCircleDarkFull.withValues(alpha: 0.5),
              border: Border.all(
                color: active
                    ? AppColors.primaryPurple1.withValues(alpha: 0.6)
                    : AppColors.iconCircleDarkBorder,
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
                      AppColors.brandPink,
                      AppColors.primaryPurple1,
                      AppColors.primaryBlue,
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
                  color: AppColors.white,
                ),
              )
                  : Icon(
                step.icon,
                size: compact ? 21 : 25,
                color: AppColors.textSecondary,
              ),
            ),
          ),


          /// Responsive spacing
          SizedBox(
            height: (height * 0.01).clamp(10.0, 20.0).toDouble(),
          ),


          /// Title
          Text(
            step.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              color: active
                  ? AppColors.white
                  : AppColors.textSecondary,
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
                  ? AppColors.white
                  : AppColors.textSecondary,
              fontSize: 14 ,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}