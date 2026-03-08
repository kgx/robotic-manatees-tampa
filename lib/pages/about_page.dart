import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/section_header.dart';
import '../widgets/footer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'ABOUT',
            subtitle: 'MANATEK MONITORING SYSTEM — PROJECT INFORMATION',
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(
                  title: 'WHAT IS THIS?',
                  body: 'This is a satirical website about a fictional invasion of robotic manatees '
                      'in Tampa Bay, Florida. It was built as a fun demonstration of Flutter web '
                      'development and is not affiliated with any real organization, government agency, '
                      'or robotic manatee manufacturer (that we know of).',
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 24),
                _buildInfoCard(
                  title: 'DISCLAIMER',
                  body: 'No real manatees were roboticized in the making of this website. '
                      'Manatees are gentle, endangered marine mammals protected under the Marine Mammal '
                      'Protection Act and the Endangered Species Act. If you see a real manatee in '
                      'distress, contact the FWC Wildlife Alert Hotline.\n\n'
                      'The robotic ones, however, are on their own.',
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                const SizedBox(height: 24),
                _buildInfoCard(
                  title: 'BUILT WITH',
                  body: 'Flutter Web • Dart • go_router • google_fonts • flutter_animate\n'
                      'Deployed on GitHub Pages\n'
                      'Designed with a nautical sci-fi aesthetic because why not.',
                ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                const SizedBox(height: 24),
                _buildInfoCard(
                  title: 'CREDITS',
                  body: 'Created by a human with the help of AI.\n'
                      'Inspired by Florida being Florida.\n'
                      'Dedicated to the real manatees of Tampa Bay — keep being awesome.',
                ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
                const SizedBox(height: 48),
                Center(
                  child: Text(
                    '— END TRANSMISSION —',
                    style: GoogleFonts.orbitron(
                      fontSize: 14,
                      color: AppColors.manateeGray,
                      letterSpacing: 4,
                    ),
                  ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const AppFooter(),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String body}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: AppColors.bioTeal, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.orbitron(
              fontSize: 16,
              color: AppColors.bioTeal,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.chromeSilver,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
