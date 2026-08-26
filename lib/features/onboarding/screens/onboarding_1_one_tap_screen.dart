import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_id/features/onboarding/widgets/onboarding_main_illustration.dart';
import 'package:tab_id/widgets/app_name.dart';

class Onboarding1OneTapScreen extends StatelessWidget {
  const Onboarding1OneTapScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;


            /// Responsive horizontal padding
            final horizontalPadding = (width * 0.07).clamp(
              20.0,
              80.0,
            );

            /// Limit content width on tablets / desktop
            final contentWidth = width > 700 ? 650.0 : width;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: contentWidth,
                ),
                child: Column(
                  children: [

                    /// ─────────────────────────────────────
                    /// MAIN CONTENT
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// ─────────────────────────────
                            /// TOP SPACING
                            SizedBox(height: (height * 0.035).clamp(20.0, 40.0,),),

                            /// ─────────────────────────────
                            /// HEADER
                            const _WelcomeHeader(),

                            /// ─────────────────────────────
                            /// SPACING
                            SizedBox(height: (height * 0.018).clamp(12.0, 22.0,),),

                            /// ─────────────────────────────
                            /// DESCRIPTION
                            Text(
                              'Share everything about you with just\n'
                                  'one tap.',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF626875),
                              ),
                            ),

                            /// ─────────────────────────────
                            /// SPACING
                            SizedBox(height: (height * 0.05).clamp(20.0, 45.0,),),

                            /// ─────────────────────────────
                            /// MAIN ILLUSTRATION
                            const OnboardingMainIllustration(
                              imagePath:
                              'assets/images/Onboarding/onboarding_1.png',
                            ),

                            /// ─────────────────────────────
                            /// SPACING
                            SizedBox(height: (height * 0.015).clamp(12.0, 24.0,),),

                            /// ─────────────────────────────
                            /// BOTTOM MESSAGE
                            Center(
                              child: Text(
                                'Your profile. Your way.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            /// ─────────────────────────────
                            /// BOTTOM MESSAGE
                            Center(
                              child: Text(
                                'Fast, easy, and feels like magic!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF626875),
                                ),
                              ),
                            ),

                            /// ─────────────────────────────
                            /// Spacing
                            SizedBox(height: (height * 0.04).clamp(18.0, 32.0,),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════
/// WELCOME HEADER
class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to',
          style: GoogleFonts.roboto(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/TabID_round.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),

            const AppName(
              splitColor: true,
              tapColor: Colors.black,
              fontSize: 45,
              fontWeight: FontWeight.w900,
            ),
          ],
        ),
      ],
    );
  }
}