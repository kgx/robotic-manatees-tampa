import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class ClassifiedCard extends StatefulWidget {
  final Widget child;
  final bool showStamp;
  final Color accentColor;

  const ClassifiedCard({
    super.key,
    required this.child,
    this.showStamp = false,
    this.accentColor = AppColors.bioTeal,
  });

  @override
  State<ClassifiedCard> createState() => _ClassifiedCardState();
}

class _ClassifiedCardState extends State<ClassifiedCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(color: widget.accentColor, width: 3),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: widget.child,
            ),
            if (widget.showStamp)
              Positioned(
                top: 12,
                right: 12,
                child: Transform.rotate(
                  angle: -0.2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.warningOrange.withValues(alpha: 0.4),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'CLASSIFIED',
                      style: GoogleFonts.orbitron(
                        fontSize: 10,
                        color: AppColors.warningOrange.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
