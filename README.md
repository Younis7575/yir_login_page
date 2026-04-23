# YIR Login Page

A premium, next-level animated authentication UI package for Flutter featuring a complete, production-ready login form with beautiful geometric designs and smooth animations.

## Features

✨ **CrimsonLoginForm** - All-in-one authentication form widget
- Email/phone number input with smart validation
- Password field with strength indicator
- Animated form elements with staggered entry animations
- Built-in form validation
- Loading state support with spinner
- Optional header widget (logo, title, etc.)

✨ **CrimsonEmailField** - Premium email/phone input
- Toggle between email and phone number validation modes
- Custom validation support
- Geometric crimson styling with CustomPainter
- Smooth focus animations

✨ **CrimsonPasswordField** - Advanced password input
- Real-time password strength indicator
- Show/hide password toggle
- Custom validation support
- Animated strength bar visualization

✨ **CrimsonAuthButton** - Animated login button
- Loading state with spinner animation
- Smooth press feedback
- Customizable labels and styling

✨ **CrimsonSocialRow** - Social authentication integration
- Display up to 3 social auth buttons
- Optional labels below icons
- Customizable social auth items

## Getting Started

### Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  yir_login_page: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Login Form

The simplest way to use the package:

```dart
import 'package:flutter/material.dart';
import 'package:yir_login_page/yir_login_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passCtrl;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _passCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() {
    print('Email: ${_emailCtrl.text}');
    print('Password: ${_passCtrl.text}');
    // Handle login logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: CrimsonLoginForm(
            emailController: _emailCtrl,
            passwordController: _passCtrl,
            onLogin: _handleLogin,
          ),
        ),
      ),
    );
  }
}
```

### With Social Authentication

Add social auth buttons below the login button:

```dart
CrimsonLoginForm(
  emailController: _emailCtrl,
  passwordController: _passCtrl,
  onLogin: _handleLogin,
  socialItems: [
    SocialAuthItem(
      icon: Icon(Icons.g_mobiledata, color: Colors.white, size: 28),
      label: 'Google',
      onTap: () => _signInWithGoogle(),
    ),
    SocialAuthItem(
      icon: Icon(Icons.facebook, color: Colors.white, size: 26),
      label: 'Facebook',
      onTap: () => _signInWithFacebook(),
    ),
    SocialAuthItem(
      icon: Icon(Icons.apple, color: Colors.white, size: 26),
      label: 'Apple',
      onTap: () => _signInWithApple(),
    ),
  ],
  showSocialLabels: true,
)
```

### With Phone Number Mode

Switch to phone number validation:

```dart
CrimsonLoginForm(
  emailController: _emailCtrl,
  passwordController: _passCtrl,
  onLogin: _handleLogin,
  emailFieldMode: CrimsonFieldMode.phone,
  emailHint: '+1 (555) 123-4567',
)
```

### With Header (Logo/Title)

Add a header widget:

```dart
CrimsonLoginForm(
  emailController: _emailCtrl,
  passwordController: _passCtrl,
  onLogin: _handleLogin,
  header: Column(
    children: [
      FlutterLogo(size: 80),
      SizedBox(height: 16),
      Text(
        'Welcome Back',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    ],
  ),
)
```

### Customization

```dart
CrimsonLoginForm(
  emailController: _emailCtrl,
  passwordController: _passCtrl,
  onLogin: _handleLogin,
  // Field hints
  emailHint: 'user@example.com',
  passwordHint: 'Your secure password',
  // Button customization
  buttonLabel: 'SIGN IN',
  // Display options
  showPasswordStrength: true,
  showFieldLabels: true,
  showSocialLabels: false,
  // Spacing
  spacing: 20.0,
  // Custom validators
  emailValidator: (email) {
    if (email?.isEmpty ?? true) return 'Email required';
    if (!email!.contains('@')) return 'Invalid email';
    return null;
  },
  passwordValidator: (password) {
    if (password?.isEmpty ?? true) return 'Password required';
    if (password!.length < 8) return 'Minimum 8 characters';
    return null;
  },
)
```

## Widget Parameters

### CrimsonLoginForm

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| emailController | TextEditingController | Yes | - | Controller for email/phone field |
| passwordController | TextEditingController | Yes | - | Controller for password field |
| onLogin | VoidCallback | Yes | - | Callback when login is tapped |
| socialItems | List<SocialAuthItem>? | No | null | Social auth buttons (max 3) |
| emailHint | String | No | 'name@gmail.com' | Hint text for email field |
| passwordHint | String | No | 'Enter password' | Hint text for password field |
| emailFieldMode | CrimsonFieldMode | No | email | Email or phone validation |
| buttonLabel | String | No | 'LOGIN' | Label for login button |
| isLoading | bool | No | false | Show loading spinner on button |
| header | Widget? | No | null | Widget shown above form |
| spacing | double | No | 16.0 | Spacing between form elements |
| showPasswordStrength | bool | No | true | Show password strength bar |
| showFieldLabels | bool | No | true | Show labels above fields |
| showSocialLabels | bool | No | false | Show labels on social buttons |

## API Reference

### Enums

```dart
enum CrimsonFieldMode {
  email,  // Email validation mode
  phone,  // Phone number validation mode
}
```

### Data Classes

```dart
class SocialAuthItem {
  final Widget icon;           // Icon widget
  final String? label;         // Optional label text
  final VoidCallback onTap;    // Callback on tap
}
```

## Example

For a complete working example, see the `example/` directory.

```bash
cd example
flutter run
```

## 📸 Preview

![Demo](https://raw.githubusercontent.com/Younis7575/yir_login_page/master/login_image.gif)

![Preview](https://raw.githubusercontent.com/Younis7575/yir_login_page/master/login_image1.jpeg)
![Preview](https://raw.githubusercontent.com/Younis7575/yir_login_page/master/login_image2.jpeg)



## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For questions and support, please open an issue on the [GitHub repository](https://github.com/yourusername/yir_login_page).
