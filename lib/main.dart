// main.dart

import 'package:flutter/material.dart';


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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(70),
            child: Column(
              children: [
                Center(
                  child: InkWell(
                    child: Text(
                      "Today’s Accomplishments:",
                      style: TextStyle(fontSize: 50 ,color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      width: 592,
                      height: 450,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: Color(0xFFDBD56E)),
                      child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                        "3,400 \nUsers",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 100),
                      ),
                      ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: 592,
                      height: 450,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: Color(0xFFDBD56E)),
                      child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                        "2,500\nExercises",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 100),
                      ),
                      ),
                      ),
                    )

                  ],
                ),
              ],
            ),
            
          ),
        ),  
      ))


      
    );
  }
}
