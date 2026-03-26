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
///
/// When the digit count changes, character slots smoothly expand or collapse
/// so adjacent content (e.g. a "ml" suffix) slides seamlessly.
class NumericTextTransition extends StatefulWidget {
  const NumericTextTransition({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOutCubic,
    this.prefix = '',
    this.suffix = '',
    this.formatter,
  });

  /// The numeric value to display.
  final int value;

  /// Text style for the digits.
  final TextStyle? style;

  /// Duration of the transition animation.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Optional prefix rendered before the number (e.g. "\$").
  final String prefix;

  /// Optional suffix rendered after the number (e.g. "ml").
  final String suffix;

  /// Optional custom formatter. When provided, this is used instead of the
  /// default comma-separated formatting.
  final String Function(int)? formatter;

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
    if (widget.formatter != null) return widget.formatter!(value);
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

  /// Measures the size of a single character rendered in [style].
  Size _measureChar(String ch, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: ch, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return Size(tp.width, tp.height);
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? DefaultTextStyle.of(context).style;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final progress = _animation.value;

        // Align characters from the right so ones/tens/hundreds match up.
        final oldLen = _oldText.length;
        final newLen = _newText.length;
        final maxLen = oldLen > newLen ? oldLen : newLen;

        final children = <Widget>[];

        // Prefix
        if (widget.prefix.isNotEmpty) {
          children.add(Text(widget.prefix, style: style));
        }

        for (int i = 0; i < maxLen; i++) {
          // Index into old/new strings, aligned from the right.
          final oldIdx = i - (maxLen - oldLen);
          final newIdx = i - (maxLen - newLen);
          final oldChar = oldIdx >= 0 ? _oldText[oldIdx] : null;
          final newChar = newIdx >= 0 ? _newText[newIdx] : null;

          if (oldChar == null && newChar != null) {
            // Character only in new text — appearing.
            children.add(_buildAppearingChar(newChar, progress, style));
          } else if (oldChar != null && newChar == null) {
            // Character only in old text — disappearing.
            children.add(_buildDisappearingChar(oldChar, progress, style));
          } else if (oldChar == newChar) {
            // Same character — static.
            children.add(Text(oldChar!, style: style));
          } else {
            // Different character — animated swap.
            children.add(
              _buildAnimatedDigit(oldChar!, newChar!, progress, style),
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

  /// A character slot expanding from zero width, with fade + slide in.
  Widget _buildAppearingChar(String char, double progress, TextStyle style) {
    final charSize = _measureChar(char, style);
    final fontSize = style.fontSize ?? 16.0;
    final slideDistance = fontSize * 0.6;
    final direction = _isIncreasing ? -1.0 : 1.0;

    return ClipRect(
      child: SizedBox(
        width: charSize.width * progress,
        height: charSize.height,
        child: OverflowBox(
          maxWidth: charSize.width,
          maxHeight: charSize.height,
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(0, -direction * slideDistance * (1.0 - progress)),
            child: Opacity(
              opacity: progress.clamp(0.0, 1.0),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 10.0 * (1.0 - progress),
                  sigmaY: 10.0 * (1.0 - progress),
                  tileMode: TileMode.decal,
                ),
                child: Text(char, style: style),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// A character slot collapsing to zero width, with fade + slide out.
  Widget _buildDisappearingChar(String char, double progress, TextStyle style) {
    final charSize = _measureChar(char, style);
    final fontSize = style.fontSize ?? 16.0;
    final slideDistance = fontSize * 0.6;
    final direction = _isIncreasing ? -1.0 : 1.0;

    return ClipRect(
      child: SizedBox(
        width: charSize.width * (1.0 - progress),
        height: charSize.height,
        child: OverflowBox(
          maxWidth: charSize.width,
          maxHeight: charSize.height,
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(0, direction * slideDistance * progress),
            child: Opacity(
              opacity: (1.0 - progress).clamp(0.0, 1.0),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 10.0 * progress,
                  sigmaY: 10.0 * progress,
                  tileMode: TileMode.decal,
                ),
                child: Text(char, style: style),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedDigit(
    String oldChar,
    String newChar,
    double progress,
    TextStyle style,
  ) {
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

    return _FixedWidthChar(
      style: style,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (oldOpacity > 0.0)
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
          if (newOpacity > 0.0)
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

    return SizedBox(width: maxWidth, height: maxHeight, child: child);
  }
}
