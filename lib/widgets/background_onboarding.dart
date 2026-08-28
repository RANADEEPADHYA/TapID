import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BackgroundOnboarding extends StatelessWidget {
  const BackgroundOnboarding({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.white,
            AppColors.white,
            AppColors.white,
            AppColors.purple50,
          ],
          stops: [
            0.0,
            0.4,
            0.6,
            1,
          ],
        ),
      ),
      child: child,
    );
  }
}