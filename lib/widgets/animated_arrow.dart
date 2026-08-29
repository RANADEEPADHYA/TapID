import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AnimatedArrow extends StatefulWidget {
  const AnimatedArrow({
    super.key,
    this.size = 24,
    this.color = AppColors.white,
  });

  final double size;
  final Color color;

  @override
  State<AnimatedArrow> createState() => _AnimatedArrowState();
}

class _AnimatedArrowState extends State<AnimatedArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.25, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Icon(
        Icons.arrow_right,
        color: widget.color,
        size: widget.size,
      ),
    );
  }
}