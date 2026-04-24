import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';

/// A [CustomPainter] that draws the geometric, crimson-bordered background
/// for [CrimsonEmailField] and [CrimsonPasswordField].
///
/// The shape has clipped corners (top-left and bottom-right bevels) giving it
/// a futuristic, angular aesthetic. The border uses a red gradient stroke and
/// the fill is pure black.
///
/// [glowProgress] (0.0 – 1.0) animates a traveling highlight along the border
/// when the field is focused.
class AuthTextFormFieldPainter extends CustomPainter {
  /// Focus animation progress — drives the glowing shimmer on the border.
  final double glowProgress;

  /// Whether the field is currently focused.
  final bool isFocused;

  const AuthTextFormFieldPainter({
    this.glowProgress = 0.0,
    this.isFocused = false,
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

    // ── Fill — deep black ────────────────────────────────────────────────────
    // final Paint fillPaint = Paint()
      // ..style = PaintingStyle.fill
      // ..color = const ui.Color.fromARGB(255, 195, 23, 23);
    // canvas.drawPath(path, fillPaint);

    // ── Inner dark glow layer ────────────────────────────────────────────────
    final Paint innerGlowPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.radial(
        Offset(size.width * 0.3, size.height * 0.5),
        size.width * 0.6,
        [
          const Color(0xFF1A0000)..withValues(alpha:0.8),
          const Color(0xFF000000)..withValues(alpha:0.0),
        ],
      );
    canvas.drawPath(path, innerGlowPaint);

    // ── Base border gradient stroke ──────────────────────────────────────────
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isFocused ? 2.2 : 1.5
      ..shader = ui.Gradient.linear(
        Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5),
        [
          const ui.Color.fromARGB(255, 255, 255, 255)..withValues(alpha:isFocused ? 1.0 : 0.6),
          const ui.Color.fromARGB(255, 254, 254, 254)..withValues(alpha:isFocused ? 1.0 : 0.6),
        ],
        [0, 1],
      );
    canvas.drawPath(path, borderPaint);

    // ── Traveling shimmer highlight (only when focused) ──────────────────────
    if (isFocused) {
      final PathMetric metric = path.computeMetrics().first;
      final double totalLength = metric.length;
      final double shimmerLen = totalLength * 0.25;
      final double start =
          (glowProgress * totalLength - shimmerLen / 2) % totalLength;
      final double end = (start + shimmerLen) % totalLength;

      Path shimmerPath;
      if (end > start) {
        shimmerPath = metric.extractPath(start, end);
      } else {
        // Wraps around
        final Path p1 = metric.extractPath(start, totalLength);
        final Path p2 = metric.extractPath(0, end);
        shimmerPath = Path()
          ..addPath(p1, Offset.zero)
          ..addPath(p2, Offset.zero);
      }

      final Paint shimmerPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.linear(
          Offset(0, size.height * 0.5),
          Offset(size.width, size.height * 0.5),
          [
            Colors.white..withValues(alpha:0.0),
            Colors.white..withValues(alpha:0.9),
            const ui.Color.fromARGB(255, 255, 255, 255)..withValues(alpha:0.8),
            Colors.white..withValues(alpha:0.0),
          ],
          [0.0, 0.4, 0.6, 1.0],
        );
      canvas.drawPath(shimmerPath, shimmerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant AuthTextFormFieldPainter old) =>
      old.glowProgress != glowProgress || old.isFocused != isFocused;
}