import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:web_app/models/http_exception.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  int? _userId;
  Timer? _logOutTimer;

  String? get token {
    if (_userId != null &&
        _token != null &&
        _expireDate != null &&
        _expireDate!.isAfter(DateTime.now().toUtc())) {
      return _token;
    }
    return null;
  }

  DateTime? get expireDate {
    return _expireDate;
  }

  int? get userId {
    return _userId;
  }

  bool get isAuthenticated {
    return token != null;
  }

  // Future<void> signUp(String email, String password) async {
  //   return this._authenticate(email, password, "signUp");
  // }

  Future<void> _authenticate(
      Map<String, String> params, String urlSegment) async {
    final url =
        "https://684ezlnsfa.execute-api.eu-central-1.amazonaws.com/Prod/$urlSegment";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            "mail": params["mail"],
            "password": params["password"],
          },
        ),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"][0]);
      }

      _token = responseData["data"]["token"];
      _expireDate = DateTime.parse(responseData["data"]["exp_date"] + 'Z');
      _userId = responseData["data"]["id"];

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void logOut() {
    _token = null;
    _expireDate = null;
    _userId = null;
    if (_logOutTimer != null) {
      _logOutTimer!.cancel();
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    return _authenticate(
      {
        "mail": email,
        "password": password,
      },
      "admin/login",
    );
  }
}
