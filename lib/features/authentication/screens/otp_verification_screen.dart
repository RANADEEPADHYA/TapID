import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../widgets/otp_verification_button.dart';

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

  /// VERIFY OTP
  void verifyOtp() {
    if (!_isOtpComplete || _isVerifying) {
      return;
    }

    widget.onVerify(_otp);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.40,
            child: const _OtpHeroIllustration(),
          ),

          /// HERO / TOP SECTION
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.40,
            child: const _OtpHeroIllustration(),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: size.height * 0.36,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 40,
                right: 40,
                top: 40,
                bottom:
                MediaQuery.paddingOf(context).bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(38),
                  topRight: Radius.circular(38),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// TITLE
                    Text(
                      'Verify your number',
                      style: GoogleFonts.roboto(
                        color: AppColors.darkBlue950,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    /// DESCRIPTION
                    Text(
                      'We’ve sent a 6-digit verification code\nto '
                          '${widget.phoneNumber}',
                      style: GoogleFonts.roboto(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// OTP INPUT BOX
                    _buildOtpFields(),
                    const SizedBox(height: 20),

                    /// card for resend
                    _buildResendPanel(),
                    const SizedBox(height: 50),

                    /// VERIFY BUTTON
                    OtpVerificationButton(
                      enabled: _isOtpComplete && !_isVerifying,
                      isLoading: _isVerifying,
                      onTap: verifyOtp,
                    ),

                    const SizedBox(height: 10),

                    ///DIVIDER
                    Row(
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
                    ),
                    const SizedBox(height: 10),

                    _buildChangePhoneButton(),
                  ],
                ),
              ),
            ),
          ),
        ]
      )
    );
  }

  /// OTP INPUT FIELDS
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
                height: 70,
                decoration: BoxDecoration(
                  color: isFocused
                      ? AppColors.primaryBlue50
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isFocused
                        ? AppColors.gradientSky
                        : isFilled
                        ? AppColors.primaryPurple
                        : AppColors.black.withValues(alpha: 0.15),
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
                    style: GoogleFonts.roboto(
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
                        verifyOtp();
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

  /// RESEND OTP PANEL
  Widget _buildResendPanel() {
    final canResend = _remainingSeconds == 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
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
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue100,
            ),
            child: const Icon(
              Icons.schedule_rounded,
              size: 30,
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
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (!canResend)
                      Text(
                        _formattedTime,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  ],
                ),

                GestureDetector(
                  onTap: canResend ? _resendOtp : null,
                  child: Text(
                    canResend
                        ? 'Tap here to resend'
                        : 'We’ll resend it shortly.',
                    style: GoogleFonts.roboto(
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

  /// CHANGE PHONE NUMBER
  Widget _buildChangePhoneButton() {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: OutlinedButton(
        onPressed: widget.onChangePhone,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(
            color: AppColors.primaryPurple,
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
              size: 30,
              color: AppColors.primaryPurple,
            ),

            const SizedBox(width: 15),

            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Change phone number',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ),
          ],
        ),
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
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [

            /// OTP HERO ILLUSTRATION
            Positioned.fill(
              child: Transform.scale(
                scale: 1.4,
                child: Image.asset(
                  'assets/images/authentication/otp_hero_illustration.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}