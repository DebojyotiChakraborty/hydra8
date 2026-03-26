import 'package:flutter/material.dart';

class WaterBottle extends StatelessWidget {
  final double fillLevel; // 0.0 (empty) to 1.0 (full)
  final String assetPath;

  const WaterBottle({
    super.key,
    required this.fillLevel,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: fillLevel, end: fillLevel),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, animatedFill, child) {
        // Cap+neck is ~18% of the image; water only fills below that.
        const neckFraction = 0.18;
        final overlayFraction =
            neckFraction + (1.0 - neckFraction) * (1.0 - animatedFill);

        return SizedBox(
          width: 180,
          height: 380,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Bottle image
              Image.asset(
                assetPath,
                fit: BoxFit.contain,
              ),
              // Dark overlay on the unfilled portion (below the neck)
              ClipRect(
                clipper: _TopClipper(fraction: overlayFraction),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.55),
                    BlendMode.srcATop,
                  ),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Clips from the top down to [fraction] of the height.
class _TopClipper extends CustomClipper<Rect> {
  final double fraction;

  _TopClipper({required this.fraction});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width, size.height * fraction);
  }

  @override
  bool shouldReclip(covariant _TopClipper oldClipper) {
    return oldClipper.fraction != fraction;
  }
}
