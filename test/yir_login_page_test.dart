import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yir_login_page/yir_login_page.dart';

void main() {
  group('CrimsonLoginForm Widget Tests', () {
    testWidgets('CrimsonLoginForm renders successfully', (WidgetTester tester) async {
      final emailController = TextEditingController();
      final passwordController = TextEditingController();
      bool loginPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CrimsonLoginForm(
              emailController: emailController,
              passwordController: passwordController,
              onLogin: () {
                loginPressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.byType(CrimsonLoginForm), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(loginPressed, false);

      addTearDown(emailController.dispose);
      addTearDown(passwordController.dispose);
    });

    testWidgets('CrimsonLoginForm shows email and password fields', (WidgetTester tester) async {
      final emailController = TextEditingController();
      final passwordController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CrimsonLoginForm(
              emailController: emailController,
              passwordController: passwordController,
              onLogin: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CrimsonEmailField), findsOneWidget);
      expect(find.byType(CrimsonPasswordField), findsOneWidget);

      addTearDown(emailController.dispose);
      addTearDown(passwordController.dispose);
    });

    testWidgets('CrimsonLoginForm with social items renders correctly', (WidgetTester tester) async {
      final emailController = TextEditingController();
      final passwordController = TextEditingController();
      final socialItems = [
        SocialAuthItem(
          icon: const Icon(Icons.g_mobiledata),
          label: 'Google',
          onTap: () {},
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CrimsonLoginForm(
              emailController: emailController,
              passwordController: passwordController,
              onLogin: () {},
              socialItems: socialItems,
            ),
          ),
        ),
      );

      expect(find.byType(CrimsonLoginForm), findsOneWidget);

      addTearDown(emailController.dispose);
      addTearDown(passwordController.dispose);
    });
  });
}
