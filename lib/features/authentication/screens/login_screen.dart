import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/animated_arrow.dart';
import '../../../widgets/app_name.dart';
import '../widgets/auth_google_button.dart';
import '../widgets/email_input_field.dart';
import '../widgets/password_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    // TODO: Add your authentication logic here.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _continueWithGoogle() async {
    FocusScope.of(context).unfocus();

    // TODO: Add Google authentication here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple50,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final height = constraints.maxHeight;

                  return SingleChildScrollView(
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,

                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Center(
                          child: Column(
                          children: [

                            SizedBox(
                              height: (height * 0.01).clamp(20.0, 40.0).toDouble(),
                            ),

                            /// ─────────────────────────────────────────────
                            /// APP LOGO
                            Image.asset(
                              'assets/images/TabID_transparent.png',
                              width: (width * 0.40),
                              height: (width * 0.40),
                              fit: BoxFit.contain,
                            ),

                            /// ─────────────────────────────────────────
                            /// App Name (TapID)
                            const AppName(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              splitColor: true,
                              tapColor: AppColors.black,
                            ),

                            /// ─────────────────────────────────────────
                            /// INTRO
                            Text(
                              'Your identity, secure and simplified.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            /// ─────────────────────────────────────────
                            /// LOGIN FORM

                            Form(
                              key: _formKey,
                              child: Column(
                                children: [

                                  const SizedBox(height: 24),

                                  EmailInputField(
                                    controller: _emailController,
                                  ),

                                  const SizedBox(height: 14),

                                  PasswordInputField(
                                    controller: _passwordController,
                                    onSubmitted: (_) => _login(),
                                  ),


                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        // TODO: Forgot password
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 8,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Forgot password?',
                                        style: GoogleFonts.roboto(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryPurple,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  _LoginButton(
                                    isLoading: _isLoading,
                                    onPressed: _login,
                                  ),


                                  /// ─────────────────────────────────────────
                                  /// TEXT & TEXT BUTTON
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account?",
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),

                                      const SizedBox(width: 5),

                                      /// SIGN UP TEXT BUTTON
                                      TextButton(
                                        onPressed: () {
                                          // TODO: Navigate to sign up
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 3,
                                            vertical: 6,
                                          ),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          'Sign up',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryPurple,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: (height * 0.01).clamp(20.0, 40.0).toDouble(),
                                  ),

                                  /// ─────────────────────────────────────────
                                  /// DIVIDER & TEXT & DIVIDER
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 0.5,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 18),
                                        child: Text(
                                          'Or continue with email',
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 0.5,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: (height * 0.01).clamp(20.0, 40.0).toDouble(),
                                  ),

                                  AuthGoogleButton(
                                    onPressed: _continueWithGoogle,
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(
                              height: (height * 0.01).clamp(20.0, 40.0).toDouble(),
                            ),

                            /// ─────────────────────────────────────────
                            /// LOGO
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

                            /// ─────────────────────────────────────────
                            /// FOOTER
                            Text(
                              'Your data is encrypted and secure',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                          )
                        )
                      ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════
/// LOGIN BUTTON
class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primaryPurple,
            AppColors.skyBlue
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withValues(alpha: .25),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const Spacer(),

                if (isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  )
                else
                   Text(
                    'Sign In',
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}