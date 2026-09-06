import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../widgets/auth_google_button.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/email_input_field.dart';
import '../widgets/password_input_field.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// ═══════════════════════════════════════════════════════════════
  /// SIGN UP
  Future<void> _signUp() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please accept the Terms of Service and Privacy Policy',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: Add your registration logic here.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  /// ═══════════════════════════════════════════════════════════════
  /// GOOGLE SIGN UP
  Future<void> _continueWithGoogle() async {
    FocusScope.of(context).unfocus();

    // TODO: Add Google authentication here.
  }

  /// ═══════════════════════════════════════════════════════════════
  /// BACK
  void _goBack() {
    Navigator.of(context).pop();
  }

  /// ═══════════════════════════════════════════════════════════════
  /// GO TO SIGN IN
  void _goToSignIn() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const SignInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple50,
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),

          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              return SingleChildScrollView(
                /// Allows the screen to move when the keyboard opens.
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),

                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        /// Full available width inside the horizontal padding.
                        maxWidth: double.infinity,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// ═══════════════════════════════════════════
                          /// BRAND + TEXT
                          Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /// LEFT — TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(
                                      height: (height * 0.01).clamp(20.0, 40.0).toDouble(),
                                    ),

                                    /// TITLE
                                    Text(
                                      'Create your account',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.roboto(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.black,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    /// SUBTITLE
                                    Text(
                                      'Join TapID and simplify your identity verification.',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 20),

                              /// RIGHT — LOGO
                              Image.asset(
                                'assets/images/TabID_transparent.png',
                                width: width * 0.30,
                                height: width * 0.30,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),


                          /// ═══════════════════════════════════════════
                          /// GOOGLE SIGN UP
                          AuthGoogleButton(
                            text: 'Sign up with Google',
                            onPressed: _continueWithGoogle,
                          ),

                          const SizedBox(height: 28),

                          /// ═══════════════════════════════════════════
                          /// DIVIDER
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 0.7,
                                  color: AppColors.purple400,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Or sign up with email',
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Container(
                                  height: 0.7,
                                  color: AppColors.purple400,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          /// ═══════════════════════════════════════════
                          /// FORM
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [

                                /// ─────────────────────────────────
                                /// EMAIL
                                EmailInputField(
                                  controller: _emailController,
                                ),

                                const SizedBox(height: 14),

                                /// ─────────────────────────────────
                                /// CREATE PASSWORD
                                PasswordInputField(
                                  controller: _passwordController,
                                ),

                                const SizedBox(height: 14),

                                /// ─────────────────────────────────
                                /// CONFIRM PASSWORD
                                PasswordInputField(
                                  controller:
                                  _confirmPasswordController,
                                  onSubmitted: (_) => _signUp(),
                                ),

                                const SizedBox(height: 18),

                                /// ═════════════════════════════════
                                /// TERMS & PRIVACY
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: Checkbox(
                                        value: _acceptedTerms,
                                        activeColor:
                                        AppColors.primaryPurple,
                                        side: const BorderSide(
                                          color:
                                          AppColors.primaryPurple,
                                          width: 2,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(4),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _acceptedTerms =
                                                value ?? false;
                                          });
                                        },
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child: Wrap(
                                          children: [
                                            Text(
                                              'I agree to the ',
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w400,
                                                color: AppColors
                                                    .textSecondary,
                                              ),
                                            ),

                                            GestureDetector(
                                              onTap: () {
                                                // TODO:
                                                // Open Terms of Service
                                              },
                                              child: Text(
                                                'Terms of Service',
                                                style:
                                                GoogleFonts.roboto(
                                                  fontSize: 14,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  color: AppColors
                                                      .primaryPurple,
                                                ),
                                              ),
                                            ),

                                            Text(
                                              ' and ',
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w400,
                                                color: AppColors
                                                    .textSecondary,
                                              ),
                                            ),

                                            GestureDetector(
                                              onTap: () {
                                                // TODO:
                                                // Open Privacy Policy
                                              },
                                              child: Text(
                                                'Privacy Policy',
                                                style:
                                                GoogleFonts.roboto(
                                                  fontSize: 14,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  color: AppColors
                                                      .primaryPurple,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                /// ═════════════════════════════════
                                /// SIGN UP BUTTON
                                SizedBox(
                                  width: double.infinity,
                                  child: AuthSubmitButton(
                                    isLoading: _isLoading,
                                    onPressed: _signUp,
                                    text: 'Sign up',
                                  ),
                                ),
                                const SizedBox(height: 18),

                                /// ═════════════════════════════════
                                /// SIGN IN
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account?',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color:
                                        AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 5),

                                    /// ─────────────────────────────────────────
                                    /// Sign in button
                                    TextButton(
                                      onPressed: _goToSignIn,
                                      style: TextButton.styleFrom(
                                        padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 3,
                                          vertical: 6,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                        MaterialTapTargetSize
                                            .shrinkWrap,
                                      ),
                                      child: Text(
                                        'Sign in',
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color:
                                          AppColors.primaryPurple,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          /// ═══════════════════════════════════════════
                          /// SECURITY FOOTER
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFECE7FF),
                              border: Border.all(
                                color: const Color(0xFFDCD2FF),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.verified_user_rounded,
                                color: AppColors.primaryPurple,
                                size: 29,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your data is encrypted and secure',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: (height * 0.01).clamp(12.0, 24.0).toDouble(),),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}