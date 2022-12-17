import 'package:flutter/material.dart';

class Programs extends StatefulWidget {
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
    return Center(
      child: Container(
        child: Table(
          border: TableBorder.all(color: Colors.black),
          defaultColumnWidth: FractionColumnWidth(1),
          children: [
            for (var program in programsList)
              TableRow(children: [
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
                          Wrap(
                            children: [
                              InkWell(
                                  onTap: () => {},
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Image.asset(
                                      "../assets/pen.png",
                                    ),
                                  )),
                              InkWell(
                                onTap: () => {},
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Image.asset("../assets/bin.png"),
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
                      ]),
                ))
              ])
          ],
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
