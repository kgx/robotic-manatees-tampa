import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class GeorgeJetAlert extends StatefulWidget {
  const GeorgeJetAlert({super.key});

  @override
  State<GeorgeJetAlert> createState() => _GeorgeJetAlertState();
}

class _GeorgeJetAlertState extends State<GeorgeJetAlert> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8B0000),
            const Color(0xFF660000),
            const Color(0xFF8B0000),
          ],
        ),
        border: const Border(
          top: BorderSide(color: Color(0xFFFF0000), width: 2),
          bottom: BorderSide(color: Color(0xFFFF0000), width: 2),
        ),
      ),
      child: Column(
        children: [
          // Flashing header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: const Color(0xFFFF0000).withValues(alpha: 0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning, color: Colors.yellow, size: 20)
                    .animate(onPlay: (c) => c.repeat())
                    .fadeIn(duration: 500.ms)
                    .then()
                    .fadeOut(duration: 500.ms),
                const SizedBox(width: 8),
                Text(
                  '⚠️ SPECIAL ALERT — ROGUE UNITS DETECTED ⚠️',
                  style: GoogleFonts.orbitron(
                    fontSize: isMobile ? 11 : 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.yellow,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.warning, color: Colors.yellow, size: 20)
                    .animate(onPlay: (c) => c.repeat())
                    .fadeIn(duration: 500.ms)
                    .then()
                    .fadeOut(duration: 500.ms),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RogueUnitBadge(
                      name: 'GEORGE',
                      description: 'Chrome finish, suspicious dents,\nbumper sticker: "NO RULES JUST CHROME"',
                      color: const Color(0xFFFF4444),
                      icon: '🦛',
                    ),
                    SizedBox(width: isMobile ? 12 : 32),
                    _RogueUnitBadge(
                      name: 'JET',
                      description: 'Matte black finish, red eye sensors,\npainted leather jacket on chassis',
                      color: const Color(0xFFFF6600),
                      icon: '🦛',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFF0000).withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'THESE UNITS ARE NOT AFFILIATED WITH MANATEK',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.orbitron(
                          fontSize: isMobile ? 10 : 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFF4444),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'George and Jet are rogue robotic manatees operating outside ManaTek protocols. '
                        'They have been responsible for: ice cream truck theft, wedding destruction, '
                        'infrastructure damage, ecological jailbreaks, underground racing, '
                        'billboard hijacking, and general mayhem. '
                        'They are considered armed (with bad attitudes) and extremely impolite.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'IF SPOTTED: Do not approach. Do not offer chrome polish. '
                        'Do not accept race invitations. Report to ManaTek Hotline: 1-800-BAD-MANA',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.shareTechMono(
                          fontSize: isMobile ? 11 : 13,
                          color: Colors.yellow,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => setState(() => _dismissed = true),
                  icon: const Icon(Icons.close, color: Colors.white54, size: 16),
                  label: Text(
                    'ACKNOWLEDGE ALERT',
                    style: GoogleFonts.shareTechMono(
                      fontSize: 11,
                      color: Colors.white54,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().shimmer(duration: 2000.ms, color: const Color(0xFFFF0000).withValues(alpha: 0.1));
  }
}

class _RogueUnitBadge extends StatelessWidget {
  final String name;
  final String description;
  final Color color;
  final String icon;

  const _RogueUnitBadge({
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      width: isMobile ? 140 : 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 4),
          Text(
            name,
            style: GoogleFonts.orbitron(
              fontSize: isMobile ? 16 : 20,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'WANTED',
              style: GoogleFonts.orbitron(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 3,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.shareTechMono(
              fontSize: isMobile ? 8 : 10,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
