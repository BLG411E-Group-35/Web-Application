import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:web_app/models/http_exception.dart';

class WorkoutProvider extends ChangeNotifier {
  String? _token;
  int? _userId;
  List<dynamic>? _items;
  List<dynamic>? _moves;

  WorkoutProvider(this._token, this._userId, this._items);

  UnmodifiableListView<dynamic> get items =>
      UnmodifiableListView(_items == null ? [] : _items!);

  UnmodifiableListView<dynamic> get moves =>
      UnmodifiableListView(_moves == null ? [] : _moves!);

  Future<void> fetchWorkouts() async {
    const url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/workout";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": _token!,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      Map<String, dynamic> workouts = {};
      var list = responseData["data"];

      // TODO: Retrieve each workout's move list only if user clicks
      for (var element in list) {
        var key = element["workoutId"].toString();
        if (workouts.containsKey(key)) {
          workouts[key]["moves"].add(
            {
              "workoutMoveName": element["workoutMoveName"],
              "moveId": element["moveId"],
              "order": element["order"],
              "sets": element["set"],
              "repeats": element["repeat"],
            },
          );
        } else {
          workouts[key] = {
            "workoutId": element["workoutId"],
            "workoutName": element["workoutName"],
            "moveCount": element["moveCount"],
            "workoutDescription": element["workoutDescription"],
            "workoutDuration": element["workoutDuration"],
            "workoutDifficulty": element["workoutDifficulty"],
            "moves": [
              {
                "workoutMoveName": element["workoutMoveName"],
                "moveId": element["moveId"],
                "order": element["order"],
                "sets": element["set"],
                "repeats": element["repeat"],
              },
            ],
          };
        }
      }

      _items = workouts.values.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<dynamic, dynamic>> fetchMoves() async {
    var url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/move";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": _token!,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      var data = responseData["data"] as List<dynamic>;
      var moves = {};

      data.forEach((element) {
        moves[element["workoutMoveName"]] = element["workoutMoveId"];
      });

      return moves;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchMovesFull() async {
    var url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/move";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": _token!,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      Map<String, dynamic> exercises = {};
      var data = responseData["data"] as List<dynamic>;

      data.forEach((element) {
        if (exercises.containsKey(element["workoutMoveId"].toString())) {
          exercises[element["workoutMoveId"].toString()]["steps"].add(
            {
              "workoutStepId": element["workoutStepId"],
              "difficulty": element["difficulty"],
              "order": element["order"],
              "stepCoordinates": {
                "stepCoordinatesId": element["stepCoordinatesId"],
                "x_nose": element["x_nose"],
                "x_leftEye": element["x_leftEye"],
                "x_rightEye": element["x_rightEye"],
                "x_leftEar": element["x_leftEar"],
                "x_rightEar": element["x_rightEar"],
                "x_leftShoulder": element["x_leftShoulder"],
                "x_rightShoulder": element["x_rightShoulder"],
                "x_leftElbow": element["x_leftElbow"],
                "x_rightElbow": element["x_rightElbow"],
                "x_leftWrist": element["x_leftWrist"],
                "x_rightWrist": element["x_rightWrist"],
                "x_leftHip": element["x_leftHip"],
                "x_rightHip": element["x_rightHip"],
                "x_leftKnee": element["x_leftKnee"],
                "x_rightKnee": element["x_rightKnee"],
                "x_leftAnkle": element["x_leftAnkle"],
                "x_rightAnkle": element["x_rightAnkle"],
                "y_nose": element["y_nose"],
                "y_leftEye": element["y_leftEye"],
                "y_rightEye": element["y_rightEye"],
                "y_leftEar": element["y_leftEar"],
                "y_rightEar": element["y_rightEar"],
                "y_leftShoulder": element["y_leftShoulder"],
                "y_rightShoulder": element["y_rightShoulder"],
                "y_leftElbow": element["y_leftElbow"],
                "y_rightElbow": element["y_rightElbow"],
                "y_leftWrist": element["y_leftWrist"],
                "y_rightWrist": element["y_rightWrist"],
                "y_leftHip": element["y_leftHip"],
                "y_rightHip": element["y_rightHip"],
                "y_leftKnee": element["y_leftKnee"],
                "y_rightKnee": element["y_rightKnee"],
                "y_leftAnkle": element["y_leftAnkle"],
                "y_rightAnkle": element["y_rightAnkle"],
                "image_width": element["image_width"],
                "image_height": element["image_height"],
              },
            },
          );
        } else {
          exercises[element["workoutMoveId"].toString()] = {
            "workoutMoveId": element["workoutMoveId"],
            "workoutMoveName": element["workoutMoveName"],
            "stepCount": element["stepCount"],
            "steps": [
              {
                "workoutStepId": element["workoutStepId"],
                "difficulty": element["difficulty"],
                "order": element["order"],
                "stepCoordinates": {
                  "stepCoordinatesId": element["stepCoordinatesId"],
                  "x_nose": element["x_nose"],
                  "x_leftEye": element["x_leftEye"],
                  "x_rightEye": element["x_rightEye"],
                  "x_leftEar": element["x_leftEar"],
                  "x_rightEar": element["x_rightEar"],
                  "x_leftShoulder": element["x_leftShoulder"],
                  "x_rightShoulder": element["x_rightShoulder"],
                  "x_leftElbow": element["x_leftElbow"],
                  "x_rightElbow": element["x_rightElbow"],
                  "x_leftWrist": element["x_leftWrist"],
                  "x_rightWrist": element["x_rightWrist"],
                  "x_leftHip": element["x_leftHip"],
                  "x_rightHip": element["x_rightHip"],
                  "x_leftKnee": element["x_leftKnee"],
                  "x_rightKnee": element["x_rightKnee"],
                  "x_leftAnkle": element["x_leftAnkle"],
                  "x_rightAnkle": element["x_rightAnkle"],
                  "y_nose": element["y_nose"],
                  "y_leftEye": element["y_leftEye"],
                  "y_rightEye": element["y_rightEye"],
                  "y_leftEar": element["y_leftEar"],
                  "y_rightEar": element["y_rightEar"],
                  "y_leftShoulder": element["y_leftShoulder"],
                  "y_rightShoulder": element["y_rightShoulder"],
                  "y_leftElbow": element["y_leftElbow"],
                  "y_rightElbow": element["y_rightElbow"],
                  "y_leftWrist": element["y_leftWrist"],
                  "y_rightWrist": element["y_rightWrist"],
                  "y_leftHip": element["y_leftHip"],
                  "y_rightHip": element["y_rightHip"],
                  "y_leftKnee": element["y_leftKnee"],
                  "y_rightKnee": element["y_rightKnee"],
                  "y_leftAnkle": element["y_leftAnkle"],
                  "y_rightAnkle": element["y_rightAnkle"],
                  "image_width": element["image_width"],
                  "image_height": element["image_height"],
                },
              },
            ]
          };
        }
      });
      _moves = exercises.values.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createWorkout(Map<String, dynamic> workoutData) async {
    var url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/workout/create";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(workoutData),
        headers: {
          "Authorization": _token!,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      // if (_items != null) {
      //   _items!.add(workoutData);
      // } else {
      //   _items = [workoutData];
      // }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateWorkout(
      String id, Map<String, dynamic> workoutData) async {
    var url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/workout/remove/$id";

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": _token!,
        },
      );

      var responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      url =
          "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/workout/create";
      response = await http.post(
        Uri.parse(url),
        body: json.encode(workoutData),
        headers: {
          "Authorization": _token!,
        },
      );

      responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      await fetchWorkouts();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeWorkout(String id) async {
    var url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/workout/remove/${id}";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": _token!,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      // _items!.forEach((item) {
      //   if (item["workoutId"] == id) {
      //     _items!.remove(item);
      //   }
      // });

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeMove(String id) async {
    var url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/move/remove/${id}";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": _token!,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addMove(List<Map<String, dynamic>> steps, String name) async {
    Map<String, dynamic> body = {
      "name": name,
      "steps": steps,
    };

    print(body);

    var url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/move/create";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: {
          "Authorization": _token!,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
