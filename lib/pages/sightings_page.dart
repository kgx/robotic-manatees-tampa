import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../data/sightings_data.dart';
import '../widgets/classified_card.dart';
import '../widgets/section_header.dart';
import '../widgets/footer.dart';

class SightingsPage extends StatelessWidget {
  const SightingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'SIGHTING TRACKER',
            subtitle: 'CONFIRMED ENCOUNTERS — TAMPA BAY REGION',
          ),
          // Tampa Bay map placeholder
          _buildMapSection(isMobile),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'INCIDENT REPORTS',
              style: GoogleFonts.orbitron(
                fontSize: 16,
                color: AppColors.bioTeal,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...sightings.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: ClassifiedCard(
                showStamp: true,
                child: _buildSightingContent(entry.value),
              ).animate().fadeIn(
                    delay: Duration(milliseconds: 100 * entry.key),
                    duration: 400.ms,
                  ),
            );
          }),
          const SizedBox(height: 32),
          const AppFooter(),
        ],
      ),
    );
  }

  Widget _buildMapSection(bool isMobile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Stack(
        children: [
          // Grid lines for tactical feel
          CustomPaint(
            size: const Size(double.infinity, 300),
            painter: _GridPainter(),
          ),
          // Sighting markers
          ...sightings.asMap().entries.map((entry) {
            // Map coords to relative positions within the container
            final xFrac = ((entry.value.lng + 82.60) / 0.20).clamp(0.05, 0.95);
            final yFrac = ((entry.value.lat - 27.82) / 0.20).clamp(0.05, 0.95);
            return Positioned(
              left: xFrac * 100,
              top: (1 - yFrac) * 250 + 10,
              child: _SonarPing(label: entry.value.id),
            );
          }),
          // Label
          Positioned(
            bottom: 12,
            right: 12,
            child: Text(
              'TAMPA BAY — TACTICAL OVERLAY',
              style: GoogleFonts.shareTechMono(
                fontSize: 10,
                color: AppColors.manateeGray,
                letterSpacing: 2,
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.bioTeal.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'LIVE MONITORING',
                style: GoogleFonts.shareTechMono(
                  fontSize: 10,
                  color: AppColors.bioTeal,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSightingContent(Sighting sighting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.bioTeal.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                sighting.id,
                style: GoogleFonts.shareTechMono(
                  fontSize: 12,
                  color: AppColors.bioTeal,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                sighting.date,
                style: GoogleFonts.shareTechMono(
                  fontSize: 11,
                  color: AppColors.manateeGray,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          sighting.title,
          style: GoogleFonts.orbitron(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          sighting.location,
          style: GoogleFonts.shareTechMono(
            fontSize: 12,
            color: AppColors.bioTeal,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          sighting.description,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.chromeSilver,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.warningOrange.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'THREAT: ${sighting.threatLevel}',
            style: GoogleFonts.shareTechMono(
              fontSize: 11,
              color: AppColors.warningOrange,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.surfaceLight.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;

    for (var i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i.toDouble(), 0), Offset(i.toDouble(), size.height), paint);
    }
    for (var i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SonarPing extends StatefulWidget {
  final String label;
  const _SonarPing({required this.label});

  @override
  State<_SonarPing> createState() => _SonarPingState();
}

class _SonarPingState extends State<_SonarPing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 40 + (_controller.value * 20),
                height: 40 + (_controller.value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.bioTeal.withValues(alpha: 1 - _controller.value),
                    width: 1,
                  ),
                ),
              );
            },
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bioTeal,
              boxShadow: [
                BoxShadow(color: AppColors.bioTeal, blurRadius: 6, spreadRadius: 1),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Text(
              widget.label,
              style: GoogleFonts.shareTechMono(
                fontSize: 8,
                color: AppColors.bioTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
