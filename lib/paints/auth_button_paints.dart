import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// A [CustomPainter] that draws the premium crimson-filled geometric button.
///
/// The shape mirrors the text-field geometry for visual cohesion. The fill is
/// a crimson-to-dark-red horizontal gradient; the stroke is solid bright red.
///
/// [pressProgress] (0.0 – 1.0) darkens the fill on tap for tactile feedback.
/// [shimmerProgress] (0.0 – 1.0) drives a white sheen sweeping across the
/// button surface on hover / idle pulse.
class AuthButtonPainter extends CustomPainter {
  /// Press animation progress — darkens the gradient fill.
  final double pressProgress;

  /// Idle shimmer sweep progress across the button surface.
  final double shimmerProgress;

  const AuthButtonPainter({
    this.pressProgress = 0.0,
    this.shimmerProgress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ── Geometric path ──────────────────────────────────────────────────────
    final Path path = Path()
      ..moveTo(size.width * 0.9976415, size.height * 0.01219512)
      ..lineTo(size.width * 0.9976415, size.height * 0.8127854)
      ..lineTo(size.width * 0.9705660, size.height * 0.9878049)
      ..lineTo(size.width * 0.002358491, size.height * 0.9878049)
      ..lineTo(size.width * 0.002358491, size.height * 0.1030393)
      ..lineTo(size.width * 0.02212467, size.height * 0.01219512)
      ..close();

    // Save canvas so clip stays local
    canvas.save();
    canvas.clipPath(path);

    // ── Crimson gradient fill ────────────────────────────────────────────────
    final double darken = pressProgress * 0.35;
    final Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5),
        [
          Color.lerp(const Color(0xFF6A5CFF), Colors.black, darken)!
            ..withValues(alpha: 1),
          Color.lerp(const Color(0xFF3A3F9F), Colors.black, darken)!
              .withValues(alpha: 1),
        ],
        [0, 1],
      );
    canvas.drawPath(path, fillPaint);

    // ── Shimmer sheen sweep ──────────────────────────────────────────────────
    if (shimmerProgress > 0) {
      final double sheenX = size.width * (shimmerProgress * 1.6 - 0.3);
      final Paint sheenPaint = Paint()
        ..style = PaintingStyle.fill
        ..shader = ui.Gradient.linear(
          Offset(sheenX - size.width * 0.15, 0),
          Offset(sheenX + size.width * 0.15, size.height),
          [
            Colors.white.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0.0),
          ],
          [0, 0.5, 1],
        );
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        sheenPaint,
      );
    }

    // ── Top edge highlight (gives 3D lift) ──────────────────────────────────
    final Paint edgePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, size.height * 0.35),
        [
          Colors.white..withValues(alpha: 0.12),
          Colors.white..withValues(alpha: 0.0),
        ],
      );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.35),
      edgePaint,
    );

    canvas.restore();

    // ── Border stroke ────────────────────────────────────────────────────────
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Color.lerp(
        const ui.Color.fromARGB(255, 255, 254, 254),
        const ui.Color.fromARGB(255, 255, 255, 255),
        pressProgress,
      )!;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant AuthButtonPainter old) =>
      old.pressProgress != pressProgress ||
      old.shimmerProgress != shimmerProgress;
}
