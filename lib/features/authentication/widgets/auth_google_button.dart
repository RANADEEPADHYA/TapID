import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/animated_arrow.dart';

class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({
    super.key,
    required this.onPressed,
    this.text = 'Continue with Google',
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(30),
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: .18),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onPressed,
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .15),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Google Icon
              Center(
                child: Image.asset(
                  'assets/images/icon/ic_google.png',
                  width: 35,
                  height: 35,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 20),

              /// Button Text
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),

              /// Animated Arrow
              const AnimatedArrow(
                size: 32,
                color: AppColors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}