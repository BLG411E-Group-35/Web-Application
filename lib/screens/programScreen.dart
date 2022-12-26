import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app/providers/WorkoutProvider.dart';
import 'package:web_app/widgets/appBar.dart';
import 'package:web_app/widgets/buttons.dart';

import '../themes/customTheme.dart';

class Programs extends StatefulWidget {
  static const routeName = "/programs";
  const Programs({super.key});

  @override
  State<Programs> createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  bool _isInit = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<WorkoutProvider>(context).fetchWorkouts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = true;
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: const CustomAppBarContent(),
      ),
      body: SingleChildScrollView(
        child: _isLoading
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
                                            callback: () => {},
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
                                                  title: const Text("Error"),
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
                                                        } catch (err) {
                                                          print(err);
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                err.toString(),
                                                              ),
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .error,
                                                            ),
                                                          );
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
