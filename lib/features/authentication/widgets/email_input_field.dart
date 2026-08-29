import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class EmailInputField extends StatelessWidget {
  const EmailInputField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      /// Email keyboard
      keyboardType: TextInputType.emailAddress,

      /// Shows "Next" on the keyboard
      textInputAction: TextInputAction.next,

      /// Typed text
      style: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),

      cursorColor: AppColors.primaryPurple,

      decoration: InputDecoration(
        hintText: 'Enter your email',

        hintStyle: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),

        // Email icon
        prefixIcon: const Icon(
          Icons.mail_outline_rounded,
          color: AppColors.primaryPurple,
          size: 25,
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

        /// Validation error text
        errorStyle: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      /// Email validation
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }

        final emailRegex = RegExp(
          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
        );

        if (!emailRegex.hasMatch(value.trim())) {
          return 'Please enter a valid email';
        }

        return null;
      },
    );
  }
}