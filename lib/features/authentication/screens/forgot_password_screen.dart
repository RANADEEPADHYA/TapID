import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/animated_arrow.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController _phoneController = TextEditingController();

  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _otpFocusNodes =
  List.generate(6, (_) => FocusNode());

  // ============================================================
  // STATE
  // ============================================================

  bool _otpSent = false;
  bool _isVerifying = false;

  int _otpSeconds = 45;
  int _resendSeconds = 30;

  Timer? _otpTimer;
  Timer? _resendTimer;

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void dispose() {
    _phoneController.dispose();

    for (final controller in _otpControllers) {
      controller.dispose();
    }

    for (final node in _otpFocusNodes) {
      node.dispose();
    }

    _otpTimer?.cancel();
    _resendTimer?.cancel();

    super.dispose();
  }

  // ============================================================
  // SEND OTP
  // ============================================================

  void _sendOtp() {
    final phone = _phoneController.text.trim();

    if (phone.length != 10) {
      _showMessage('Please enter a valid 10-digit phone number.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _otpSent = true;
      _otpSeconds = 45;
      _resendSeconds = 30;
    });

    _startOtpTimer();
    _startResendTimer();

    // TODO:
    // Connect Firebase Phone Authentication here.
  }

  // ============================================================
  // OTP TIMER
  // ============================================================

  void _startOtpTimer() {
    _otpTimer?.cancel();

    _otpTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_otpSeconds <= 0) {
          timer.cancel();
          return;
        }

        setState(() {
          _otpSeconds--;
        });
      },
    );
  }

  // ============================================================
  // RESEND TIMER
  // ============================================================

  void _startResendTimer() {
    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_resendSeconds <= 0) {
          timer.cancel();
          return;
        }

        setState(() {
          _resendSeconds--;
        });
      },
    );
  }

  // ============================================================
  // RESEND OTP
  // ============================================================

  void _resendOtp() {
    if (_resendSeconds > 0) return;

    setState(() {
      _otpSeconds = 45;
      _resendSeconds = 30;

      for (final controller in _otpControllers) {
        controller.clear();
      }
    });

    _startOtpTimer();
    _startResendTimer();

    _otpFocusNodes.first.requestFocus();

    // TODO:
    // Resend Firebase OTP here.
  }

  // ============================================================
  // OTP INPUT
  // ============================================================

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }

    setState(() {});
  }

  // ============================================================
  // VERIFY OTP
  // ============================================================

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((e) => e.text).join();

    if (otp.length != 6) {
      _showMessage('Please enter the complete 6-digit OTP.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isVerifying = true;
    });

    // TODO:
    // Verify OTP with Firebase here.

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      _isVerifying = false;
    });

    _showMessage('OTP verified successfully.');
  }

  // ============================================================
  // CHANGE PHONE NUMBER
  // ============================================================

  void _changePhoneNumber() {
    setState(() {
      _otpSent = false;
    });

    _otpTimer?.cancel();
    _resendTimer?.cancel();

    for (final controller in _otpControllers) {
      controller.clear();
    }

    FocusScope.of(context).unfocus();
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FF),
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          // CHANGE:
          // Makes the screen keyboard-safe and prevents overflow.
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,

          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            32,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // BACK BUTTON
              // ==================================================

              _buildBackButton(),

              const SizedBox(height: 24),

              // ==================================================
              // HEADER
              // ==================================================

              _buildHeader(),

              const SizedBox(height: 32),

              // ==================================================
              // STEP 1
              // ==================================================

              _buildPhoneVerificationCard(),

              // ==================================================
              // STEP 2
              // ==================================================

              if (_otpSent) ...[
                const SizedBox(height: 24),
                _buildOtpVerificationCard(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BACK BUTTON
  // ============================================================

  Widget _buildBackButton() {
    return Material(
      color: AppColors.white.withValues(alpha: .75),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Navigator.of(context).pop(),
        child: const SizedBox(
          width: 58,
          height: 58,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 30,
            color: AppColors.primaryPurple,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forgot',
                    style: GoogleFonts.roboto(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      height: .95,
                      color: AppColors.black,
                    ),
                  ),

                  Text(
                    'Password?',
                    style: GoogleFonts.roboto(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      color: AppColors.primaryPurple,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    _otpSent
                        ? 'We sent a 6-digit verification code to your registered phone number.'
                        : 'Don’t worry! Enter your registered phone number and we’ll send you a code to reset your password.',
                    style: GoogleFonts.roboto(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Illustration
            _buildIllustration(),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // ILLUSTRATION
  // ============================================================

  Widget _buildIllustration() {
    return SizedBox(
      width: 120,
      height: 150,
      child: Image.asset(
        'assets/images/illustrations/forgot_password.png',
        fit: BoxFit.contain,
      ),
    );
  }

  // ============================================================
  // PHONE CARD
  // ============================================================

  Widget _buildPhoneVerificationCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            number: '1',
            title: 'Verify your phone number',
            description:
            'Enter your registered phone number. We’ll send you a 6-digit OTP.',
          ),

          const SizedBox(height: 26),

          Text(
            'Phone number',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4D526D),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _buildCountryCode(),

              const SizedBox(width: 12),

              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  enabled: !_otpSent,
                  style: GoogleFonts.roboto(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  decoration: _inputDecoration(
                    hintText: 'Enter your phone number',
                  ).copyWith(
                    counterText: '',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildPrimaryButton(
            label: _otpSent ? 'OTP Sent' : 'Send OTP',
            enabled: !_otpSent,
            onPressed: _sendOtp,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COUNTRY CODE
  // ============================================================

  Widget _buildCountryCode() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD9D9E8),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          const Text(
            '🇮🇳',
            style: TextStyle(fontSize: 22),
          ),

          const SizedBox(width: 10),

          Text(
            '+91',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),

          const SizedBox(width: 8),

          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.black,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OTP CARD
  // ============================================================

  Widget _buildOtpVerificationCard() {
    final phone = _phoneController.text.trim();

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            number: '2',
            title: 'Enter OTP',
            description:
            'Enter the 6-digit code sent to +91 ${_maskPhone(phone)}',
          ),

          const SizedBox(height: 4),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _changePhoneNumber,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(
                Icons.edit_outlined,
                size: 19,
                color: AppColors.primaryPurple,
              ),
              label: Text(
                'Change',
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // OTP BOXES
          _buildOtpFields(),

          const SizedBox(height: 20),

          // TIMER
          Center(
            child: RichText(
              text: TextSpan(
                text: 'OTP expires in  ',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
                children: [
                  TextSpan(
                    text: _formatTime(_otpSeconds),
                    style: GoogleFonts.roboto(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // SECURITY MESSAGE
          _buildSecurityCard(),

          const SizedBox(height: 22),

          // VERIFY
          _buildPrimaryButton(
            label: _isVerifying ? 'Verifying...' : 'Verify OTP',
            enabled: !_isVerifying && _otpSeconds > 0,
            onPressed: _verifyOtp,
          ),

          const SizedBox(height: 20),

          // RESEND
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  'Didn’t receive OTP? ',
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: _resendSeconds == 0 ? _resendOtp : null,
                  child: Text(
                    _resendSeconds == 0
                        ? 'Resend OTP'
                        : 'Resend OTP (${_formatTime(_resendSeconds)})',
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _resendSeconds == 0
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

  // ============================================================
  // OTP FIELDS
  // ============================================================

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
            (index) {
          return SizedBox(
            width: 46,
            height: 58,
            child: TextField(
              controller: _otpControllers[index],
              focusNode: _otpFocusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryPurple,
              ),
              onChanged: (value) {
                _onOtpChanged(value, index);
              },
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: AppColors.white,
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFDCDCEA),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.primaryPurple,
                    width: 1.8,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // SECURITY CARD
  // ============================================================

  Widget _buildSecurityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5FC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: AppColors.primaryPurple,
              size: 24,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              'Please do not share this OTP with anyone.\nTapID will never ask for your OTP.',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.45,
                color: const Color(0xFF252A4A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STEP HEADER
  // ============================================================

  Widget _buildStepHeader({
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.primaryPurple,
                AppColors.skyBlue,
              ],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                description,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  Widget _buildCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: .06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // PRIMARY BUTTON
  // ============================================================

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1 : .45,
        child: Container(
          width: double.infinity,
          height: 68,
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
                color: AppColors.primaryPurple.withValues(alpha: .20),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),

              const Positioned(
                right: 20,
                child: AnimatedArrow(
                  size: 30,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary.withValues(alpha: .65),
      ),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFFD9D9E8),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFFD9D9E8),
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.primaryPurple,
          width: 1.6,
        ),
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _maskPhone(String phone) {
    if (phone.length < 4) return phone;

    return '${phone.substring(0, 2)}'
        '•••• '
        '${phone.substring(phone.length - 4)}';
  }
}