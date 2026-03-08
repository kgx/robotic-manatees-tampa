import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.abyssBlue,
        border: Border(top: BorderSide(color: AppColors.surfaceLight)),
      ),
      child: Column(
        children: [
          Text(
            'MANATEK MONITORING SYSTEM v2.0.26',
            style: GoogleFonts.shareTechMono(
              fontSize: 12,
              color: AppColors.manateeGray,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This is a satirical website. No real manatees were roboticized.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.manateeGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '© 2026 ManaTek Industries (Fictional Division)',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.manateeGray.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
