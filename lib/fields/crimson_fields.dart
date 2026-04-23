import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yir_login_page/paints/auth_text_form_field_paint.dart';


/// A premium animated email / phone-number input field styled with the
/// crimson geometric [AuthTextFormFieldPainter].
///
/// ### Mandatory parameters
/// - [controller] — A [TextEditingController] to read/clear the field value.
/// - [hintText]   — Placeholder shown inside the field.
/// - [validator]  — A custom validation function; a default one is applied
///                  automatically when [mode] is set.
///
/// ### Optional parameters
/// All other parameters are optional and have sensible defaults.
///
/// ### Validation rules
/// - **email** mode: value must end with `@gmail.com` or `@outlook.com`.
/// - **phone** mode: value must contain digits only (keyboard is forced numeric).
///
/// ### Example
/// ```dart
/// CrimsonEmailField(
///   controller: _emailCtrl,
///   hintText: 'Enter email',
///   mode: CrimsonFieldMode.email,
///   validator: (v) => v == null || v.isEmpty ? 'Required' : null,
/// )
/// ```
enum CrimsonFieldMode { email, phone }

class CrimsonEmailField extends StatefulWidget {
  // ── Mandatory ────────────────────────────────────────────────────────────

  /// Controller for the text field. **Required.**
  final TextEditingController controller;

  /// Hint / placeholder text shown when the field is empty. **Required.**
  final String hintText;

  /// Validation function. Return a non-null string to show an error. **Required.**
  final String? Function(String?)? validator;

  // ── Optional ─────────────────────────────────────────────────────────────

  /// Whether this is an email or phone field. Defaults to [CrimsonFieldMode.email].
  final CrimsonFieldMode mode;

  /// Label text shown above the field. Defaults to `'Email / Phone'`.
  final String? label;

  /// Leading icon widget. Defaults to a mail/phone icon based on [mode].
  final Widget? prefixIcon;

  /// Field height. Defaults to `56.0`.
  final double height;

  /// Horizontal padding inside the painted area. Defaults to `18.0`.
  final double horizontalPadding;

  /// Called every time the text changes.
  final ValueChanged<String>? onChanged;

  /// Text input action (e.g. [TextInputAction.next]).
  final TextInputAction textInputAction;

  /// FocusNode for external focus control.
  final FocusNode? focusNode;

  const CrimsonEmailField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.mode = CrimsonFieldMode.email,
    this.label,
    this.prefixIcon,
    this.height = 56.0,
    this.horizontalPadding = 18.0,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
  });

  @override
  State<CrimsonEmailField> createState() => _CrimsonEmailFieldState();
}

class _CrimsonEmailFieldState extends State<CrimsonEmailField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmerAnim;
  bool _isFocused = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _shimmerAnim = CurvedAnimation(
      parent: _shimmerCtrl,
      curve: Curves.linear,
    );
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

  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return widget.mode == CrimsonFieldMode.email
          ? 'Email is required'
          : 'Phone number is required';
    }
    if (widget.mode == CrimsonFieldMode.email) {
      final lower = value.trim().toLowerCase();
      if (!lower.endsWith('@gmail.com') && !lower.endsWith('@outlook.com')) {
        return 'Use a @gmail.com or @outlook.com address';
      }
    } else {
      if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
        return 'Phone must contain digits only';
      }
      if (value.trim().length < 7) {
        return 'Enter a valid phone number';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isPhone = widget.mode == CrimsonFieldMode.phone;

    final Widget defaultIcon = Icon(
      isPhone ? Icons.phone_android_rounded : Icons.alternate_email_rounded,
      color: _isFocused
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color.fromARGB(255, 255, 255, 255),
      size: 20,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label ────────────────────────────────────────────────────────
        if (widget.label != null || true) ...[
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w600,
              color: _isFocused
                  ? const Color.fromARGB(255, 254, 254, 254)
                  : const Color.fromARGB(255, 255, 255, 255),
            ),
            child: Text(
              (widget.label ??
                      (isPhone ? 'PHONE NUMBER' : 'EMAIL ADDRESS'))
                  .toUpperCase(),
            ),
          ),
          const SizedBox(height: 6),
        ],

        // ── Painted field ─────────────────────────────────────────────────
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
            child: FormField<String>(
              validator: widget.validator ?? _defaultValidator,
              builder: (FormFieldState<String> field) {
                return Column(
                  children: [
                    SizedBox(
                      height: widget.height,
                      child: Row(
                        children: [
                          SizedBox(width: widget.horizontalPadding),

                          // Prefix icon
                          widget.prefixIcon ?? defaultIcon,
                          const SizedBox(width: 10),

                          // Input
                          Expanded(
                            child: TextFormField(
                              controller: widget.controller,
                              focusNode: _focusNode,
                              keyboardType: isPhone
                                  ? TextInputType.phone
                                  : TextInputType.emailAddress,
                              inputFormatters: isPhone
                                  ? [FilteringTextInputFormatter.digitsOnly]
                                  : null,
                              textInputAction: widget.textInputAction,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400,
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
                                field.didChange(v);
                                widget.onChanged?.call(v);
                              },
                              validator: widget.validator ?? _defaultValidator,
                            ),
                          ),

                          SizedBox(width: widget.horizontalPadding),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}