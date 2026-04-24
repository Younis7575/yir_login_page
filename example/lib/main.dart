import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yir_login_page/yir_login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YIR Login Page Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const LoginDemoPage(),
    );
  }
}

class LoginDemoPage extends StatefulWidget {
  const LoginDemoPage({super.key});

  @override
  State<LoginDemoPage> createState() => _LoginDemoPageState();
}

class _LoginDemoPageState extends State<LoginDemoPage> {
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passCtrl;
  bool _isLoading = false;
  String? _message;

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
    setState(() {
      _isLoading = true;
      _message = null;
    });

    // Simulate a login request
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _message = 'Login successful!\nEmail: ${_emailCtrl.text}';
      });

      // Clear message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _message = null;
        });
      });
    });
  }

  void _handleGoogleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google login would be called here')),
    );
  }

  void _handleFacebookLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Facebook login would be called here')),
    );
  }

  void _handleAppleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple login would be called here')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [




 

Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
     colors: [
  Color(0xFF1A1F4D),
  Color(0xFF3A3F9F),
  Color(0xFF6A5CFF),
],
    ),
  ),
)

,
          
          // Main content
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header
                    const SizedBox(height: 20),
                    const Icon(Icons.security, size: 80, color: Colors.white),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome to YIR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Premium Login Form',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 48),

                    // Success message
                    if (_message != null)
                      Card(
                        color: Colors.green.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _message!,
                            style: TextStyle(
                              color: Colors.green.shade900,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (_message != null) const SizedBox(height: 24),

                    // Login form
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ), // The glass blur effect
                        child: Container(
                         decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(20),

  // ✨ soft glass border
  border: Border.all(
    color: Colors.white..withValues(alpha:0.18),
  ),

  // 🔷 match background (indigo glass)
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white..withValues(alpha:0.15),
      Colors.white..withValues(alpha:0.05),
    ],
  ),

  // 🌑 soft shadow (not harsh black)
  boxShadow: [
    BoxShadow(
      color: Colors.black..withValues(alpha:0.15),
      blurRadius: 15,
      offset: const Offset(0, 8),
    ),
  ],
),
                          padding: const EdgeInsets.all(24),
                          child: CrimsonLoginForm(
                            emailController: _emailCtrl,
                            passwordController: _passCtrl,
                            onLogin: _handleLogin,
                            isLoading: _isLoading,
                            buttonLabel: 'SIGN IN',
                            emailHint: 'your@email.com',
                            passwordHint: 'Your password',
                            socialItems: [
                              SocialAuthItem(
                                icon: const Icon(
                                  Icons.g_mobiledata,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                label: 'Google',
                                onTap: _handleGoogleLogin,
                              ),
                              SocialAuthItem(
                                icon: const Icon(
                                  Icons.facebook,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                label: 'Facebook',
                                onTap: _handleFacebookLogin,
                              ),
                              SocialAuthItem(
                                icon: const Icon(
                                  Icons.apple,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                label: 'Apple',
                                onTap: _handleAppleLogin,
                              ),
                            ],
                            showSocialLabels: true,
                            spacing: 18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Additional info
                    const Text(
                      'Try these demo credentials:',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white30),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email: demo@gmail.com',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Password: password123',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
