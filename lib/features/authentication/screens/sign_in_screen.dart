import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_id/features/authentication/screens/forgot_password_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/app_name.dart';
import '../widgets/auth_google_button.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/email_input_field.dart';
import '../widgets/password_input_field.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
  });
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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


                            SizedBox(
                              height: (height * 0.01).clamp(20.0, 40.0).toDouble(),
                            ),

                            AuthGoogleButton(
                              onPressed: _continueWithGoogle,
                            ),

                            SizedBox(
                              height: (height * 0.01).clamp(30.0, 40.0).toDouble(),
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

                            /// ─────────────────────────────────────────
                            /// LOGIN FORM
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [

                                  const SizedBox(height: 24),

                                  /// ─────────────────────────────────────────
                                  /// EMAIL
                                  EmailInputField(
                                    controller: _emailController,
                                  ),

                                  const SizedBox(height: 14),

                                  /// ─────────────────────────────────────────
                                  /// PASSWORD
                                  PasswordInputField(
                                    controller: _passwordController,
                                    onSubmitted: (_) => _login(),
                                  ),

                                  /// ─────────────────────────────────────────
                                  /// FORGET PASSWORD
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (_) => const ForgotPasswordScreen(),
                                          ),
                                        );
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

                                  /// ═══════════════════════════════════════════
                                  /// SIGN IN BUTTON
                                  AuthSubmitButton(
                                    isLoading: _isLoading,
                                    onPressed: _login,
                                    text: 'Sign In',
                                  ),


                                  /// ═══════════════════════════════════════════
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

                                      /// ─────────────────────────────────────────
                                      /// SIGN UP TEXT BUTTON
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (_) => const SignUpScreen(),
                                            ),
                                          );
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

                                ],
                              ),
                            ),
                            SizedBox(height: (height * 0.01).clamp(20.0, 40.0).toDouble(),),

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