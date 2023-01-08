import 'dart:io';

import 'package:web_app/providers/AuthProvider.dart';
import 'package:web_app/screens/loginScreen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  setUpAll(() {
    // ↓ required to avoid HTTP error 400 mocked returns
    HttpOverrides.global = null;
  });
  Widget testWidget = MediaQuery(
    data: const MediaQueryData(),
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        )
      ],
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    ),
  );
  testWidgets(
    "Login test",
    (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      final emailFinder = find.text('E-Mail');
      final passwordFinder = find.text('Password');
      expect(emailFinder, findsOneWidget);
      expect(passwordFinder, findsOneWidget);

      final usernameField = find.ancestor(
        of: find.text('E-Mail'),
        matching: find.byType(TextFormField),
      );
      final passwordField = find.ancestor(
        of: find.text('Password'),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(usernameField, "admin@inertia.com");
      await tester.enterText(passwordField, "adminpw1");
      await tester.tap(find.byType(ElevatedButton));

      final errorFinder = find.byType(AlertDialog);
      expect(errorFinder, findsNothing);
    },
  );
}
