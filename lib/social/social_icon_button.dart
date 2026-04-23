import 'package:flutter/material.dart';

/// Represents a single social-auth option shown in [CrimsonSocialRow].
///
/// Provide an [icon], an optional [label], and an [onTap] callback.
///
/// Example:
/// ```dart
/// SocialAuthItem(
///   icon: Icon(Icons.g_mobiledata, color: Colors.white),
///   label: 'Google',
///   onTap: () => _signInWithGoogle(),
/// )
/// ```
class SocialAuthItem {
  /// The icon widget shown inside the circular button.
  final Widget icon;

  /// Optional text label below the icon (shown when [CrimsonSocialRow.showLabels] is true).
  final String? label;

  /// Callback invoked when the user taps this social button.
  final VoidCallback onTap;

  const SocialAuthItem({
    required this.icon,
    required this.onTap,
    this.label,
  });
}