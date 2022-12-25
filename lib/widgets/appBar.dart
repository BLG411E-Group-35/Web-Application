import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app/providers/AuthProvider.dart';
import 'package:web_app/screens/exerciseScreen.dart';
import 'package:web_app/screens/loginScreen.dart';
import 'package:web_app/screens/programScreen.dart';
import 'package:web_app/screens/userScreen.dart';

class CustomAppBarContent extends StatelessWidget {
  const CustomAppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            //logo will be added
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            SizedBox(width: screenSize.width / 50),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(ExercisePage.routeName);
              },
              child: Text(
                'Exercises',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: screenSize.width / 50),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Programs.routeName);
              },
              child: Text(
                'Programs',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: screenSize.width / 50),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(User.routeName);
              },
              child: Text(
                'Users',
                style: TextStyle(color: Colors.white),
              ),
            ),
            // SizedBox(width: screenSize.width / 50),
            // InkWell(
            //   onTap: () {},
            //   child: Text(
            //     'Profile',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
            SizedBox(
              width: screenSize.width / 50,
            ),
            InkWell(
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              },
              child: Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
