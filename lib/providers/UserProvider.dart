import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:web_app/models/http_exception.dart';

class UserProvider extends ChangeNotifier {
  String? _token;
  int? _userId;
  List<dynamic>? _items;

  UserProvider(this._token, this._userId, this._items);

  UnmodifiableListView<dynamic> get items =>
      UnmodifiableListView(_items == null ? [] : _items!);

  Future<Map<String, int>> fetchStatistics() async {
    const url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/history";

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

      List data = responseData["data"];
      int loginCount = 0;
      int finishCount = 0;

      data.forEach(
        (element) {
          if (element["logType"] == "login") {
            loginCount += element["count"] as int;
          } else if (element["logType"] == "workoutFinish") {
            finishCount += element["count"] as int;
          }
        },
      );

      return {"login": loginCount, "workout": finishCount};
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchUsers() async {
    const url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/user";

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

      var list = responseData["data"];

      _items = list.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    var url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/user/create";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(userData),
        headers: {
          "Authorization": _token!,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      await fetchUsers();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateUser(Map<String, dynamic> userData) async {
    var url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/user/update";

    if (userData["password"] == null || userData["password"].isEmpty) {
      userData.remove("password");
    }

    print(userData);

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(userData),
        headers: {
          "Authorization": _token!,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      await fetchUsers();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeUser(String id) async {
    var url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/user/remove/${id}";

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

      await fetchUsers();
    } catch (error) {
      rethrow;
    }
  }
}
