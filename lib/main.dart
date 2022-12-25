import 'package:flutter/material.dart';
import 'package:web_app/providers/AuthProvider.dart';
import 'package:web_app/screens/exerciseScreen.dart';
import 'package:web_app/screens/loginScreen.dart';
import 'package:web_app/screens/programScreen.dart';
import 'package:web_app/screens/userScreen.dart';
import 'package:web_app/screens/homeScreen.dart';
import 'package:web_app/widgets/appBar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Explore',
          theme: ThemeData(
            primaryColor: const Color(0xFF88AB75),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuthenticated ? HomePage() : const LoginScreen(),
          routes: {
            ExercisePage.routeName: (context) => const ExercisePage(),
            Programs.routeName: (context) => const Programs(),
            User.routeName: (context) => const User(),
            HomePage.routeName: (context) => HomePage(),
            LoginScreen.routeName: (context) => const LoginScreen(),
          },
        ),
      ),
    );
  }
}
