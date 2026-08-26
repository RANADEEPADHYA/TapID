import 'package:flutter/material.dart';

class ProgressSection extends StatelessWidget {
  const ProgressSection({
    super.key,
    required this.progress,
    required this.progressAnimation,
    required this.loadingAnimation,
    required this.width,
  });

  final double progress;
  final Animation<double> progressAnimation;
  final Animation<double> loadingAnimation;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: progressAnimation,
          builder: (context, child) {
            final value =
                progress * progressAnimation.value;

            return Container(
              height: 10,
              width: width * 0.50,
              constraints: const BoxConstraints(
                minWidth: 220,
                maxWidth: 450,
              ),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFF181824),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: value.clamp(0.02, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3C84FF),
                          Color(0xFF7860FF),
                          Color(0xFFFF35D6),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}