import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:web_app/models/http_exception.dart';

class WorkoutProvider extends ChangeNotifier {
  String? _token;
  int? _userId;
  List<dynamic>? _items;

  WorkoutProvider(this._token, this._userId, this._items);

  UnmodifiableListView<dynamic> get items =>
      UnmodifiableListView(_items == null ? [] : _items!);

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
        throw HttpException(responseData["message"][0]);
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

      print(workouts.values.toList());
      _items = workouts.values.toList();
      notifyListeners();
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

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
