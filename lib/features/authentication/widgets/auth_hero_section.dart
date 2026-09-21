import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_id/widgets/app_name.dart';

import '../../../theme/app_colors.dart';

class AuthHeroSection extends StatelessWidget {
  const AuthHeroSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [

          /// BACKGROUND IMAGE
          AspectRatio(
            aspectRatio: 1024 / 588,
            child: Image.asset(
              'assets/images/authentication/hero_section_log_in.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),


          /// TAPID LOGO
          Positioned(
            right: 10,
            top: 70,
            child: Image.asset(
              'assets/images/TabID_round.png',
              width: size.width * 0.34,
              height: size.width * 0.34,
              fit: BoxFit.contain,
            ),
          ),

          /// TAPID TEXT
          Positioned(
            left: 30,
            top:50,
            child: const AppName(
              fontSize: 50,
              fontWeight: FontWeight.w900,
              splitColor: true,
            ),
          ),

          /// TAGLINE
          Positioned(
            left: 30,
            top:115,
            child: SizedBox(
              width: size.width * 0.52,
              child: Text(
                'One identity for a simpler,\n'
                    'safer digital you.',
                style: GoogleFonts.roboto(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
          ),

          /// FEATURE LIST
          Positioned(
            left: 30,
            top: 185,
            child: const _HeroFeatures(),
          ),
        ],
      ),
    );
  }
}

class _HeroFeatures extends StatelessWidget {
  const _HeroFeatures();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _HeroFeature(
          icon: Icons.shield_outlined,
          title: 'Secure',
        ),

        SizedBox(height: 8),

        _HeroFeature(
          icon: Icons.bolt_rounded,
          title: 'Fast',
        ),

        SizedBox(height: 8),

        _HeroFeature(
          icon: Icons.people_outline_rounded,
          title: 'Made for you',
        ),
      ],
    );
  }
}

class _HeroFeature extends StatelessWidget {
  const _HeroFeature({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Container(
          width: 35,
          height:35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white.withValues(
              alpha: 0.18,
            ),
            border: Border.all(
              color: AppColors.white.withValues(
                alpha: 0.25,
              ),
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 22,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: GoogleFonts.roboto(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}