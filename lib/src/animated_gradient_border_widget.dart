library animated_gradient_border;

import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedGradientBorder extends StatefulWidget {
  /// The widget inside the border (e.g., a Button or Container).
  final Widget child;

  /// Thickness of the border line.
  final double borderWidth;

  /// Corner radius for the border.
  final double borderRadius;

  /// List of colors for the gradient loop.
  final List<Color> colors;

  /// How fast the gradient rotates (Seconds per full rotation).
  final Duration speed;

  /// How much the gradient "glows" outwards. Set to 0 to disable.
  final double? glowSigma;

  /// Controls the distribution of colors.
  /// For a white loop, try: [0.0, 0.5, 1.0]
  final List<double>? stops;

  const AnimatedGradientBorder({
    super.key,
    required this.child,
    this.borderWidth = 1.0,
    this.borderRadius = 0.0,
    this.speed = const Duration(seconds: 2),
    this.glowSigma,
    this.stops,
    this.colors = const [
      Colors.transparent,
      Colors.white,
      Colors.transparent,
    ],
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.speed,
    )..repeat();
  }

  @override
  void didUpdateWidget(AnimatedGradientBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speed != widget.speed) {
      _controller.duration = widget.speed;
      _controller.repeat();
    }
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
      builder: (context, child) => CustomPaint(
        painter: _GradientBorderPainter(
          animationValue: _controller.value,
          borderWidth: widget.borderWidth,
          borderRadius: widget.borderRadius,
          colors: widget.colors,
          stops: widget.stops,
          glowSigma: widget.glowSigma,
        ),
        child: Padding(
          padding: EdgeInsets.all(widget.borderWidth),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double animationValue;
  final double borderWidth;
  final double borderRadius;
  final List<Color> colors;
  final List<double>? stops;
  final double? glowSigma;

  _GradientBorderPainter({
    required this.animationValue,
    required this.borderWidth,
    required this.borderRadius,
    required this.colors,
    required this.stops,
    this.glowSigma,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: pi * 2,
      colors: colors,
      stops: stops,
      transform: GradientRotation(animationValue * pi * 2),
    );

    final shader = gradient.createShader(rect);

    // 1. Draw the Blur Glow (The "Under-layer")
    if (glowSigma != null && glowSigma! > 0) {
      final glowPaint = Paint()
        ..shader = shader
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth * 2 // Glow is slightly wider
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowSigma!);

      canvas.drawRRect(rRect, glowPaint);
    }

    // 2. Draw the Main Border (The "Sharp layer")
    final borderPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(rRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) {
    return true; // Repaint on every animation frame
  }
}
