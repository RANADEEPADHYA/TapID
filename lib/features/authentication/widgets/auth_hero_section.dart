import 'package:flutter/material.dart';

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
        children: [

          /// ═══════════════════════════════════════════════════
          /// BASE GRADIENT
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.primaryBlue,
                  AppColors.primaryPurple,
                  AppColors.darkBlue900,
                ],
                stops: [
                  0.0,
                  0.30,
                  0.68,
                  1.0,
                ],
              ),
            ),
          ),

          /// ═══════════════════════════════════════════════════
          /// LIGHT GLOW — TOP LEFT
          Positioned(
            left: -size.width * 0.35,
            top: -size.width * 0.35,
            child: Container(
              width: size.width * 0.80,
              height: size.width * 0.80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.purple400.withValues(
                  alpha: 0.55,
                ),
              ),
            ),
          ),

          /// ═══════════════════════════════════════════════════
          /// BLUE GLOW
          Positioned(
            right: -size.width * 0.25,
            top: size.height * 0.10,
            child: Container(
              width: size.width * 0.75,
              height: size.width * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.skyBlue.withValues(
                  alpha: 0.28,
                ),
              ),
            ),
          ),

          /// ═══════════════════════════════════════════════════
          /// BOTTOM LIGHT AREA
          Positioned(
            left: -size.width * 0.15,
            bottom: -size.width * 0.65,
            child: Container(
              width: size.width * 1.25,
              height: size.width * 1.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(
                  alpha: 0.35,
                ),
              ),
            ),
          ),

          /// ═══════════════════════════════════════════════════
          /// TAPID LOGO
          Positioned(
            right: size.width * 0.13,
            top: size.height * 0.135,
            child: Image.asset(
              'assets/images/TabID_round.png',
              width: size.width * 0.34,
              height: size.width * 0.34,
              fit: BoxFit.contain,
            ),
          ),

          /// ═══════════════════════════════════════════════════
          /// TAPID TEXT
          Positioned(
            left: size.width * 0.08,
            top: size.height * 0.145,
            child: RichText(
              text: const TextSpan(
                children: [

                  TextSpan(
                    text: 'Tap',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2,
                    ),
                  ),

                  TextSpan(
                    text: 'I',
                    style: TextStyle(
                      color: AppColors.brandPink,
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2,
                    ),
                  ),

                  TextSpan(
                    text: 'D',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ═══════════════════════════════════════════════════
          /// TAGLINE
          Positioned(
            left: size.width * 0.085,
            top: size.height * 0.255,
            child: SizedBox(
              width: size.width * 0.52,
              child: const Text(
                'One identity for a simpler,\n'
                    'safer digital you.',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
          ),

          /// ═══════════════════════════════════════════════════
          /// FEATURE LIST
          Positioned(
            left: size.width * 0.085,
            bottom: size.height * 0.065,
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

        SizedBox(height: 13),

        _HeroFeature(
          icon: Icons.bolt_rounded,
          title: 'Fast',
        ),

        SizedBox(height: 13),

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
          width: 43,
          height: 43,
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
            size: 24,
          ),
        ),

        const SizedBox(width: 16),

        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}