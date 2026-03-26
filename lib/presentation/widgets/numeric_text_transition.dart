import 'dart:ui';
import 'package:flutter/material.dart';

/// A widget that animates between numeric values with per-digit slide, blur,
/// and fade transitions — closely matching SwiftUI's
/// `.contentTransition(.numericText())` behavior.
///
/// Digits that remain the same between old and new values stay in place.
/// Changed digits slide out in one direction and new ones slide in from the
/// opposite direction. The slide direction is determined by whether the value
/// increased or decreased.
class NumericTextTransition extends StatefulWidget {
  const NumericTextTransition({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOutCubic,
    this.prefix = '',
    this.suffix = '',
  });

  /// The numeric value to display.
  final int value;

  /// Text style for the digits.
  final TextStyle? style;

  /// Duration of the transition animation.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Optional prefix rendered before the number (e.g. "$").
  final String prefix;

  /// Optional suffix rendered after the number (e.g. "ml").
  final String suffix;

  @override
  State<NumericTextTransition> createState() => _NumericTextTransitionState();
}

class _NumericTextTransitionState extends State<NumericTextTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late String _oldText;
  late String _newText;
  bool _isIncreasing = true;

  @override
  void initState() {
    super.initState();
    _oldText = _format(widget.value);
    _newText = _oldText;

    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
  }

  String _format(int value) {
    // Simple comma formatting to match formatMl behavior
    final str = value.toString();
    final buffer = StringBuffer();
    final len = str.length;
    for (int i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  @override
  void didUpdateWidget(NumericTextTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _oldText = _format(oldWidget.value);
      _newText = _format(widget.value);
      _isIncreasing = widget.value > oldWidget.value;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? DefaultTextStyle.of(context).style;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final progress = _animation.value;

        // Pad the shorter string on the left so digit positions align from the
        // right (ones, tens, hundreds, …).
        final maxLen =
            _oldText.length > _newText.length
                ? _oldText.length
                : _newText.length;
        final oldPadded = _oldText.padLeft(maxLen);
        final newPadded = _newText.padLeft(maxLen);

        final children = <Widget>[];

        // Prefix
        if (widget.prefix.isNotEmpty) {
          children.add(Text(widget.prefix, style: style));
        }

        for (int i = 0; i < maxLen; i++) {
          final oldChar = oldPadded[i];
          final newChar = newPadded[i];

          if (oldChar == newChar) {
            // Unchanged digit — render static.
            // Skip leading padding spaces that appear when lengths differ.
            if (oldChar == ' ' && progress >= 1.0) continue;
            if (oldChar == ' ') {
              // Fading out leading space
              children.add(
                _buildStaticChar(oldChar, style, 1.0 - progress),
              );
            } else {
              children.add(Text(oldChar, style: style));
            }
          } else {
            children.add(
              _buildAnimatedDigit(
                oldChar,
                newChar,
                progress,
                style,
              ),
            );
          }
        }

        // Suffix
        if (widget.suffix.isNotEmpty) {
          children.add(Text(widget.suffix, style: style));
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: children,
        );
      },
    );
  }

  Widget _buildStaticChar(String char, TextStyle style, double opacity) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Text(char, style: style),
    );
  }

  Widget _buildAnimatedDigit(
    String oldChar,
    String newChar,
    double progress,
    TextStyle style,
  ) {
    // The height of one digit, used for the slide distance.
    final fontSize = style.fontSize ?? 16.0;
    final slideDistance = fontSize * 0.6;
    final direction = _isIncreasing ? -1.0 : 1.0;

    // Old digit: slides out
    final oldOpacity = (1.0 - progress).clamp(0.0, 1.0);
    final oldSlide = direction * slideDistance * progress;
    final oldBlur = 10.0 * progress;

    // New digit: slides in
    final newOpacity = progress.clamp(0.0, 1.0);
    final newSlide = -direction * slideDistance * (1.0 - progress);
    final newBlur = 10.0 * (1.0 - progress);

    // Use a stack to overlay old and new digits in the same space.
    // We need a fixed-width container so digits don't jump.
    return _FixedWidthChar(
      style: style,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Old character sliding out
          if (oldOpacity > 0.0 && oldChar != ' ')
            Transform.translate(
              offset: Offset(0, oldSlide),
              child: Opacity(
                opacity: oldOpacity,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: oldBlur,
                    sigmaY: oldBlur,
                    tileMode: TileMode.decal,
                  ),
                  child: Text(oldChar, style: style),
                ),
              ),
            ),
          // New character sliding in
          if (newOpacity > 0.0 && newChar != ' ')
            Transform.translate(
              offset: Offset(0, newSlide),
              child: Opacity(
                opacity: newOpacity,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: newBlur,
                    sigmaY: newBlur,
                    tileMode: TileMode.decal,
                  ),
                  child: Text(newChar, style: style),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Wraps a child in a container sized to the widest single digit (0-9)
/// so that animated digit swaps don't cause layout shifts.
class _FixedWidthChar extends StatelessWidget {
  const _FixedWidthChar({required this.style, required this.child});

  final TextStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Measure the widest digit to keep consistent sizing.
    // '0' is typically the widest in most fonts but we check a few.
    double maxWidth = 0;
    double maxHeight = 0;
    for (final ch in ['0', '8', ',']) {
      final tp = TextPainter(
        text: TextSpan(text: ch, style: style),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      if (tp.width > maxWidth) maxWidth = tp.width;
      if (tp.height > maxHeight) maxHeight = tp.height;
    }

    return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: child,
    );
  }
}
