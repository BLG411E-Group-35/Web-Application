import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app/models/http_exception.dart';
import 'package:web_app/providers/WorkoutProvider.dart';
import 'package:web_app/widgets/appBar.dart';
import 'package:web_app/widgets/buttons.dart';
import 'package:flutter/services.dart';

import '../themes/customTheme.dart';

class Programs extends StatefulWidget {
  static const routeName = "/programs";
  const Programs({super.key});

  @override
  State<Programs> createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  bool _isInit = false;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<WorkoutProvider>(context)
          .fetchWorkouts()
          .then((_) {})
          .catchError(
        (error) {
          print(error);
        },
      );
      _isInit = true;
      setState(() {
        isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  Color getColorBasedOnDifficulty(String difficulty) {
    if (difficulty == "hard") {
      return CustomTheme.Color5;
    } else if (difficulty == "medium") {
      return CustomTheme.Color1;
    } else {
      return CustomTheme.Color2;
    }
  }

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

  void showCreationPopUpMenu({oldData}) {
    Provider.of<WorkoutProvider>(context, listen: false)
        .fetchMoves()
        .then((moves) => showDialog(
              context: context,
              builder: (ctx) {
                Map<String, dynamic> workoutData = {};
                Map<dynamic, bool> moveSelected = {};
                Map<dynamic, int?> moveSets = {};
                Map<dynamic, int?> moveReps = {};
                final GlobalKey<FormState> formKey = GlobalKey();
                bool isLoading = false;

                workoutData = {
                  "workoutName": oldData != null ? oldData["workoutName"] : "",
                  "workoutDescription":
                      oldData != null ? oldData["workoutDescription"] : "",
                  "workoutDuration": oldData != null
                      ? oldData["workoutDuration"].toString()
                      : "",
                  "workoutDifficulty":
                      oldData != null ? oldData["workoutDifficulty"] : "",
                };

                moves.forEach((key, value) {
                  moveSelected[key] = false;
                  moveSets[key] = null;
                  moveReps[key] = null;
                });

                if (oldData != null) {
                  oldData["moves"].forEach((m) {
                    moveSelected[m["workoutMoveName"]] = true;
                    moveSets[m["workoutMoveName"]] = m["sets"];
                    moveReps[m["workoutMoveName"]] = m["repeats"];
                  });
                }

                return AlertDialog(
                    title: const Text("Add new workout."),
                    content: StatefulBuilder(builder: ((context, setState) {
                      Future<void> submit() async {
                        if (formKey.currentState == null ||
                            !formKey.currentState!.validate()) {
                          // Invalid!
                          return;
                        }
                        formKey.currentState!.save();

                        workoutData["moveCount"] = 0;
                        workoutData["moves"] = [];

                        moveSelected.forEach((key, value) {
                          if (value) {
                            workoutData["moves"].add({
                              "moveId": moves[key].toString(),
                              "order":
                                  (workoutData["moveCount"] + 1).toString(),
                              "sets": moveSets[key].toString(),
                              "repeats": moveReps[key].toString(),
                            });

                            workoutData["moveCount"] += 1;
                          }
                        });
                        workoutData["moveCount"] =
                            workoutData["moveCount"].toString();
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          if (oldData == null) {
                            await Provider.of<WorkoutProvider>(
                              context,
                              listen: false,
                            ).createWorkout(workoutData);
                            showSnackbar(
                              "Successfully added!",
                              error: false,
                            );
                          } else {
                            await Provider.of<WorkoutProvider>(
                              context,
                              listen: false,
                            ).updateWorkout(
                                oldData["workoutId"].toString(), workoutData);
                            showSnackbar(
                              "Successfully updated!",
                              error: false,
                            );
                          }
                          Navigator.of(context).pop();
                        } on HttpException catch (error) {
                          showSnackbar(error.toString());
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }

                      return Form(
                          key: formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  initialValue: workoutData["workoutName"],
                                  decoration: const InputDecoration(
                                    labelText: 'Workout Name',
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
                                    workoutData["workoutName"] = value;
                                  },
                                ),
                                TextFormField(
                                  initialValue:
                                      workoutData["workoutDescription"],
                                  decoration: const InputDecoration(
                                    labelText: 'Workout Description',
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
                                    workoutData["workoutDescription"] = value;
                                  },
                                ),
                                TextFormField(
                                  initialValue: workoutData["workoutDuration"],
                                  decoration: const InputDecoration(
                                    labelText: 'Workout Duration',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Invalid name!';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    workoutData["workoutDuration"] = value;
                                  },
                                ),
                                TextFormField(
                                  initialValue:
                                      workoutData["workoutDifficulty"],
                                  decoration: const InputDecoration(
                                    labelText: 'Workout Difficulty',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Invalid name!';
                                    }
                                    value = value.toLowerCase();
                                    if (value != "hard" &&
                                        value != "medium" &&
                                        value != "easy") {
                                      return "Difficulty must be one of the following: hard, medium, easy";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    workoutData["workoutDifficulty"] = value;
                                  },
                                ),
                                ...moves.keys.map((e) => SizedBox(
                                      width: 400,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CheckboxListTile(
                                              title: Text(e),
                                              value: moveSelected[e],
                                              onChanged: (value) {
                                                setState(() {
                                                  moveSelected[e] =
                                                      value ?? false;
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                initialValue: moveSets[e] ==
                                                        null
                                                    ? ""
                                                    : moveSets[e].toString(),
                                                enabled: moveSelected[e],
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Sets',
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (String? value) {
                                                  if (moveSelected[e]!) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Empty !';
                                                    }
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  moveSets[e] =
                                                      (value == null ||
                                                              value.isEmpty)
                                                          ? 0
                                                          : int.parse(value);
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                initialValue: moveReps[e] ==
                                                        null
                                                    ? ""
                                                    : moveReps[e].toString(),
                                                enabled: moveSelected[e],
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Repeats',
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (String? value) {
                                                  if (moveSelected[e]!) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Empty !';
                                                    }
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  moveReps[e] =
                                                      (value == null ||
                                                              value.isEmpty)
                                                          ? 0
                                                          : int.parse(value);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                isLoading
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        onPressed: submit,
                                        child: Text(
                                          oldData == null ? "Create" : "Change",
                                        ),
                                      )
                              ],
                            ),
                          ));
                    })));
              },
            ))
        .catchError((err) => showSnackbar(err.toString()));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: const CustomAppBarContent(),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<WorkoutProvider>(
                builder: (ctx, workouts, _) => Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        ...workouts.items.map(
                          (e) => SizedBox(
                            key: ObjectKey(e["workoutId"]),
                            width: screenSize.width * 0.9,
                            child: Card(
                              elevation: 12,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              color: getColorBasedOnDifficulty(
                                  e["workoutDifficulty"]),
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: ExpansionTile(
                                  textColor: Colors.white,
                                  title: Text(e["workoutName"]),
                                  subtitle: Text(e["workoutDescription"]),
                                  childrenPadding: const EdgeInsets.all(10),
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: const [
                                          Flexible(
                                            child: Center(
                                              child: Text("Moves"),
                                            ),
                                          ),
                                          Flexible(
                                            child: Center(
                                              child: Text("Sets"),
                                            ),
                                          ),
                                          Flexible(
                                            child: Center(
                                              child: Text("Repeats"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ...e["moves"].map(
                                      (move) => Row(
                                        children: [
                                          Flexible(
                                            child: Center(
                                              child:
                                                  Text(move["workoutMoveName"]),
                                            ),
                                          ),
                                          Flexible(
                                            child: Center(
                                              child:
                                                  Text(move["sets"].toString()),
                                            ),
                                          ),
                                          Flexible(
                                            child: Center(
                                              child: Text(
                                                  move["repeats"].toString()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: IconWithTextElevatedButton(
                                            text: "Edit",
                                            icon: Icons.edit,
                                            callback: () {
                                              return showCreationPopUpMenu(
                                                  oldData: e);
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: IconWithTextElevatedButton(
                                            text: "Remove",
                                            icon: Icons.delete,
                                            callback: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: Text(
                                                      "Remove ${e["workoutName"]}"),
                                                  content: const Text(
                                                      "Are you sure you want to delete this workout?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        try {
                                                          await workouts
                                                              .removeWorkout(
                                                            e["workoutId"]
                                                                .toString(),
                                                          );
                                                          showSnackbar(
                                                            "Successfully Removed",
                                                            error: false,
                                                          );
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
                                                          Navigator.of(ctx)
                                                              .pop(),
                                                      child: const Text("No"),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCreationPopUpMenu,
        child: const Icon(Icons.add),
      ),
    );
  }
}
