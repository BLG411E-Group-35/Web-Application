



//import '/package:webapp/screens/mainScreen.dart';
import './screens/userScreen.dart';
import './screens/programScreen.dart';
import './screens/profileScreen.dart';
import './screens/exerciseScreen.dart';
import './screens/loginScreen.dart';
import './themes/customTheme.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => WorkoutProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: CustomTheme.Color3,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: CustomTheme.Color3,
            backgroundColor: CustomTheme.Color1,
            accentColor: CustomTheme.Color2,
            errorColor: CustomTheme.Color5,
          ),
          textTheme: const TextTheme(
            headline4: TextStyle(
              color: CustomTheme.Color4,
              fontSize: 30,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
        home: const LoginScreen(),
        routes: {
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          ExerciseScreen.routeName: (ctx) => const ExerciseScreen(),
          MainScreen.routeName: (ctx) => const MainScreen(),
          ProfileScreen.routeName: (ctx) => const ProfileScreen(),
          ProgramScreen.routeName: (ctx) => const ProgramScreen(),
          UserScreen.routeName: (ctx) => const UserScreen(),
        },
      ),
    );
  }
}