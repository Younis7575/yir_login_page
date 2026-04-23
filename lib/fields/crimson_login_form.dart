import 'package:flutter/material.dart';
import 'package:yir_login_page/fields/crimson_button.dart';
import 'package:yir_login_page/fields/crimson_fields.dart';
import 'package:yir_login_page/fields/crimson_password.dart';
import 'package:yir_login_page/social/social_icon_button.dart'; 
import 'crimson_social_row.dart'; 

/// The all-in-one premium auth form widget.
///
/// Combines [CrimsonEmailField], [CrimsonPasswordField], and [CrimsonAuthButton]
/// into a single, cohesive animated form. Optionally shows a [CrimsonSocialRow]
/// below the button.
///
/// ### Mandatory parameters
/// - [emailController]    — Controller for the email/phone field.
/// - [passwordController] — Controller for the password field.
/// - [onLogin]            — Callback invoked after form validation passes.
///
/// ### Optional parameters
/// - [socialItems]  — Up to 3 [SocialAuthItem]s for the social-auth row.
///
/// ### Minimal usage
/// ```dart
/// CrimsonLoginForm(
///   emailController: _emailCtrl,
///   passwordController: _passCtrl,
///   onLogin: () => _handleLogin(),
/// )
/// ```
///
/// ### With social buttons
/// ```dart
/// CrimsonLoginForm(
///   emailController: _emailCtrl,
///   passwordController: _passCtrl,
///   onLogin: _handleLogin,
///   socialItems: [
///     SocialAuthItem(
///       icon: Icon(Icons.g_mobiledata, color: Colors.white, size: 28),
///       label: 'Google',
///       onTap: _signInGoogle,
///     ),
///     SocialAuthItem(
///       icon: Icon(Icons.facebook, color: Colors.white, size: 26),
///       label: 'Facebook',
///       onTap: _signInFacebook,
///     ),
///     SocialAuthItem(
///       icon: Icon(Icons.apple, color: Colors.white, size: 26),
///       label: 'Apple',
///       onTap: _signInApple,
///     ),
///   ],
/// )
/// ```
class CrimsonLoginForm extends StatefulWidget {
  // ── Mandatory ─────────────────────────────────────────────────────────────

  /// Controller for the email / phone field. **Required.**
  final TextEditingController emailController;

  /// Controller for the password field. **Required.**
  final TextEditingController passwordController;

  /// Called when the form validates successfully and the user taps the button.
  /// **Required.**
  final VoidCallback onLogin;

  // ── Optional ──────────────────────────────────────────────────────────────

  /// Social auth items shown in [CrimsonSocialRow]. Max 3. Defaults to none.
  final List<SocialAuthItem>? socialItems;

  /// Hint text for the email/phone field. Defaults to `'name@gmail.com'`.
  final String emailHint;

  /// Hint text for the password field. Defaults to `'Enter password'`.
  final String passwordHint;

  /// Whether the field accepts email or phone. Defaults to email mode.
  final CrimsonFieldMode emailFieldMode;

  /// Custom validator for email/phone. Uses built-in rules if null.
  final String? Function(String?)? emailValidator;

  /// Custom validator for password. Uses a min-6-char rule if null.
  final String? Function(String?)? passwordValidator;

  /// Label for the login button. Defaults to `'LOGIN'`.
  final String buttonLabel;

  /// Whether the button shows a loading spinner. Defaults to `false`.
  final bool isLoading;

  /// Optional widget rendered above the form (e.g. a logo).
  final Widget? header;

  /// Spacing between form elements. Defaults to `16.0`.
  final double spacing;

  /// Whether to show the password strength bar. Defaults to `true`.
  final bool showPasswordStrength;

  /// Whether to show labels above each field. Defaults to `true`.
  final bool showFieldLabels;

  /// Whether to show icon labels in the social row. Defaults to `false`.
  final bool showSocialLabels;

  const CrimsonLoginForm({
    super.key,

    // Mandatory
    required this.emailController,
    required this.passwordController,
    required this.onLogin,

    // Optional
    this.socialItems,
    this.emailHint = 'name@gmail.com',
    this.passwordHint = 'Enter password',
    this.emailFieldMode = CrimsonFieldMode.email,
    this.emailValidator,
    this.passwordValidator,
    this.buttonLabel = 'LOGIN',
    this.isLoading = false,
    this.header,
    this.spacing = 16.0,
    this.showPasswordStrength = true,
    this.showFieldLabels = true,
    this.showSocialLabels = false,
  });

  @override
  State<CrimsonLoginForm> createState() => _CrimsonLoginFormState();
}

class _CrimsonLoginFormState extends State<CrimsonLoginForm>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final AnimationController _entryCtrl;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  final int _itemCount = 4; // header, email, pass, button

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnims = List.generate(_itemCount, (i) {
      final start = i * 0.18;
      final end = (start + 0.55).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _entryCtrl,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _slideAnims = List.generate(_itemCount, (i) {
      final start = i * 0.18;
      final end = (start + 0.55).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _entryCtrl,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  Widget _animated(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnims[index],
      child: SlideTransition(position: _slideAnims[index], child: child),
    );
  }

  String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Minimum 6 characters required';
    return null;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSocial =
        widget.socialItems != null && widget.socialItems!.isNotEmpty;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          if (widget.header != null)
            _animated(0, widget.header!),

          if (widget.header != null) SizedBox(height: widget.spacing * 1.5),

          // ── Email / Phone field ─────────────────────────────────────────
          _animated(
            1,
            CrimsonEmailField(
              controller: widget.emailController,
              hintText: widget.emailHint,
              validator: widget.emailValidator,
              mode: widget.emailFieldMode,
            ),
          ),
          SizedBox(height: widget.spacing),

          // ── Password field ──────────────────────────────────────────────
          _animated(
            2,
            CrimsonPasswordField(
              controller: widget.passwordController,
              hintText: widget.passwordHint,
              validator: widget.passwordValidator ?? _defaultPasswordValidator,
              showStrengthBar: widget.showPasswordStrength,
              textInputAction: TextInputAction.done,
            ),
          ),
          SizedBox(height: widget.spacing * 1.5),

          // ── Login button ────────────────────────────────────────────────
          _animated(
            3,
            CrimsonAuthButton(
              label: widget.buttonLabel,
              onPressed: _submit,
              isLoading: widget.isLoading,
            ),
          ),

          // ── Social row (optional) ───────────────────────────────────────
          if (hasSocial) ...[
            SizedBox(height: widget.spacing * 1.5),
            _animated(
              _itemCount - 1,
              CrimsonSocialRow(
                items: widget.socialItems!,
                showLabels: widget.showSocialLabels,
              ),
            ),
          ],
        ],
      ),
    );
  }
}