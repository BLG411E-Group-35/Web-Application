// main.dart
import 'package:web_app/screens/mainScreen.dart';
import 'package:web_app/screens/userManagementScreen.dart';
import 'package:flutter/material.dart';
import 'package:web_app/screens/loginScreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
      routes: {
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        MainScreen.routeName: (ctx) => const MainScreen(),
        UserScreen.routeName: (ctx) => const UserScreen(),
      }
    );
  }
}



