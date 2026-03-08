import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../data/field_guide_data.dart';
import '../widgets/classified_card.dart';
import '../widgets/section_header.dart';
import '../widgets/footer.dart';

class FieldGuidePage extends StatelessWidget {
  const FieldGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 3 : (screenWidth > 768 ? 2 : 1);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'FIELD GUIDE',
            subtitle: 'KNOWN ROBOTIC MANATEE DESIGNATIONS',
          ),
          // Rogue Units Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFF4444).withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.dangerous, color: Color(0xFFFF4444), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '⚠️ ROGUE UNITS — DO NOT APPROACH',
                        style: GoogleFonts.orbitron(
                          fontSize: 14,
                          color: const Color(0xFFFF4444),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'These units are NOT affiliated with ManaTek and operate outside all protocols.',
                    style: GoogleFonts.shareTechMono(
                      fontSize: 11,
                      color: AppColors.chromeSilver,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: crossAxisCount == 1 ? 1.2 : 0.65,
              ),
              itemCount: rogueUnits.length,
              itemBuilder: (context, index) {
                final unit = rogueUnits[index];
                return ClassifiedCard(
                  accentColor: const Color(0xFFFF4444),
                  showStamp: true,
                  child: _buildUnitCard(unit, index, isRogue: true),
                ).animate().fadeIn(
                      delay: Duration(milliseconds: 100 * index),
                      duration: 400.ms,
                    );
              },
            ),
          ),
          const SizedBox(height: 32),
          // Regular units
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Text(
              'STANDARD MANATEK UNITS',
              style: GoogleFonts.orbitron(
                fontSize: 16,
                color: AppColors.bioTeal,
                letterSpacing: 2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: crossAxisCount == 1 ? 1.2 : 0.65,
              ),
              itemCount: manateeUnits.length,
              itemBuilder: (context, index) {
                final unit = manateeUnits[index];
                return ClassifiedCard(
                  accentColor: _unitColor(index),
                  child: _buildUnitCard(unit, index),
                ).animate().fadeIn(
                      delay: Duration(milliseconds: 100 * index),
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

  Color _unitColor(int index) {
    const colors = [
      AppColors.bioTeal,
      AppColors.seaFoam,
      AppColors.warningOrange,
      Color(0xFF7B68EE),
      Color(0xFFFF69B4),
      Color(0xFFFFD700),
    ];
    return colors[index % colors.length];
  }

  Widget _buildUnitCard(ManateeUnit unit, int index, {bool isRogue = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (isRogue ? const Color(0xFFFF4444) : _unitColor(index)).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                unit.designation,
                style: GoogleFonts.shareTechMono(
                  fontSize: 11,
                  color: isRogue ? const Color(0xFFFF4444) : _unitColor(index),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          unit.name,
          style: GoogleFonts.orbitron(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          unit.description,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.chromeSilver,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        _StatRow('POWER', unit.powerSource),
        _StatRow('SPEED', unit.topSpeed),
        _StatRow('WEIGHT', unit.weight),
        _StatRow('ABILITY', unit.specialAbility),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.warningOrange.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'THREAT: ${unit.threatLevel}',
            style: GoogleFonts.shareTechMono(
              fontSize: 10,
              color: AppColors.warningOrange,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '"${unit.personality}"',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.manateeGray,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: GoogleFonts.shareTechMono(
                fontSize: 10,
                color: AppColors.manateeGray,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.shareTechMono(
                fontSize: 11,
                color: AppColors.chromeSilver,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
