// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web_app/providers/WorkoutProvider.dart';
import 'package:web_app/widgets/appBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_app/widgets/buttons.dart';

class ExercisePage extends StatefulWidget {
  static const routeName = "/exercises";
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  bool _isInit = false;
  bool _isLoading = true;

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
    print(Provider.of<WorkoutProvider>(context, listen: false).moves);
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
                bool _isLoading = false;
                final GlobalKey<FormState> formKey = GlobalKey();
                Map<String, dynamic> values = {
                  "name": "",
                  "steps": null,
                };

                Future<void> getImagesFromGallery() async {
                  var imagePicker = ImagePicker();
                  images = await imagePicker.pickMultiImage();
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
                    if (images.length < values["steps"]) {
                      throw Exception("Not enough images provided");
                    }

                    if (images.length > values["steps"]) {
                      images = images.sublist(0, values["steps"]);
                    }

                    showSnackbar("${values['name']} Added Successfully",
                        error: false);
                  } catch (err) {
                    print(err.toString());
                    showSnackbar(
                        "Failed to add the new move: ${values['name']}");
                  }
                  Navigator.of(context).pop();
                }

                return AlertDialog(
                  title: const Text("Add new move"),
                  content: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
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
                              values["steps"] = int.tryParse(value!);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: getSteps,
                            child: const Text("Add"),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
