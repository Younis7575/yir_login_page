import 'package:flutter/material.dart';
import 'package:yir_login_page/social/social_icon_button.dart';


/// An optional row of up to **3** social-auth icon buttons rendered below the
/// main [CrimsonAuthButton].
///
/// Each button is a circular crimson-bordered icon that scales and glows on
/// press. Provide 1–3 [SocialAuthItem] objects.
///
/// ### Example
/// ```dart
/// CrimsonSocialRow(
///   items: [
///     SocialAuthItem(
///       icon: Icon(Icons.g_mobiledata, color: Colors.white, size: 28),
///       label: 'Google',
///       onTap: () => _signInGoogle(),
///     ),
///     SocialAuthItem(
///       icon: Icon(Icons.facebook, color: Colors.white, size: 26),
///       label: 'Facebook',
///       onTap: () => _signInFacebook(),
///     ),
///   ],
/// )
/// ```
class CrimsonSocialRow extends StatelessWidget {
  /// List of social auth items (max 3). **Required.**
  final List<SocialAuthItem> items;

  final String? dividerLabel;

  /// Whether to show text labels below icons. Defaults to `false`.
  final bool showLabels;

  /// Icon button size (diameter). Defaults to `52.0`.
  final double buttonSize;

  const CrimsonSocialRow({
    super.key,
    required this.items,
    this.dividerLabel,
    this.showLabels = false,
    this.buttonSize = 52.0,
  }) : assert(items.length <= 3, 'CrimsonSocialRow supports a maximum of 3 items.');

  @override
  Widget build(BuildContext context) {
    final displayItems = items.take(3).toList();
    return Column(
      children: [
        // ── Divider with label ──────────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xFF330000)],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                dividerLabel ?? 'OR CONTINUE WITH',
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 254, 254),
                  fontSize: 9,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF330000), Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Social buttons ──────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: displayItems.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SocialButton(item: item, size: buttonSize),
                  if (showLabels && item.label != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      item.label!,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 253, 253, 253),
                        fontSize: 9,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Internal animated social icon button ──────────────────────────────────────

class _SocialButton extends StatefulWidget {
  final SocialAuthItem item;
  final double size;
  const _SocialButton({required this.item, required this.size});

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 350),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.item.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(
                  color: Color.lerp(
                    const Color(0xFF440000),
                    const Color(0xFFFF0000),
                    _glowAnim.value,
                  )!,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF0000)
                        .withValues(alpha:  0.0 + _glowAnim.value * 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(child: child),
            ),
          );
        },
        child: widget.item.icon,
      ),
    );
  }
}