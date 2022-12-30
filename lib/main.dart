import 'package:flutter/material.dart';
import 'package:web_app/providers/AuthProvider.dart';
import 'package:web_app/providers/UserProvider.dart';
import 'package:web_app/providers/WorkoutProvider.dart';
import 'package:web_app/screens/exerciseScreen.dart';
import 'package:web_app/screens/loginScreen.dart';
import 'package:web_app/screens/programScreen.dart';
import 'package:web_app/screens/userScreen.dart';
import 'package:web_app/screens/homeScreen.dart';
import 'package:web_app/themes/customTheme.dart';
import 'package:web_app/widgets/appBar.dart';
import 'package:provider/provider.dart';

import 'package:tflite/tflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, WorkoutProvider>(
          create: (context) => WorkoutProvider(null, null, null),
          update: (ctx, auth, previous) => WorkoutProvider(
            auth.token,
            auth.userId,
            previous == null ? [] : previous.items,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (context) => UserProvider(null, null, null),
          update: (ctx, auth, previous) => UserProvider(
            auth.token,
            auth.userId,
            previous == null ? [] : previous.items,
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Explore',
          theme: ThemeData(
            primaryColor: CustomTheme.Color2,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch:
                  CustomTheme.Color2, //from 1 to 3 gizot makes changes
              accentColor: CustomTheme.Color3, //from2 to 3 gizot makes changes
              errorColor: CustomTheme.Color5,
            ),
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
