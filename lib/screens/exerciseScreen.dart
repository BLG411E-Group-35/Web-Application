import 'package:flutter/material.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  List<List<String>> exerciseList = [
    [
      "Sample Name",
      "../assets/image1.png",
      "../assets/image2.png",
      "../assets/image3.png",
      "../assets/image4.png"
    ],
    [
      "Sample Name",
      "../assets/image1.png",
      "../assets/image2.png",
      "../assets/image3.png",
      "../assets/image4.png",
    ],
    [
      "Sample Name",
      "../assets/image1.png",
      "../assets/image2.png",
      "../assets/image3.png",
      "../assets/image4.png"
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
                                    Image.asset(string),
                                ])),
                      )
                    ])
                ])));
  }
}
