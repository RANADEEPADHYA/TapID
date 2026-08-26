import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_id/features/onboarding/widgets/onboarding_main_illustration.dart';

class Onboarding2NfcScreen extends StatelessWidget {
  const Onboarding2NfcScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF9),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            /// ─────────────────────────────────────────────
            /// Responsive horizontal padding
            final horizontalPadding = (width * 0.07).clamp(
              20.0,
              80.0,
            );

            /// ─────────────────────────────────────────────
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
                            const _OnboardingHeader(),

                            /// ─────────────────────────────
                            /// SPACING
                            SizedBox(height: (height * 0.018).clamp(12.0, 22.0,),),

                            /// ─────────────────────────────
                            /// DESCRIPTION
                            Text(
                              'Share your info instantly via NFC or QR code.\n'
                                  'No apps, no hassle.',
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
                              'assets/images/Onboarding/onboarding_2.png',
                            ),

                            /// ─────────────────────────────
                            /// SPACING
                            SizedBox(height: (height * 0.015).clamp(12.0, 24.0,),),

                            /// ─────────────────────────────
                            /// BOTTOM MESSAGE
                            Center(
                              child: Text(
                                'Smart sharing for a smarter you.',
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
                                'Built for speed. Designed for trust.',
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
/// HEADER
class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'One tap.',
          style: GoogleFonts.roboto(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
          ),
        ),
        Text(
          'Endless Connections.',
          style: GoogleFonts.lobsterTwo(
            fontSize: 45,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF7051F5),
          ),
        ),
      ],
    );
  }
}