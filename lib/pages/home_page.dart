import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_waves.dart';
import '../widgets/news_ticker.dart';
import '../widgets/footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return SingleChildScrollView(
      child: Column(
        children: [
          NewsTicker(headlines: const [
            'ROBOTIC MANATEES SPOTTED IN TAMPA BAY — AUTHORITIES MONITORING',
            'MAYOR: "HONESTLY KIND OF CUTE"',
            'MANATEK EMBASSY ESTABLISHED ON DAVIS ISLANDS',
            'DJ DUGONG CITED FOR NOISE VIOLATION — REFUSES TO TURN DOWN',
            'POOL NOODLES NOW CLASSIFIED AS STRATEGIC DEFENSE EQUIPMENT',
          ]),
          _buildHeroSection(context, isMobile),
          const AnimatedWaves(height: 80),
          _buildQuickLinks(context, isMobile),
          _buildStatusBoard(context, isMobile),
          const AnimatedWaves(height: 60, color: AppColors.seaFoam),
          const AppFooter(),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.abyssBlue,
            AppColors.deepOcean,
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            '⚙️',
            style: TextStyle(fontSize: isMobile ? 60 : 80),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.0, 1.0)),
          const SizedBox(height: 24),
          Text(
            'THEY CAME FROM\nTHE DEEP.',
            textAlign: TextAlign.center,
            style: GoogleFonts.orbitron(
              fontSize: isMobile ? 32 : 56,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 3,
              height: 1.2,
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideY(begin: 0.3, end: 0),
          const SizedBox(height: 16),
          Text(
            'THEY ARE POLITE. THEY ARE CHROME.',
            textAlign: TextAlign.center,
            style: GoogleFonts.orbitron(
              fontSize: isMobile ? 14 : 20,
              fontWeight: FontWeight.w400,
              color: AppColors.bioTeal,
              letterSpacing: 4,
            ),
          ).animate().fadeIn(delay: 700.ms, duration: 600.ms),
          const SizedBox(height: 32),
          Text(
            'Tampa Bay is experiencing an unprecedented influx of robotic manatees.\nTheir origin is unknown. Their intentions appear... friendly.\nThis site serves as your official monitoring resource.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 14 : 16,
              color: AppColors.chromeSilver,
              height: 1.8,
            ),
          ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),
          const SizedBox(height: 40),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.go('/sightings'),
                child: const Text('VIEW SIGHTINGS'),
              ),
              OutlinedButton(
                onPressed: () => context.go('/field-guide'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.bioTeal),
                  foregroundColor: AppColors.bioTeal,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  textStyle: GoogleFonts.orbitron(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                child: const Text('FIELD GUIDE'),
              ),
            ],
          ).animate().fadeIn(delay: 1300.ms, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildQuickLinks(BuildContext context, bool isMobile) {
    final links = [
      _QuickLink('SIGHTINGS', 'Track confirmed encounters', Icons.location_on, '/sightings'),
      _QuickLink('FIELD GUIDE', 'Know your manatee models', Icons.menu_book, '/field-guide'),
      _QuickLink('BREAKING NEWS', 'Latest developments', Icons.newspaper, '/news'),
      _QuickLink('CITIZEN DEFENSE', 'Stay prepared', Icons.shield, '/defense'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: links.map((link) {
          return SizedBox(
            width: isMobile ? double.infinity : 260,
            child: _QuickLinkCard(link: link),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusBoard(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 48,
      ),
      color: AppColors.abyssBlue.withValues(alpha: 0.5),
      child: Column(
        children: [
          Text(
            'CURRENT STATUS',
            style: GoogleFonts.orbitron(
              fontSize: 18,
              color: AppColors.bioTeal,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 32,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _StatusItem(label: 'CONFIRMED UNITS', value: '23', color: AppColors.bioTeal),
              _StatusItem(label: 'THREAT LEVEL', value: 'VIBES', color: AppColors.seaFoam),
              _StatusItem(label: 'INCIDENTS TODAY', value: '4', color: AppColors.warningOrange),
              _StatusItem(label: 'MOOD', value: 'CHILL', color: AppColors.bioTeal),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickLink {
  final String title;
  final String subtitle;
  final IconData icon;
  final String path;
  const _QuickLink(this.title, this.subtitle, this.icon, this.path);
}

class _QuickLinkCard extends StatefulWidget {
  final _QuickLink link;
  const _QuickLinkCard({required this.link});

  @override
  State<_QuickLinkCard> createState() => _QuickLinkCardState();
}

class _QuickLinkCardState extends State<_QuickLinkCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.link.path),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? AppColors.bioTeal : AppColors.surfaceLight,
            ),
            boxShadow: _hovered
                ? [BoxShadow(color: AppColors.bioTeal.withValues(alpha: 0.1), blurRadius: 16)]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(widget.link.icon, color: AppColors.bioTeal, size: 28),
              const SizedBox(height: 12),
              Text(
                widget.link.title,
                style: GoogleFonts.orbitron(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.link.subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.manateeGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatusItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.shareTechMono(
            fontSize: 11,
            color: AppColors.manateeGray,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
