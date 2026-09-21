import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../widgets/auth_continue_button.dart';
import '../widgets/auth_hero_section.dart';
import '../widgets/phone_number_field.dart';
import '../widgets/security_info_card.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({
    super.key,
  });

  @override
  State<LoginSignupScreen> createState() =>
      _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final TextEditingController _phoneController =
  TextEditingController();

  final FocusNode _phoneFocusNode = FocusNode();

  bool get _isPhoneValid {
    return _phoneController.text.trim().length == 10;
  }

  @override
  void initState() {
    super.initState();

    _phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _phoneController
      ..removeListener(_onPhoneChanged)
      ..dispose();

    _phoneFocusNode.dispose();

    super.dispose();
  }

  void _continue() {
    if (!_isPhoneValid) return;

    final String phoneNumber =
        '+91${_phoneController.text.trim()}';

    debugPrint('Phone number: $phoneNumber');

    // TODO:
    // Send OTP here.
  }

  void _skip() {
    Navigator.of(context).pop();
  }

  void _openPrivacyPolicy() {
    debugPrint('Privacy Policy');
  }

  void _openTerms() {
    debugPrint('Terms of Service');
  }

  void _openTapIdTerms() {
    debugPrint('TapID Terms of Use');
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.white,

      resizeToAvoidBottomInset: true,

      body: Stack(
        children: [

          /// ═══════════════════════════════════════════════════
          /// HERO / TOP SECTION
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.46,
            child: const AuthHeroSection(),
          ),

          /// ═══════════════════════════════════════════════════
          /// TOP RIGHT SKIP
          Positioned(
            top: MediaQuery.paddingOf(context).top + 18,
            right: 20,
            child: _SkipButton(
              onTap: _skip,
            ),
          ),

          /// ═══════════════════════════════════════════════════
          /// AUTHENTICATION PANEL
          Positioned(
            left: 0,
            right: 0,
            top: size.height * 0.40,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(38),
                  topRight: Radius.circular(38),
                ),
              ),

              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                padding: EdgeInsets.only(
                  left: 44,
                  right: 44,
                  top: 34,
                  bottom:
                  MediaQuery.paddingOf(context).bottom + 24,
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    /// ═══════════════════════════════════════
                    /// DRAG INDICATOR
                    Center(
                      child: Container(
                        width: 76,
                        height: 7,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6D9E2),
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 68),

                    /// ═══════════════════════════════════════
                    /// TITLE
                    Text(
                      'Enter your number',
                      style: GoogleFonts.roboto(
                        color: AppColors.darkBlue950,
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// ═══════════════════════════════════════
                    /// DESCRIPTION
                    Text(
                      'We\'ll send you a verification code\n'
                          'to get started.',
                      style: GoogleFonts.roboto(
                        color: AppColors.textSecondary,
                        fontSize: 21,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 42),

                    /// ═══════════════════════════════════════
                    /// PHONE NUMBER
                    PhoneNumberField(
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                    ),

                    const SizedBox(height: 30),

                    /// ═══════════════════════════════════════
                    /// SECURITY INFORMATION
                    const SecurityInfoCard(),

                    const SizedBox(height: 74),

                    /// ═══════════════════════════════════════
                    /// CONTINUE
                    AuthContinueButton(
                      enabled: _isPhoneValid,
                      onTap: _continue,
                    ),

                    const SizedBox(height: 38),

                    /// ═══════════════════════════════════════
                    /// TERMS
                    Center(
                      child: _TermsText(
                        onPrivacyTap: _openPrivacyPolicy,
                        onTermsTap: _openTerms,
                        onTapIdTermsTap: _openTapIdTerms,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════
/// SKIP BUTTON
class _SkipButton extends StatelessWidget {
  const _SkipButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white.withValues(alpha: 0.65),
      borderRadius: BorderRadius.circular(40),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),

        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 15,
          ),

          child: Text(
            'Skip',
            style: GoogleFonts.roboto(
              color: AppColors.darkBlue950,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════
/// TERMS TEXT
class _TermsText extends StatelessWidget {
  const _TermsText({
    required this.onPrivacyTap,
    required this.onTermsTap,
    required this.onTapIdTermsTap,
  });

  final VoidCallback onPrivacyTap;
  final VoidCallback onTermsTap;
  final VoidCallback onTapIdTermsTap;

  @override
  Widget build(BuildContext context) {
    final TextStyle normalStyle = GoogleFonts.roboto(
      color: AppColors.textSecondary,
      fontSize: 17,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );

    final TextStyle linkStyle = normalStyle.copyWith(
      color: AppColors.primaryPurple1,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.primaryPurple1,
      fontWeight: FontWeight.w500,
    );

    return Wrap(
      alignment: WrapAlignment.center,
      children: [

        Text(
          'By continuing, I agree to the ',
          style: normalStyle,
        ),

        GestureDetector(
          onTap: onPrivacyTap,
          child: Text(
            'Privacy Policy',
            style: linkStyle,
          ),
        ),

        Text(
          ', ',
          style: normalStyle,
        ),

        GestureDetector(
          onTap: onTermsTap,
          child: Text(
            'Terms of Service',
            style: linkStyle,
          ),
        ),

        Text(
          '\nand ',
          style: normalStyle,
        ),

        GestureDetector(
          onTap: onTapIdTermsTap,
          child: Text(
            'TapID Terms of Use',
            style: linkStyle,
          ),
        ),
      ],
    );
  }
}