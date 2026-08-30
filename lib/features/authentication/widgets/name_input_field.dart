import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';

class NameInputField extends StatelessWidget {
  const NameInputField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,

      style: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),

      cursorColor: AppColors.primaryPurple,

      decoration: InputDecoration(
        hintText: 'Full Name',

        hintStyle: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),

        prefixIcon: const Icon(
          Icons.person_outline_rounded,
          color: AppColors.primaryPurple,
          size: 25,
        ),

        filled: true,
        fillColor: AppColors.white.withValues(alpha: .45),

        contentPadding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 18,
          bottom: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.purple400,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.purple400,
            width: 1.2,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.primaryPurple,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.accentOrange,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.accentOrange,
            width: 1.5,
          ),
        ),

        errorStyle: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your name';
        }

        if (value.trim().length < 2) {
          return 'Please enter a valid name';
        }

        return null;
      },
    );
  }
}