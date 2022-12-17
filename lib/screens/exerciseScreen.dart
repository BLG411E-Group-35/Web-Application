import 'package:flutter/material.dart';
import 'package:web_app/widgets/appBar.dart';

class ExercisePage extends StatefulWidget {
  static const routeName = "/exercises";
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  List<List<String>> exerciseList = [
    [
      "Sample Name",
      "lib/assets/images/image1.png",
      "lib/assets/images/image2.png",
      "lib/assets/images/image3.png",
      "lib/assets/images/image4.png"
    ],
    [
      "Sample Name",
      "lib/assets/images/image1.png",
      "lib/assets/images/image2.png",
      "lib/assets/images/image3.png",
      "lib/assets/images/image4.png",
    ],
    [
      "Sample Name",
      "lib/assets/images/image1.png",
      "lib/assets/images/image2.png",
      "lib/assets/images/image3.png",
      "lib/assets/images/image4.png"
    ],
  ];

  void removeExercise(int index) {
    print("yeyo");
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
        child: Container(
          padding: EdgeInsets.all(20),
          child: Table(
            border: TableBorder.all(color: Colors.black),
            defaultColumnWidth: FractionColumnWidth(1),
            children: [
              for (var exercise in exerciseList)
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              exercise[0],
                              textScaleFactor: 1,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                    onTap: () => {},
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Image.asset(
                                        "lib/assets/images/pen.png",
                                      ),
                                    )),
                                InkWell(
                                  onTap: () => removeExercise(
                                      exerciseList.indexOf(exercise)),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Image.asset(
                                      "lib/assets/images/bin.png",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (var string in exercise.sublist(1))
                              Image.asset(string),
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
