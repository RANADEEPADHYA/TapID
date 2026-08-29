import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class PasswordInputField extends StatefulWidget {
  const PasswordInputField({
    super.key,
    required this.controller,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,

      /// Hides password
      obscureText: _obscurePassword,

      /// Shows "Done" on keyboard
      textInputAction: TextInputAction.done,

      /// Typed text
      style: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),

      cursorColor: AppColors.primaryPurple,

      /// Keyboard Done action
      onFieldSubmitted: widget.onSubmitted,

      decoration: InputDecoration(
        hintText: 'Enter your password',

        hintStyle: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),

        /// Password icon
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.primaryPurple,
          size: 25,
        ),

        /// Show / hide password
        suffixIcon: IconButton(
          tooltip: _obscurePassword
              ? 'Show password'
              : 'Hide password',
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 23,
            color: AppColors.primaryPurple,
          ),
        ),

        filled: true,
        fillColor: AppColors.white.withValues(alpha: .45),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 18,
        ),

        /// Default border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.purple400,
          ),
        ),

        /// Normal state
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.purple400,
            width: 1.2,
          ),
        ),

        /// Focused state
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.primaryPurple,
            width: 1.5,
          ),
        ),

        /// Error state
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.accentOrange,
          ),
        ),

        /// Focused + error state
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.accentOrange,
            width: 1.5,
          ),
        ),

        /// Validation error
        errorStyle: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      /// Password validation
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }

        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }

        return null;
      },
    );
  }
}