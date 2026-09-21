import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryPurple1,
          width: 2,
        ),
      ),
      child: Row(
        children: [

          /// ═════════════════════════════════════════════════
          /// COUNTRY
          Padding(
            padding: const EdgeInsets.only(
              left: 22,
            ),
            child: Row(
              children: [

                const Text(
                  '🇮🇳',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),

                const SizedBox(width: 12),

                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.darkBlue950,
                  size: 26,
                ),

                const SizedBox(width: 12),

                Text(
                  '+91',
                  style: GoogleFonts.roboto(
                    color: AppColors.darkBlue950,
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.darkBlue950,
                  size: 26,
                ),
              ],
            ),
          ),

          /// ═════════════════════════════════════════════════
          /// DIVIDER
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            width: 1.5,
            height: 52,
            color: const Color(0xFFC9CCDA),
          ),

          /// ═════════════════════════════════════════════════
          /// PHONE INPUT
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,

              keyboardType: TextInputType.phone,

              maxLength: 10,

              style: GoogleFonts.roboto(
                color: AppColors.darkBlue950,
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),

              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,

                hintText: 'Enter your mobile number',

                hintStyle: GoogleFonts.roboto(
                  color: AppColors.textTertiary,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),

                contentPadding: const EdgeInsets.only(
                  right: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}