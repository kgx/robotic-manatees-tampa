import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AnimatedWaves extends StatefulWidget {
  final double height;
  final Color? color;
  const AnimatedWaves({super.key, this.height = 100, this.color});

  @override
  State<AnimatedWaves> createState() => _AnimatedWavesState();
}

class _AnimatedWavesState extends State<AnimatedWaves> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(double.infinity, widget.height),
          painter: _WavePainter(
            animationValue: _controller.value,
            color: widget.color ?? AppColors.bioTeal.withValues(alpha: 0.3),
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _WavePainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Draw three wave layers
    for (var i = 0; i < 3; i++) {
      final opacity = 0.15 + (i * 0.1);
      paint.color = color.withValues(alpha: opacity);
      final path = Path();
      path.moveTo(0, size.height);

      final offset = animationValue * 2 * pi + (i * 0.8);
      final amplitude = 12.0 + (i * 6);
      final frequency = 0.008 + (i * 0.002);

      for (var x = 0.0; x <= size.width; x++) {
        final y = size.height * 0.5 +
            sin(x * frequency + offset) * amplitude +
            cos(x * frequency * 0.5 + offset * 1.5) * (amplitude * 0.5);
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
