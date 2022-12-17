import 'package:flutter/material.dart';
import 'package:web_app/widgets/appBar.dart';

class User extends StatefulWidget {
  static const routeName = "/users";
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  List<List<String>> exerciseList = [
    [
      "User Name",
      "Joe",
      "Mama",
      "uyaru19@itu.edu.tr",
    ],
    [
      "User Name",
      "Joe",
      "Mama",
      "uyaru19@itu.edu.tr",
    ],
    [
      "User Name",
      "Joe",
      "Mama",
      "uyaru19@itu.edu.tr",
    ],
    [
      "User Name",
      "Joe",
      "Mama",
      "uyaru19@itu.edu.tr",
    ],
  ];

  void removeExercise(int index) {
    setState(() {
      exerciseList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: const CustomAppBarContent(),
      ),
      body: Center(
        heightFactor: 2,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Table(
            border: TableBorder.all(color: Colors.black),
            defaultColumnWidth: FractionColumnWidth(1),
            children: [
              for (var exercise in exerciseList)
                TableRow(
                  children: [
                    TableCell(
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              exercise[0],
                              textScaleFactor: 1,
                            ),
                            InkWell(
                              onTap: () => {},
                              child: Image.asset(
                                "lib/assets/images/pen.png",
                              ),
                            ),
                            InkWell(
                              onTap: () => removeExercise(
                                  exerciseList.indexOf(exercise)),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Image.asset("lib/assets/images/bin.png"),
                              ),
                            ),
                            for (var string in exercise.sublist(1))
                              Text(string),
                          ],
                        ),
                      ),
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
