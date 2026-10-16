import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../controllers/startup_step.dart';

class IntroStartupStatusRow extends StatelessWidget {
  const IntroStartupStatusRow({
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
    final compact = width < 370 || height < 650;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 2 : 4,
                  ),
                  child: _StatusItem(
                    step: steps[index],
                    active: index <= currentStep,
                    compact: compact,
                  ),
                ),
              ),

              // Vertical divider between status items.
              if (index < steps.length - 1)
                Container(
                  width: 1,
                  height: compact ? 58 : 72,
                  margin: const EdgeInsets.only(top: 4),
                  color: AppColors.iconCircleDarkBorder,
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({
    required this.step,
    required this.active,
    required this.compact,
  });

  final StartupStep step;
  final bool active;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 36.0 : 44.0;
    final labelSize = compact ? 10.0 : 12.0;

    final textColor = active
        ? AppColors.white
        : AppColors.textSecondary;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: active ? 1 : 0.45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? AppColors.primaryPurple.withValues(alpha: 0.15)
                  : AppColors.iconCircleDarkFull.withValues(alpha: 0.5),
              border: Border.all(
                color: active
                    ? AppColors.primaryPurple.withValues(alpha: 0.6)
                    : AppColors.iconCircleDarkBorder,
                width: 1.5,
              ),
            ),
            child: Icon(
              step.icon,
              size: compact ? 19 : 23,
              color: active
                  ? AppColors.primaryPurple
                  : AppColors.textSecondary,
            ),
          ),

          SizedBox(height: compact ? 7 : 12),

          Text(
            step.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              color: textColor,
              fontSize: labelSize,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            step.subtitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              color: textColor,
              fontSize: labelSize,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}