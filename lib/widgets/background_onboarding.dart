import 'package:flutter/material.dart';

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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF43D9),
            Color(0xFF875DFF),
            Color(0xFF438CFF),
          ],
        ),
      ),
      child: child,
    );
  }
}