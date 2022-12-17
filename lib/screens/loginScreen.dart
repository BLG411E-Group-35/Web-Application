import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:web_app/screens/mainScreen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login";
  const LoginScreen();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    List _isHovering = [false, false, false, false];

    

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: Container(
          color: Color(0xFF88AB75),
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
                SizedBox(width: screenSize.width /50),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Exercises',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: screenSize.width / 50),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Programs',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: screenSize.width / 50),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Users',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: screenSize.width / 50),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: screenSize.width / 50,
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Log Out',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),



      body: SingleChildScrollView(child:SizedBox(
        width: screenSize.width, height: screenSize.height,
        child:Row(children: [
          Flexible(
            flex: 1,
            child: Container(
              width: screenSize.width*0.6, height: screenSize.height,
            )),
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: 
              Row(
                children: [
                Container(
                  height: 185,
                  width: 359,
                  alignment: Alignment.center,
                    child:
                      Text(
                        "Hello,\n\nWelcome to Inertia's\nWeb Management\nService",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 30),
                      )
                  ),
                Container(
                  alignment: Alignment.center,
                  height: 44,
                  width: 359,
                  color: Color(0xFFDBD56E)),
                Container(
                  alignment: Alignment.center,
                  height: 44,
                  width: 359,
                  color: Color(0xFFDBD56E),),
                  ],
                ),
                ),
                
              
            ],
            ),
            ),
      ),


      
    );
  }
}

