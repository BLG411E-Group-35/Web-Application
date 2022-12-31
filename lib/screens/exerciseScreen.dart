// import 'dart:html';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scribble/scribble.dart';
import 'package:web_app/providers/WorkoutProvider.dart';
import 'package:web_app/widgets/appBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_app/widgets/buttons.dart';

import 'dart:ui' as ui;

class ExercisePage extends StatefulWidget {
  static const routeName = "/exercises";
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  bool _isInit = false;
  bool _isLoading = true;

  final double WIDTH_RESIZE = 400;
  final double HEIGHT_RESIZE = 400;

  List<String> joints = [
    "nose",
    "leftEye",
    "rightEye",
    "leftEar",
    "rightEar",
    "leftShoulder",
    "rightShoulder",
    "leftElbow",
    "rightElbow",
    "leftWrist",
    "rightWrist",
    "leftHip",
    "rightHip",
    "leftKnee",
    "rightKnee",
    "leftAnkle",
    "rightAnkle",
  ];

  void showSnackbar(String msg, {bool error = true}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<WorkoutProvider>(context).fetchMovesFull().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError(
        (error) {
          print(error);
        },
      );

      _isInit = true;
    }
    super.didChangeDependencies();
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
          child: _isLoading
              ? const CircularProgressIndicator()
              : Consumer<WorkoutProvider>(
                  builder: (ctx, workouts, _) => Container(
                    padding: EdgeInsets.all(20),
                    child: Table(
                      border: TableBorder.all(color: Colors.black),
                      defaultColumnWidth: FractionColumnWidth(1),
                      children: [
                        ...workouts.moves.map(
                          (exercise) => TableRow(
                            children: [
                              TableCell(
                                child: SizedBox(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        exercise["workoutMoveName"],
                                        textScaleFactor: 1,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text(
                                                  "Remove ${exercise['workoutMoveName']}"),
                                              content: const Text(
                                                  "Are you sure you want to delete this workout?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    try {
                                                      await workouts.removeMove(
                                                        exercise[
                                                                "workoutMoveId"]
                                                            .toString(),
                                                      );
                                                      setState(() {
                                                        showSnackbar(
                                                          "Successfully Removed",
                                                          error: false,
                                                        );
                                                      });
                                                    } catch (err) {
                                                      showSnackbar(
                                                          err.toString());
                                                    }
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(ctx).pop(),
                                                  child: const Text("No"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Image.asset(
                                            "lib/assets/images/bin.png",
                                          ),
                                        ),
                                      ),
                                      ...exercise["steps"].map(
                                        (step) => IconButton(
                                            onPressed: () {},
                                            icon:
                                                Icon(Icons.sports_gymnastics)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                List<XFile> images = [];
                List<Uint8List> imagesAsBytes = [];
                List<Map<String, dynamic>> steps = [];
                List<int> labelIdx = [];
                List<ScribbleNotifier> notifiers = [];
                bool _isLoading = false;
                final GlobalKey<FormState> formKey = GlobalKey();
                Map<String, dynamic> values = {
                  "name": "",
                  "num_steps": null,
                };

                Paint shapePaint = Paint()
                  ..strokeWidth = 2
                  ..color = Colors.red
                  ..style = PaintingStyle.stroke
                  ..strokeCap = StrokeCap.round;

                Future<void> getImagesFromGallery() async {
                  var imagePicker = ImagePicker();
                  images = await imagePicker.pickMultiImage();
                  notifiers = List.generate(
                    images.length,
                    (index) {
                      ScribbleNotifier notifier = ScribbleNotifier(
                        allowedPointersMode: ScribblePointerMode.mouseOnly,
                        widths: [2],
                      );
                      notifier.setColor(Colors.red);
                      return notifier;
                    },
                  );
                  steps = List.generate(
                      images.length,
                      (index) => {
                            "order": index + 1,
                            "joint_coordinates": {
                              "x_nose": null,
                              "x_leftEye": null,
                              "x_rightEye": null,
                              "x_leftEar": null,
                              "x_rightEar": null,
                              "x_leftShoulder": null,
                              "x_rightShoulder": null,
                              "x_leftElbow": null,
                              "x_rightElbow": null,
                              "x_leftWrist": null,
                              "x_rightWrist": null,
                              "x_leftHip": null,
                              "x_rightHip": null,
                              "x_leftKnee": null,
                              "x_rightKnee": null,
                              "x_leftAnkle": null,
                              "x_rightAnkle": null,
                              "y_nose": null,
                              "y_leftEye": null,
                              "y_rightEye": null,
                              "y_leftEar": null,
                              "y_rightEar": null,
                              "y_leftShoulder": null,
                              "y_rightShoulder": null,
                              "y_leftElbow": null,
                              "y_rightElbow": null,
                              "y_leftWrist": null,
                              "y_rightWrist": null,
                              "y_leftHip": null,
                              "y_rightHip": null,
                              "y_leftKnee": null,
                              "y_rightKnee": null,
                              "y_leftAnkle": null,
                              "y_rightAnkle": null,
                              "image_width": WIDTH_RESIZE,
                              "image_height": HEIGHT_RESIZE,
                            }
                          });
                  labelIdx = List.generate(images.length, (index) => 0);
                  for (var image in images) {
                    var bytes = await image.readAsBytes();
                    imagesAsBytes.add(bytes);
                  }
                }

                Future<void> getSteps() async {
                  if (formKey.currentState == null ||
                      !formKey.currentState!.validate()) {
                    // Invalid!
                    return;
                  }

                  formKey.currentState!.save();
                  try {
                    await getImagesFromGallery();
                    if (images.length < values["num_steps"]) {
                      throw Exception("Not enough images provided");
                    }

                    if (images.length > values["num_steps"]) {
                      images = images.sublist(0, values["num_steps"]);
                    }

                    showSnackbar("Files read successfully.", error: false);
                  } catch (err) {
                    print(err.toString());
                    showSnackbar(
                        "Failed to add the new move: ${values['name']}");
                  }
                }

                Future<void> addMove() async {
                  labelIdx.forEach((element) {
                    if (element != joints.length - 1) {
                      showSnackbar("All joints must be considered!");
                      Navigator.of(context).pop();
                    }
                  });

                  try {
                    await Provider.of<WorkoutProvider>(
                      context,
                      listen: false,
                    ).addMove(
                      steps,
                      values["name"],
                    );
                    showSnackbar("Move added successfully.", error: false);
                  } catch (err) {
                    print(err.toString());
                    showSnackbar(
                        "Failed to add the new move: ${values['name']}");
                  }
                }

                return AlertDialog(
                  title: const Text("Add new move"),
                  content: StatefulBuilder(
                      builder: ((context, setState) => Form(
                          key: formKey,
                          child: SingleChildScrollView(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                TextFormField(
                                  enabled: images.isEmpty,
                                  decoration: const InputDecoration(
                                    labelText: 'Move Name',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Invalid name!';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    values["name"] = value ?? "";
                                  },
                                ),
                                TextFormField(
                                  enabled: images.isEmpty,
                                  decoration: const InputDecoration(
                                    labelText: 'Steps',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (String? value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        int.parse(value) <= 0) {
                                      return 'Invalid steps!';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    values["num_steps"] = int.tryParse(value!);
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ...images.map(
                                  (img) => SizedBox(
                                    width: 300,
                                    child: SizedBox(
                                      width: 100,
                                      child: ExpansionTile(
                                        textColor: Colors.black54,
                                        collapsedTextColor: Colors.black54,
                                        title: Text(img.name),
                                        subtitle: Text(joints[
                                            labelIdx[images.indexOf(img)]]),
                                        childrenPadding: EdgeInsets.all(10.0),
                                        children: [
                                          SizedBox(
                                            width: WIDTH_RESIZE,
                                            height: HEIGHT_RESIZE,
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                    height: HEIGHT_RESIZE,
                                                    width: WIDTH_RESIZE,
                                                    child: Image.memory(
                                                      imagesAsBytes[
                                                          images.indexOf(img)],
                                                      fit: BoxFit.fill,
                                                    )),
                                                SizedBox(
                                                  height: HEIGHT_RESIZE,
                                                  width: WIDTH_RESIZE,
                                                  child: Listener(
                                                    onPointerDown: (event) {
                                                      int idx =
                                                          images.indexOf(img);
                                                      String key =
                                                          joints[labelIdx[idx]];
                                                      if (event.buttons == 1) {
                                                        Offset pos =
                                                            event.localPosition;

                                                        steps[idx][
                                                                "joint_coordinates"]
                                                            ["x_$key"] = pos
                                                                .dx /
                                                            WIDTH_RESIZE;
                                                        steps[idx][
                                                                "joint_coordinates"]
                                                            ["y_$key"] = pos
                                                                .dy /
                                                            HEIGHT_RESIZE;

                                                        if (labelIdx[idx] <
                                                            joints.length - 1) {
                                                          setState((() {
                                                            labelIdx[idx] += 1;
                                                          }));
                                                        }
                                                      } else if (event
                                                              .buttons ==
                                                          2) {
                                                        if (labelIdx[idx] <
                                                            joints.length - 1) {
                                                          setState((() {
                                                            labelIdx[idx] += 1;
                                                          }));
                                                        }
                                                      }
                                                    },
                                                    child: Scribble(
                                                      notifier: notifiers[
                                                          images.indexOf(img)],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: images.isEmpty
                                      ? () async {
                                          await getSteps();
                                          setState(() {});
                                        }
                                      : addMove,
                                  child:
                                      Text(images.isEmpty ? "Upload" : "Add"),
                                )
                              ]))))),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
