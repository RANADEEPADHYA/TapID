import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/animated_arrow.dart';
import '../../../widgets/loading_spinner.dart';

class LoadingStatusButton extends StatefulWidget {
  const LoadingStatusButton({
    super.key,
    this.duration = const Duration(seconds: 10),
    this.loadingText = 'Loading...',
    this.finishedText = 'Next',
    this.onFinished,
  });

  final Duration duration;
  final String loadingText;
  final String finishedText;

  /// Called when the user clicks the button
  /// after loading has finished.
  final VoidCallback? onFinished;

  @override
  State<LoadingStatusButton> createState() =>
      _LoadingStatusButtonState();
}

class _LoadingStatusButtonState extends State<LoadingStatusButton>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late final AnimationController _spinnerController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    /// ─────────────────────────────────────────
    /// Spinner animation

    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    /// ─────────────────────────────────────────
    /// 10 second loading timer
    _timer = Timer(widget.duration, () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      // Stop spinner
      _spinnerController.stop();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _spinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /// Same width for both loading and finished states
    final double buttonWidth =
        MediaQuery.sizeOf(context).width * 0.80;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      child: _isLoading
          ? _buildLoadingButton(buttonWidth)
          : _buildFinishedButton(buttonWidth),
    );
  }

  /// ─────────────────────────────────────────
  /// LOADING BUTTON

  Widget _buildLoadingButton(double width) {
    return Container(
      key: const ValueKey('loading'),

      /// Same width as finished button
      width: width,

      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF7045FF).withValues(
            alpha: 0.45,
          ),
          width: 1,
        ),

        gradient: LinearGradient(
          colors: [
            const Color(0xFF7045FF).withValues(
              alpha: 0.12,
            ),
            const Color(0xFFFF45DB).withValues(
              alpha: 0.08,
            ),
          ],
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// ─────────────────────────────────────────
          /// Animated spinner
          AnimatedBuilder(
            animation: _spinnerController,
            builder: (context, child) {
              return LoadingSpinner(
                value: _spinnerController.value,
              );
            },
          ),

          const SizedBox(width: 12),

          /// ─────────────────────────────────────────
          /// Loading (Text)
          Text(
            widget.loadingText,
            style: GoogleFonts.lobsterTwo(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// ─────────────────────────────────────────
  /// FINISHED BUTTON
  Widget _buildFinishedButton(double width) {
    return SizedBox(
      key: const ValueKey('finished'),
      width: width,

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(30),

          /// IMPORTANT:
          /// This is only available after loading.
          onTap: widget.onFinished,

          child: Container(
            width: width,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFF438CFF).withValues(
                  alpha: 0.55,
                ),
                width: 1,
              ),

              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7045FF),
                  Color(0xFF438CFF),
                ],
              ),

              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7045FF).withValues(
                    alpha: 0.35,
                  ),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),

            child: Stack(
              alignment: Alignment.center,
              children: [

                /// ─────────────────────────────────────────
                /// Centered check + text
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// ─────────────────────────────────────────
                    /// Icon
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 32,
                    ),

                    /// ─────────────────────────────────────────
                    /// Text
                    Text(
                      widget.finishedText,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                /// ─────────────────────────────────────────
                /// Animated right arrow
                const Positioned(
                  right: 0,
                  child: AnimatedArrow(
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}