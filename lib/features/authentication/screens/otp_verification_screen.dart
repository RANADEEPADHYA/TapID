import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/app_colors.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.onVerify,
    required this.onChangePhone,
    this.onResend,
  });

  final String phoneNumber;
  /// Called when the user submits a complete 6-digit OTP.
  final ValueChanged<String> onVerify;
  /// Called when the user wants to change their phone number.
  final VoidCallback onChangePhone;
  /// Called when the user requests another OTP.
  final VoidCallback? onResend;

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int _otpLength = 6;
  static const int _initialCountdown = 28;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  Timer? _timer;
  int _remainingSeconds = _initialCountdown;
  final bool _isVerifying = false;
  String get _otp => _controllers.map((controller) => controller.text).join();
  bool get _isOtpComplete => _otp.length == _otpLength;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _otpLength,
          (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      _otpLength,
          (_) => FocusNode(),
    );
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  /// OTP COUNTDOWN
  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _initialCountdown;
    });
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (_remainingSeconds <= 1) {
          timer.cancel();
          setState(() {
            _remainingSeconds = 0;
          });
        } else {
          setState(() {
            _remainingSeconds--;
          });
        }
      },
    );
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60)
        .toString()
        .padLeft(2, '0');
    final seconds = (_remainingSeconds % 60)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _resendOtp() {
    if (_remainingSeconds > 0) return;
    // Clear the existing OTP.
    for (final controller in _controllers) {
      controller.clear();
    }
    setState(() {});
    _startCountdown();
    widget.onResend?.call();
    FocusScope.of(context).requestFocus(_focusNodes.first);
  }


  /// OTP INPUT
  void _onOtpChanged(String value, int index) {
    /// Support pasting a complete OTP into a single box.
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < _otpLength; i++) {
        _controllers[i].text =
        i < digits.length ? digits[i] : '';
      }
      final nextIndex = digits.length.clamp(0, _otpLength);
      if (nextIndex < _otpLength) {
        _focusNodes[nextIndex].requestFocus();
      } else {
        _focusNodes.last.unfocus();
      }
      setState(() {});
      return;
    }
    setState(() {});
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isNotEmpty && index == _otpLength - 1) {
      _focusNodes[index].unfocus();
    }
  }

  KeyEventResult _handleKeyEvent(
      int index,
      KeyEvent event,
      ) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      setState(() {});
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  /// VERIFY
  void _verifyOtp() {
    if (!_isOtpComplete || _isVerifying) return;
    FocusScope.of(context).unfocus();
    widget.onVerify(_otp);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          /// Soft gradient background.
          const Positioned.fill(
            child: _OtpBackground(),
          ),

          SafeArea(
            child: Column(
              children: [
                // Back button.
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _BackButton(
                      onTap: () => Navigator.maybePop(context),
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        SizedBox(
                          height: (screenHeight * 0.025)
                              .clamp(12.0, 24.0),
                        ),

                        // Hero illustration.
                        const _OtpHeroIllustration(),

                        SizedBox(
                          height: (screenHeight * 0.018)
                              .clamp(12.0, 22.0),
                        ),

                        // Main content card.
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFDFDFEFF),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(42),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              24,
                              12,
                              24,
                              32,
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                // Small drag indicator.
                                Center(
                                  child: Container(
                                    width: 64,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFC8CDE0),
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 54),

                                _buildHeading(),

                                const SizedBox(height: 52),

                                _buildOtpFields(),

                                const SizedBox(height: 52),

                                _buildResendPanel(),

                                const SizedBox(height: 56),

                                _buildVerifyButton(),

                                const SizedBox(height: 38),

                                _buildDivider(),

                                const SizedBox(height: 28),

                                _buildChangePhoneButton(),

                                const SizedBox(height: 76),

                                _buildSecurityMessage(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADING
  // ------------------------------------------------------------

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return AppColors.onboardingTextGradient
                .createShader(bounds);
          },
          child: const Text(
            'Verify your number',
            style: TextStyle(
              fontSize: 36,
              height: 1.2,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'We’ve sent a 6-digit verification code\nto '
              '${widget.phoneNumber}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 17,
            height: 1.6,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // OTP INPUT FIELDS
  // ------------------------------------------------------------

  Widget _buildOtpFields() {
    return Row(
      children: List.generate(_otpLength, (index) {
        final isFilled = _controllers[index].text.isNotEmpty;
        final isFocused = _focusNodes[index].hasFocus;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == _otpLength - 1 ? 0 : 10,
            ),
            child: Focus(
              onKeyEvent: (_, event) =>
                  _handleKeyEvent(index, event),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 80,
                decoration: BoxDecoration(
                  color: isFocused
                      ? AppColors.primaryBlue50
                      : AppColors.white.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isFocused
                        ? AppColors.primaryPurple
                        : isFilled
                        ? AppColors.primaryBlue300
                        : AppColors.purple100,
                    width: isFocused ? 2 : 1.5,
                  ),
                  boxShadow: isFocused
                      ? [
                    BoxShadow(
                      color: AppColors.primaryBlue
                          .withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 5),
                    ),
                  ]
                      : null,
                ),
                child: Center(
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textInputAction: index == _otpLength - 1
                        ? TextInputAction.done
                        : TextInputAction.next,
                    textAlign: TextAlign.center,
                    maxLength: _otpLength,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: const TextStyle(
                      color: AppColors.primaryPurple,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    onChanged: (value) =>
                        _onOtpChanged(value, index),
                    onSubmitted: (_) {
                      if (_isOtpComplete) {
                        _verifyOtp();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ------------------------------------------------------------
  // RESEND OTP PANEL
  // ------------------------------------------------------------

  Widget _buildResendPanel() {
    final canResend = _remainingSeconds == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue50.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryBlue100.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue100,
            ),
            child: const Icon(
              Icons.schedule_rounded,
              size: 34,
              color: AppColors.primaryBlue700,
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  children: [
                    Text(
                      canResend
                          ? 'Didn’t receive the code?'
                          : 'Resend code in',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (!canResend)
                      Text(
                        _formattedTime,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                GestureDetector(
                  onTap: canResend ? _resendOtp : null,
                  child: Text(
                    canResend
                        ? 'Tap here to resend'
                        : 'We’ll resend it shortly.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: canResend
                          ? AppColors.primaryBlue700
                          : AppColors.textSecondary,
                      fontWeight: canResend
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // VERIFY BUTTON
  // ------------------------------------------------------------

  Widget _buildVerifyButton() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _isOtpComplete ? 1 : 0.75,
      child: Container(
        width: double.infinity,
        height: 88,
        decoration: BoxDecoration(
          gradient: AppColors.buttonGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.22),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isOtpComplete && !_isVerifying
                ? _verifyOtp
                : null,
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  if (_isVerifying)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  else
                    const Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Verify & Continue',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ),

                  const Spacer(),

                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.17),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.white,
                      size: 34,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // DIVIDER
  // ------------------------------------------------------------

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.purple100,
            thickness: 1.5,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            'OR',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const Expanded(
          child: Divider(
            color: AppColors.purple100,
            thickness: 1.5,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // CHANGE PHONE NUMBER
  // ------------------------------------------------------------

  Widget _buildChangePhoneButton() {
    return SizedBox(
      width: double.infinity,
      height: 82,
      child: OutlinedButton(
        onPressed: widget.onChangePhone,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(
            color: AppColors.purple200,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.edit_outlined,
              size: 27,
              color: AppColors.primaryPurple,
            ),

            const SizedBox(width: 22),

            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Change phone number',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SECURITY MESSAGE
  // ------------------------------------------------------------

  Widget _buildSecurityMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.purple100.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.verified_user_outlined,
            size: 34,
            color: AppColors.primaryPurple,
          ),
        ),

        const SizedBox(width: 20),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your number is safe with us.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 5),

              Text(
                'We use it only for verification and account security.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================================================================
// BACK BUTTON
// ==================================================================

class _BackButton extends StatelessWidget {
  const _BackButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(
        Icons.arrow_back_rounded,
        size: 32,
        color: AppColors.textPrimary,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
      ),
      tooltip: 'Go back',
    );
  }
}

// ==================================================================
// BACKGROUND
// ==================================================================

class _OtpBackground extends StatelessWidget {
  const _OtpBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF0F1FF),
                Color(0xFFEAF6FF),
                Color(0xFFFDFDFF),
              ],
            ),
          ),
        ),

        Positioned(
          top: -100,
          left: -130,
          child: _circle(
            380,
            AppColors.primaryPurple.withValues(alpha: 0.12),
          ),
        ),

        Positioned(
          top: 80,
          right: -160,
          child: _circle(
            350,
            AppColors.primaryBlue.withValues(alpha: 0.12),
          ),
        ),

        Positioned(
          top: 360,
          left: -160,
          child: _circle(
            300,
            AppColors.primaryPurple.withValues(alpha: 0.07),
          ),
        ),
      ],
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// HERO ILLUSTRATION
class _OtpHeroIllustration extends StatelessWidget {
  const _OtpHeroIllustration();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Image.asset(
        'assets/images/otp_hero_illustration.png',
        fit: BoxFit.contain,
        alignment: Alignment.center,
      ),
    );
  }
}