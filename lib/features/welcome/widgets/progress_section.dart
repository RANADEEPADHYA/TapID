import 'package:flutter/material.dart';
import 'package:tab_id/theme/app_colors.dart';

class ProgressSection extends StatelessWidget {
  const ProgressSection({
    super.key,
    required this.progress,
    required this.width,
  });

  final double progress;
  final double width;

  @override
  Widget build(BuildContext context) {
    final barWidth = (width * 0.65)
        .clamp(0.0, width)
        .toDouble();

    return Center(
      child: SizedBox(
        width: barWidth,
        child: Container(
          height: 10,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: AppColors.darkBlue950,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress.clamp(0.02, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.primaryBlue,
                      AppColors.primaryPurple,
                      AppColors.brandPink,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
