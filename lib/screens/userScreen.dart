import 'package:flutter/material.dart';

class User extends StatefulWidget {
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
    return Center(
        heightFactor: 2,
        child: Container(
            padding: EdgeInsets.all(20),
            height: 10,
            child: Table(
                border: TableBorder.all(color: Colors.black),
                defaultColumnWidth: FractionColumnWidth(1),
                children: [
                  for (var exercise in exerciseList)
                    TableRow(children: [
                      TableCell(
                        child: Container(
                            height: 50,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    exercise[0],
                                    textScaleFactor: 1,
                                  ),
                                  InkWell(
                                    onTap: () => {},
                                    child: Image.asset(
                                      "../assets/pen.png",
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => removeExercise(
                                        exerciseList.indexOf(exercise)),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Image.asset("../assets/bin.png"),
                                    ),
                                  ),
                                  for (var string in exercise.sublist(1))
                                    Text(string),
                                ])),
                      )
                    ])
                ])));
  }
}
