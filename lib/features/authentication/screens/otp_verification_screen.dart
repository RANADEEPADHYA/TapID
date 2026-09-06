import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/animated_arrow.dart';
import '../widgets/auth_google_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.onVerify,
    this.onResend,
    this.onGoogleSignIn,
  });

  final String phoneNumber;

  /// Called when the user presses Verify OTP.
  final ValueChanged<String>? onVerify;

  /// Called when the user presses Resend OTP.
  final VoidCallback? onResend;

  /// Called when Google button is pressed.
  final VoidCallback? onGoogleSignIn;

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  /// ═══════════════════════════════════════════════════════════════
  /// OTP
  final TextEditingController _otpController =
  TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  /// ═══════════════════════════════════════════════════════════════
  /// TIMER
  Timer? _timer;

  int _remainingSeconds = 45;
  int _resendSeconds = 30;
  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_onOtpChanged);
    _startTimer();

    // Automatically focus OTP field after screen opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _otpFocusNode.requestFocus();
      }
    });
  }

  /// ═══════════════════════════════════════════════════════════════
  /// OTP LISTENER
  void _onOtpChanged() {
    setState(() {});

    // Automatically verify when 6 digits are entered.
    if (_otpController.text.length == 6) {
      _verifyOtp();
    }
  }

  /// ═══════════════════════════════════════════════════════════════
  /// TIMER
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          }

          if (_resendSeconds > 0) {
            _resendSeconds--;
          }
        });

        if (_remainingSeconds == 0 &&
            _resendSeconds == 0) {
          timer.cancel();
        }
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;

    return '$minutes:${remaining.toString().padLeft(2, '0')}';
  }

  // ═══════════════════════════════════════════════════════════════
  // VERIFY OTP
  // ═══════════════════════════════════════════════════════════════

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6 ||
        _isVerifying) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isVerifying = true;
    });

    try {
      widget.onVerify?.call(_otpController.text);
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // RESEND OTP
  // ═══════════════════════════════════════════════════════════════

  Future<void> _resendOtp() async {
    if (_resendSeconds > 0 || _isResending) {
      return;
    }

    setState(() {
      _isResending = true;
    });

    try {
      widget.onResend?.call();

      _otpController.clear();

      setState(() {
        _remainingSeconds = 45;
        _resendSeconds = 30;
      });

      _startTimer();

      _otpFocusNode.requestFocus();
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.removeListener(_onOtpChanged);
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.white,

      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              /// ─────────────────────────────────────────────
              /// SCROLL VIEW
              /// Added so keyboard does not cover OTP/buttons.
              /// ─────────────────────────────────────────────
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,

              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
              ),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),

                      /// ═══════════════════════════════════════
                      /// BACK BUTTON
                      _BackButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),

                      const SizedBox(height: 34),

                      /// ═══════════════════════════════════════
                      /// HEADER
                      _Header(
                        phoneNumber: widget.phoneNumber,
                        size: size,
                      ),

                      const SizedBox(height: 30),

                      /// ═══════════════════════════════════════
                      /// OTP CARD
                      _OtpCard(
                        controller: _otpController,
                        focusNode: _otpFocusNode,
                        remainingSeconds: _remainingSeconds,
                        resendSeconds: _resendSeconds,
                        isVerifying: _isVerifying,
                        isResending: _isResending,
                        onVerify: _verifyOtp,
                        onResend: _resendOtp,
                        onGoogleSignIn:
                        widget.onGoogleSignIn,
                      ),

                      const SizedBox(height: 20),

                      // ═══════════════════════════════════════
                      // TROUBLE CARD
                      // ═══════════════════════════════════════

                      const _TroubleCard(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BACK BUTTON
// ═══════════════════════════════════════════════════════════════

class _BackButton extends StatelessWidget {
  const _BackButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.textSecondary.withValues(
                  alpha: .10,
                ),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primaryPurple,
            size: 30,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HEADER
// ═══════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  const _Header({
    required this.phoneNumber,
    required this.size,
  });

  final String phoneNumber;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final double illustrationSize =
    size.width < 380 ? 150 : 180;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─────────────────────────────────────────────
        // ILLUSTRATION
        // ─────────────────────────────────────────────

        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: illustrationSize,
            height: illustrationSize,
            child: Image.asset(
              'assets/images/illustrations/otp_verification.png',
              fit: BoxFit.contain,

              // Safe fallback if asset is not added yet.
              errorBuilder: (_, __, ___) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.purple400,
                  ),
                  child: Icon(
                    Icons.verified_user_rounded,
                    size: 82,
                    color: AppColors.primaryPurple,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 4),

        // ─────────────────────────────────────────────
        // TITLE
        // ─────────────────────────────────────────────

        Text(
          'Enter OTP',
          style: GoogleFonts.roboto(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
            height: 1.1,
          ),
        ),

        const SizedBox(height: 10),

        // ─────────────────────────────────────────────
        // SUBTITLE
        // ─────────────────────────────────────────────

        Text(
          'We’ve sent you a code',
          style: GoogleFonts.roboto(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryPurple,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Enter the 6-digit OTP sent to your\n'
              'registered phone number',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          phoneNumber,
          style: GoogleFonts.roboto(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryPurple,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// OTP CARD
// ═══════════════════════════════════════════════════════════════

class _OtpCard extends StatelessWidget {
  const _OtpCard({
    required this.controller,
    required this.focusNode,
    required this.remainingSeconds,
    required this.resendSeconds,
    required this.isVerifying,
    required this.isResending,
    required this.onVerify,
    required this.onResend,
    required this.onGoogleSignIn,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  final int remainingSeconds;
  final int resendSeconds;

  final bool isVerifying;
  final bool isResending;

  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback? onGoogleSignIn;

  @override
  Widget build(BuildContext context) {
    final bool hasSixDigits =
        controller.text.length == 6;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        22,
        24,
        22,
        26,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withValues(
              alpha: .08,
            ),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: AppColors.purple400,
          width: 1,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // ═════════════════════════════════════════════
          // LABEL
          // ═════════════════════════════════════════════

          Text(
            'Enter 6-digit OTP',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 18),

          // ═════════════════════════════════════════════
          // OTP INPUT
          // ═════════════════════════════════════════════

          _OtpInput(
            controller: controller,
            focusNode: focusNode,
          ),

          const SizedBox(height: 24),

          // ═════════════════════════════════════════════
          // SECURITY MESSAGE
          // ═════════════════════════════════════════════

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.purple50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(
                      alpha: .65,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user_outlined,
                    color: AppColors.primaryPurple,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Never share your OTP',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        'TapID will never ask for your OTP.',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ═════════════════════════════════════════════
          // EXPIRY
          // ═════════════════════════════════════════════

          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'OTP expires in  ',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextSpan(
                    text: _formatTime(
                      remainingSeconds,
                    ),
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ═════════════════════════════════════════════
          // VERIFY BUTTON
          // ═════════════════════════════════════════════

          _VerifyButton(
            enabled: hasSixDigits && !isVerifying,
            isLoading: isVerifying,
            onTap: onVerify,
          ),

          const SizedBox(height: 20),

          // ═════════════════════════════════════════════
          // OR
          // ═════════════════════════════════════════════

          const _OrDivider(),

          const SizedBox(height: 18),

          // ═════════════════════════════════════════════
          // GOOGLE
          // ═════════════════════════════════════════════

          AuthGoogleButton(
            text: 'Continue with Google',
            onPressed: onGoogleSignIn ?? () {},
          ),

          const SizedBox(height: 20),

          // ═════════════════════════════════════════════
          // RESEND
          // ═════════════════════════════════════════════

          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  'Didn’t receive OTP?  ',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),

                GestureDetector(
                  onTap: resendSeconds == 0
                      ? onResend
                      : null,
                  child: Text(
                    resendSeconds == 0
                        ? 'Resend OTP'
                        : 'Resend OTP (${_formatTime(resendSeconds)})',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: resendSeconds == 0
                          ? AppColors.primaryPurple
                          : AppColors.textSecondary,
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

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;

    return '$minutes:${remaining.toString().padLeft(2, '0')}';
  }
}

// ═══════════════════════════════════════════════════════════════
// OTP INPUT
// ═══════════════════════════════════════════════════════════════

class _OtpInput extends StatelessWidget {
  const _OtpInput({
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ─────────────────────────────────────────────
        // ACTUAL TEXT FIELD
        // ─────────────────────────────────────────────

        TextField(
          controller: controller,
          focusNode: focusNode,

          keyboardType: TextInputType.number,

          textInputAction: TextInputAction.done,

          maxLength: 6,

          autofocus: false,

          style: const TextStyle(
            color: Colors.transparent,
            fontSize: 1,
          ),

          cursorColor: Colors.transparent,

          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),

          // Keeps the actual field usable while
          // the custom boxes are displayed above it.
        ),

        // ─────────────────────────────────────────────
        // VISUAL OTP BOXES
        // ─────────────────────────────────────────────

        Positioned.fill(
          child: IgnorePointer(
            child: Row(
              children: List.generate(
                6,
                    (index) {
                  final String value =
                  controller.text.length > index
                      ? controller.text[index]
                      : '';

                  final bool active =
                      controller.text.length == index;

                  return Expanded(
                    child: Container(
                      height: 68,
                      margin: EdgeInsets.only(
                        right: index == 5 ? 0 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                        BorderRadius.circular(17),
                        border: Border.all(
                          color: active
                              ? AppColors.primaryPurple
                              : AppColors.purple400,
                          width: active ? 1.6 : 1.2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: value.isEmpty
                          ? active
                          ? Container(
                        width: 2,
                        height: 28,
                        color: AppColors.primaryPurple,
                      )
                          : null
                          : Text(
                        value,
                        style: GoogleFonts.roboto(
                          fontSize: 25,
                          fontWeight:
                          FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// VERIFY BUTTON
// ═══════════════════════════════════════════════════════════════

class _VerifyButton extends StatelessWidget {
  const _VerifyButton({
    required this.enabled,
    required this.isLoading,
    required this.onTap,
  });

  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1 : .55,
        child: Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.primaryPurple,
                AppColors.nextButtonPurple,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withValues(
                  alpha: .20,
                ),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(
                      AppColors.white,
                    ),
                  ),
                )
              else
                Text(
                  'Verify OTP',
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),

              if (!isLoading)
                const Positioned(
                  right: 18,
                  child: AnimatedArrow(
                    size: 32,
                    color: AppColors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// OR DIVIDER
// ═══════════════════════════════════════════════════════════════

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.purple400,
            thickness: 1,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          child: Text(
            'OR',
            style: GoogleFonts.roboto(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        Expanded(
          child: Divider(
            color: AppColors.purple400,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TROUBLE CARD
// ═══════════════════════════════════════════════════════════════

class _TroubleCard extends StatelessWidget {
  const _TroubleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: AppColors.purple50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.purple400,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Having trouble?',
                  style: GoogleFonts.roboto(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Please check your network or try again.',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 20,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}