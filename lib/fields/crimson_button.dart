import 'package:flutter/material.dart';
import 'package:yir_login_page/paints/auth_button_paints.dart';


/// A premium animated crimson auth button painted with [AuthButtonPainter].
///
/// Animations:
/// - **Idle shimmer sweep** — a subtle sheen slowly sweeps across the surface.
/// - **Press feedback** — the fill darkens on tap and springs back on release.
/// - **Loading state** — shows a white [CircularProgressIndicator] and disables taps.
///
/// ### Mandatory parameters
/// - [label]   — Button text (e.g. `'SIGN IN'`). **Required.**
/// - [onPressed] — Callback on tap. **Required.**
///
/// ### Example
/// ```dart
/// CrimsonAuthButton(
///   label: 'LOGIN',
///   onPressed: _handleLogin,
/// )
/// ```
class CrimsonAuthButton extends StatefulWidget {
  // ── Mandatory ─────────────────────────────────────────────────────────────

  /// Button label text. **Required.**
  final String label;

  /// Tap callback. **Required.**
  final VoidCallback onPressed;

  // ── Optional ──────────────────────────────────────────────────────────────

  /// Show a loading spinner instead of the label. Defaults to `false`.
  final bool isLoading;

  /// Button height. Defaults to `56.0`.
  final double height;

  /// Optional leading icon shown to the left of [label].
  final Widget? icon;

  /// Label letter spacing. Defaults to `3.5`.
  final double letterSpacing;

  /// Label font size. Defaults to `13.0`.
  final double fontSize;

  const CrimsonAuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.height = 56.0,
    this.icon,
    this.letterSpacing = 3.5,
    this.fontSize = 13.0,
  });

  @override
  State<CrimsonAuthButton> createState() => _CrimsonAuthButtonState();
}

class _CrimsonAuthButtonState extends State<CrimsonAuthButton>
    with TickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;
  late final AnimationController _pressCtrl;
  late final Animation<double> _shimmerAnim;
  late final Animation<double> _pressAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Idle shimmer
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
    _shimmerAnim = CurvedAnimation(parent: _shimmerCtrl, curve: Curves.linear);

    // Press feedback
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _pressAnim = CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _pressCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _pressCtrl.forward();
  void _onTapUp(TapUpDetails _) {
    _pressCtrl.reverse();
    if (!widget.isLoading) widget.onPressed();
  }
  void _onTapCancel() => _pressCtrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLoading ? null : _onTapDown,
      onTapUp: widget.isLoading ? null : _onTapUp,
      onTapCancel: widget.isLoading ? null : _onTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([_shimmerAnim, _pressAnim, _scaleAnim]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: CustomPaint(
              painter: AuthButtonPainter(
                pressProgress: _pressAnim.value,
                shimmerProgress: _shimmerAnim.value,
              ),
              child: child,
            ),
          );
        },
        child: SizedBox(
          height: widget.height,
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        widget.icon!,
                        const SizedBox(width: 10),
                      ],
                      Text(
                        widget.label.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.w700,
                          letterSpacing: widget.letterSpacing,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}