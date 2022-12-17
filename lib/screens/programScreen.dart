import 'package:flutter/material.dart';
import 'package:web_app/widgets/appBar.dart';

class Programs extends StatefulWidget {
  static const routeName = "/programs";
  const Programs({super.key});

  @override
  State<Programs> createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  List<List<String>> programsList = [
    [
      "Sample Program",
      "x sets, y repeats",
      "a sets, b repeats",
      "n sets, m repeats",
    ],
    [
      "Sample Program",
      "x sets, y repeats",
      "a sets, b repeats",
      "n sets, m repeats",
    ],
    [
      "Sample Program",
      "x sets, y repeats",
      "a sets, b repeats",
      "n sets, m repeats",
    ],
    [
      "Sample Program",
      "x sets, y repeats",
      "a sets, b repeats",
      "n sets, m repeats",
    ],
  ];

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
              for (var program in programsList)
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              program[0],
                              textScaleFactor: 1.0,
                            ),
                            for (var move in program.sublist(1))
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
                                    onTap: () => {},
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Image.asset(
                                        "lib/assets/images/bin.png",
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      move,
                                      textScaleFactor: 1,
                                    ),
                                  )
                                ],
                              )
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

class moves extends StatelessWidget {
  const moves({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
