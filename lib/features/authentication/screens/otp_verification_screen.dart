import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/back_button.dart';
import '../../profile_setup/screens/create_profile_screen.dart';
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
  final Future<bool> Function(String otp) onVerify;
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
  bool _isVerifying = false;
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
    /// Clear the existing OTP.
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
  Future<void> verifyOtp() async {
    if (!_isOtpComplete || _isVerifying) return;

    setState(() {
      _isVerifying = true;
    });

    /// Show the processing popup.
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _OtpStatusDialog(
        status: OtpStatus.processing,
      ),
    );

    bool isSuccess = false;

    try {
      /// Verify the OTP using your authentication service.
      isSuccess = await widget.onVerify(_otp);
      /// Keep the processing animation visible briefly.
      await Future.delayed(const Duration(milliseconds: 900));
    } catch (_) {
      isSuccess = false;
    }
    if (!mounted) return;
    /// Close the processing popup.
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      _isVerifying = false;
    });

    /// Show the final result.
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _OtpStatusDialog(
        status: isSuccess
            ? OtpStatus.success
            : OtpStatus.failure,
        onContinue: () {

          /// SUCCESS: Close dialog and navigate to Create Profile.
          if (isSuccess) {
            Navigator.of(dialogContext).pop();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateProfileScreen(
                  onContinue: ({
                    required fullName,
                    required username,
                    required bio,
                  }) {
                    debugPrint('Name: $fullName');
                    debugPrint('Username: $username');
                    debugPrint('Bio: $bio');
                    // TODO: Save the profile to your backend.
                    // Navigate to Step 2: Social Links.
                  },
                  onSkip: () {
                    // Navigate to Step 2: Social Links.
                  },
                  onCheckUsername: (username) async {
                    // TODO: Check username availability through
                    // your backend. Return true if available.
                    return false;
                  },
                  onPickPhoto: () {
                    // TODO: Open the gallery or camera.
                  },
                ),
              ),
            );
          }

          /// FAILURE: Only close the dialog.
          else {
            Navigator.of(dialogContext).pop();
          }
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'We’ve sent a 6-digit verification code',
                          style: GoogleFonts.roboto(
                            color: AppColors.textSecondary,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                                  'to   ',
                              style: GoogleFonts.roboto(
                                color: AppColors.textSecondary,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              widget.phoneNumber,
                              style: GoogleFonts.roboto(
                                color: AppColors.textSecondary,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
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

          /// FLOATING BACK BUTTON
          Positioned(
            top: 50,
            left: 20,
            child: AppBackButton(
              size: 48,
              iconSize: 24,
              onTap: widget.onChangePhone,
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

        return [
          if (index > 0) const SizedBox(width: 10),

          Expanded(
            child: Focus(
              onKeyEvent: (_, event) =>
                  _handleKeyEvent(index, event),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 70,
                width: double.infinity,
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
        ];
      }).expand((widgets) => widgets).toList(),
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
                          color: AppColors.primaryBlue700,
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

///Pop up
enum OtpStatus {
  processing,
  success,
  failure,
}
class _OtpStatusDialog extends StatelessWidget {
  const _OtpStatusDialog({
    required this.status,
    this.onContinue,
  });
  final OtpStatus status;
  final VoidCallback? onContinue;
  @override
  Widget build(BuildContext context) {
    final isProcessing = status == OtpStatus.processing;
    final isSuccess = status == OtpStatus.success;
    final Color accentColor = isProcessing
        ? AppColors.primaryBlue
        : isSuccess
        ? Colors.green
        : Colors.redAccent;

    final String title = isProcessing
        ? 'Verifying your number'
        : isSuccess
        ? 'Verification successful!'
        : 'Verification failed';
    final String message = isProcessing
        ? 'Please wait while we verify your OTP.'
        : isSuccess
        ? 'Your phone number has been verified successfully.'
        : 'The OTP could not be verified. Please try again.';
    return PopScope(
      canPop: !isProcessing,
      child: Dialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// Status icon / processing indicator
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: isProcessing
                    ? SizedBox(
                  width: 42,
                  height: 42,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: accentColor,
                  ),
                )
                    : Icon(
                  isSuccess
                      ? Icons.check_circle_rounded
                      : Icons.error_rounded,
                  color: accentColor,
                  size: 52,
                ),
              ),

              const SizedBox(height: 24),

              /// Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkBlue950,
                ),
              ),


              /// Description
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),

              if (!isProcessing) ...[
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isSuccess ? 'Continue' : 'Try Again',
                      style: GoogleFonts.roboto(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}