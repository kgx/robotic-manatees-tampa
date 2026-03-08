import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class NewsTicker extends StatefulWidget {
  final List<String> headlines;
  const NewsTicker({super.key, required this.headlines});

  @override
  State<NewsTicker> createState() => _NewsTickerState();
}

class _NewsTickerState extends State<NewsTicker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late String _tickerText;

  @override
  void initState() {
    super.initState();
    _tickerText = widget.headlines.map((h) => '/// $h').join('    ');
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.headlines.length * 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: AppColors.warningOrange.withValues(alpha: 0.15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: AppColors.warningOrange,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              'ALERT',
              style: GoogleFonts.orbitron(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return ClipRect(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final textWidth = _tickerText.length * 8.0;
                      final totalWidth = textWidth + constraints.maxWidth;
                      final offset = constraints.maxWidth - (_controller.value * totalWidth);
                      return Transform.translate(
                        offset: Offset(offset, 0),
                        child: Text(
                          _tickerText,
                          maxLines: 1,
                          softWrap: false,
                          style: GoogleFonts.shareTechMono(
                            fontSize: 13,
                            color: AppColors.warningOrange,
                            letterSpacing: 1,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
