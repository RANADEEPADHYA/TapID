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
    return Column(
      children: [
        Container(
          height: 10,
          width: width * 0.50,
          constraints: const BoxConstraints(
            minWidth: 220,
            maxWidth: 450,
          ),
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
      ],
    );
  }
}