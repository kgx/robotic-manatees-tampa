import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../data/defense_tips_data.dart';
import '../widgets/classified_card.dart';
import '../widgets/section_header.dart';
import '../widgets/footer.dart';

class DefensePage extends StatelessWidget {
  const DefensePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 3 : (screenWidth > 768 ? 2 : 1);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'CITIZEN DEFENSE',
            subtitle: 'OFFICIAL MANATEK PREPAREDNESS GUIDELINES',
          ),
          // Alert banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warningOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.warningOrange.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, color: AppColors.warningOrange, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'ADVISORY: Current manatee threat level is ELEVATED FRIENDLINESS. '
                    'Exercise caution. Do not engage without pool noodle.',
                    style: GoogleFonts.shareTechMono(
                      fontSize: 12,
                      color: AppColors.warningOrange,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: crossAxisCount == 1 ? 1.8 : 0.85,
              ),
              itemCount: defenseTips.length,
              itemBuilder: (context, index) {
                final tip = defenseTips[index];
                return ClassifiedCard(
                  accentColor: _severityColor(tip.severity),
                  child: _buildTipCard(tip),
                ).animate().fadeIn(
                      delay: Duration(milliseconds: 80 * index),
                      duration: 400.ms,
                    );
              },
            ),
          ),
          const SizedBox(height: 48),
          const AppFooter(),
        ],
      ),
    );
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'CRITICAL':
        return const Color(0xFFFF4444);
      case 'HIGH':
        return AppColors.warningOrange;
      case 'ABSOLUTE':
        return const Color(0xFFFF69B4);
      case 'EXISTENTIAL':
        return const Color(0xFF7B68EE);
      case 'ESSENTIAL':
        return AppColors.bioTeal;
      default:
        return AppColors.seaFoam;
    }
  }

  Widget _buildTipCard(DefenseTip tip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(tip.icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _severityColor(tip.severity).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tip.severity,
                  style: GoogleFonts.orbitron(
                    fontSize: 10,
                    color: _severityColor(tip.severity),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          tip.title,
          style: GoogleFonts.orbitron(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Text(
            tip.description,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.chromeSilver,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
