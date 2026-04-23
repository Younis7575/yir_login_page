import 'package:flutter/material.dart';
import 'package:yir_login_page/paints/auth_text_form_field_paint.dart';


/// A premium animated password field styled with [AuthTextFormFieldPainter].
///
/// Features:
/// - Animated focus shimmer on the geometric border
/// - Tap-to-reveal eye icon with a smooth opacity transition
/// - Real-time password-strength bar (weak / fair / strong) with colour coding
///
/// ### Mandatory parameters
/// - [controller] — A [TextEditingController] to read the password value.
/// - [hintText]   — Placeholder text.
/// - [validator]  — Custom validation function.
///
/// ### Example
/// ```dart
/// CrimsonPasswordField(
///   controller: _passCtrl,
///   hintText: 'Enter password',
///   validator: (v) => v != null && v.length >= 6 ? null : 'Too short',
/// )
/// ```
class CrimsonPasswordField extends StatefulWidget {
  // ── Mandatory ────────────────────────────────────────────────────────────

  /// Controller for the password input. **Required.**
  final TextEditingController controller;

  /// Hint / placeholder text. **Required.**
  final String hintText;

  /// Validation function. **Required.**
  final String? Function(String?)? validator;

  // ── Optional ─────────────────────────────────────────────────────────────

  /// Label shown above the field. Defaults to `'PASSWORD'`.
  final String? label;

  /// Field height. Defaults to `56.0`.
  final double height;

  /// Whether to show the live strength indicator bar. Defaults to `true`.
  final bool showStrengthBar;

  /// Text input action. Defaults to [TextInputAction.done].
  final TextInputAction textInputAction;

  /// External focus node.
  final FocusNode? focusNode;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  const CrimsonPasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.label,
    this.height = 56.0,
    this.showStrengthBar = true,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    this.onChanged,
  });

  @override
  State<CrimsonPasswordField> createState() => _CrimsonPasswordFieldState();
}

class _CrimsonPasswordFieldState extends State<CrimsonPasswordField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmerAnim;
  bool _isFocused = false;
  bool _obscure = true;
  late final FocusNode _focusNode;
  String _password = '';

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(() {
      if (mounted) setState(() => _password = widget.controller.text);
    });

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _shimmerAnim = CurvedAnimation(parent: _shimmerCtrl, curve: Curves.linear);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_focusNode.hasFocus) {
      _shimmerCtrl.repeat();
    } else {
      _shimmerCtrl.stop();
      _shimmerCtrl.reset();
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  // ── Password strength ─────────────────────────────────────────────────────
  int _strengthLevel(String p) {
    if (p.isEmpty) return 0;
    int score = 0;
    if (p.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(p)) score++;
    if (RegExp(r'[0-9]').hasMatch(p)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(p)) score++;
    return score; // 0-4
  }

  Color _strengthColor(int level) {
    switch (level) {
      case 1:
        return const Color(0xFFFF3333);
      case 2:
        return const Color(0xFFFF8800);
      case 3:
        return const Color(0xFFFFCC00);
      case 4:
        return const Color(0xFF00CC66);
      default:
        return Colors.transparent;
    }
  }

  String _strengthLabel(int level) {
    switch (level) {
      case 1:
        return 'WEAK';
      case 2:
        return 'FAIR';
      case 3:
        return 'GOOD';
      case 4:
        return 'STRONG';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final int strength = _strengthLevel(_password);
    final Color sColor = _strengthColor(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label ──────────────────────────────────────────────────────────
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w600,
            color: _isFocused
                ? const Color(0xFFFF3333)
                : const Color(0xFF666666),
          ),
          child: Text(
            (widget.label ?? 'PASSWORD').toUpperCase(),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w600,
              color: _isFocused
                  ? const Color.fromARGB(255, 254, 254, 254)
                  : const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        const SizedBox(height: 6),

        // ── Painted field ───────────────────────────────────────────────────
        AnimatedBuilder(
          animation: _shimmerAnim,
          builder: (context, child) {
            return CustomPaint(
              painter: AuthTextFormFieldPainter(
                glowProgress: _shimmerAnim.value,
                isFocused: _isFocused,
              ),
              child: child,
            );
          },
          child: SizedBox(
            height: widget.height,
            child: Row(
              children: [
                const SizedBox(width: 18),

                // Lock icon
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    _isFocused
                        ? Icons.lock_open_rounded
                        : Icons.lock_outline_rounded,
                    key: ValueKey(_isFocused),
                    color: _isFocused
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 255, 255, 255),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),

                // Input
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    obscureText: _obscure,
                    textInputAction: widget.textInputAction,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 2.0,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        letterSpacing: 0.3,
                      ),
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (v) {
                      widget.onChanged?.call(v);
                    },
                    validator: widget.validator,
                  ),
                ),

                // Eye toggle
                GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      key: ValueKey(_obscure),
                      color: const Color.fromARGB(255, 255, 255, 255),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
              ],
            ),
          ),
        ),

        // ── Strength bar ────────────────────────────────────────────────────
        if (widget.showStrengthBar && _password.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              ...List.generate(4, (i) {
                final bool active = i < strength;
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2.5,
                    margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                    decoration: BoxDecoration(
                      color: active ? sColor : const Color(0xFF222222),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _strengthLabel(strength),
                  key: ValueKey(strength),
                  style: TextStyle(
                    color: sColor,
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}