import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';

class SecurityInfoCard extends StatelessWidget {
  const SecurityInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.purple50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [

          /// ═══════════════════════════════════════════════
          /// LOCK ICON
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryPurple.withValues(
                alpha: 0.10,
              ),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.primaryPurple1,
              size: 32,
            ),
          ),

          const SizedBox(width: 20),

          /// ═══════════════════════════════════════════════
          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  'Your number is safe with us.',
                  style: GoogleFonts.roboto(
                    color: AppColors.darkBlue950,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'We use it only for verification.',
                  style: GoogleFonts.roboto(
                    color: AppColors.textSecondary,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}