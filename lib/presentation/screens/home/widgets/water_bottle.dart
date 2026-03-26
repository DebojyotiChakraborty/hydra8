import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class WaterBottle extends StatelessWidget {
  final double fillLevel; // 0.0 (empty) to 1.0 (full)

  const WaterBottle({super.key, required this.fillLevel});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: fillLevel, end: fillLevel),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, animatedFill, _) {
        return CustomPaint(
          painter: _BottlePainter(fillLevel: animatedFill),
          size: const Size(140, 300),
        );
      },
    );
  }
}

class _BottlePainter extends CustomPainter {
  final double fillLevel;

  _BottlePainter({required this.fillLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Bottle dimensions
    final neckWidth = w * 0.35;
    final neckHeight = h * 0.12;
    final capHeight = h * 0.05;
    final bodyTop = capHeight + neckHeight;
    final bodyRadius = 16.0;
    final neckX = (w - neckWidth) / 2;

    // Cap
    final capPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;
    final capRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(neckX - 4, 0, neckWidth + 8, capHeight),
      const Radius.circular(6),
    );
    canvas.drawRRect(capRect, capPaint);

    // Bottle outline path (neck + body)
    final bottlePath = Path();
    // Neck
    bottlePath.moveTo(neckX, capHeight);
    bottlePath.lineTo(neckX, bodyTop);
    // Left shoulder curve
    bottlePath.quadraticBezierTo(0, bodyTop + 20, 0, bodyTop + 40);
    // Left body
    bottlePath.lineTo(0, h - bodyRadius);
    // Bottom left curve
    bottlePath.quadraticBezierTo(0, h, bodyRadius, h);
    // Bottom
    bottlePath.lineTo(w - bodyRadius, h);
    // Bottom right curve
    bottlePath.quadraticBezierTo(w, h, w, h - bodyRadius);
    // Right body
    bottlePath.lineTo(w, bodyTop + 40);
    // Right shoulder curve
    bottlePath.quadraticBezierTo(w, bodyTop + 20, neckX + neckWidth, bodyTop);
    // Right neck
    bottlePath.lineTo(neckX + neckWidth, capHeight);
    bottlePath.close();

    // Bottle background (semi-transparent)
    final bottleBgPaint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawPath(bottlePath, bottleBgPaint);

    // Water fill
    if (fillLevel > 0) {
      canvas.save();
      canvas.clipPath(bottlePath);

      final fillableTop = bodyTop + 40;
      final fillableHeight = h - fillableTop;
      final waterTop = h - (fillableHeight * fillLevel);

      // Wave effect at water surface
      final wavePaint = Paint()
        ..color = AppColors.waterBlue.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill;

      final waterPath = Path();
      waterPath.moveTo(0, waterTop);

      // Simple sine wave
      for (double x = 0; x <= w; x++) {
        final y = waterTop + sin(x * 0.04) * 4;
        waterPath.lineTo(x, y);
      }
      waterPath.lineTo(w, h);
      waterPath.lineTo(0, h);
      waterPath.close();

      canvas.drawPath(waterPath, wavePaint);

      // Lighter overlay at the top of water
      final surfacePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.white.withValues(alpha: 0.15),
            AppColors.white.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, waterTop, w, 30));
      canvas.drawRect(Rect.fromLTWH(0, waterTop, w, 30), surfacePaint);

      canvas.restore();
    }

    // Bottle outline stroke
    final outlinePaint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(bottlePath, outlinePaint);

    // Label on bottle
    final labelPaint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    final labelRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w / 2, h * 0.55),
        width: w * 0.5,
        height: 24,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(labelRect, labelPaint);

    // Drop icon on label
    final dropPath = Path();
    final cx = w / 2 - 16;
    final cy = h * 0.55;
    dropPath.moveTo(cx, cy - 6);
    dropPath.quadraticBezierTo(cx - 5, cy + 2, cx, cy + 6);
    dropPath.quadraticBezierTo(cx + 5, cy + 2, cx, cy - 6);
    final dropPaint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawPath(dropPath, dropPaint);
  }

  @override
  bool shouldRepaint(covariant _BottlePainter oldDelegate) {
    return oldDelegate.fillLevel != fillLevel;
  }
}
