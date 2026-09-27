import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    required this.onTap,
    this.size = 44,
    this.iconSize = 24,
    this.iconColor = AppColors.textPrimary,
    this.backgroundColor = AppColors.white,
  });

  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            Icons.arrow_back_rounded,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}