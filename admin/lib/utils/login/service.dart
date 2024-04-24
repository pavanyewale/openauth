import 'dart:convert';

import 'package:admin/utils/base_url.dart';
import 'package:admin/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginService extends ChangeNotifier {
  bool isLoggedIn = false;
  String authToken = "";

  // Private constructor to prevent instantiation from outside
  LoginService._();

  // Singleton instance variable
  static final LoginService _instance = LoginService._();

  // Getter to access the singleton instance
  static LoginService get instance => _instance;

  loadAuthTokenFromLocal() async {
    if (authToken.isNotEmpty) {
      return;
    }

    authToken = (await LocalStorage().getString("authToken")) ?? '';
    if (authToken.isNotEmpty) {
      isLoggedIn = true;
    }
  }

  _saveAuthToken(String value) async {
    LocalStorage storage = LocalStorage();
    storage.setString('authToken', value);
    authToken = value;
    isLoggedIn = true;
    if (authToken.isEmpty) {
      isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<LoginResponse> login(LoginRequest request) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse('$baseUrl/openauth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final res = LoginResponse.fromSuccessJson(json.decode(response.body));
        _saveAuthToken(res.token);
        return res;
      } else {
        return LoginResponse.fromErrorJson(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return LoginResponse(
          userId: 0, token: "", message: "", error: "something went wrong!");
    }
  }

  Future<LogoutResponse> logout() async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse('$baseUrl/openauth/logout');

    try {
      final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': authToken
        },
      );

      if (response.statusCode == 200) {
        final res = LogoutResponse.fromSuccessJson(json.decode(response.body));
        _saveAuthToken("");
        return res;
      } else {
        return LogoutResponse.fromErrorJson(json.decode(response.body));
      }
    } catch (e) {
      return LogoutResponse(message: "", error: "something went wrong!");
    }
  }
}

// login

class LoginRequest {
  String deviceDetails;
  String otp;
  String password;
  bool permissions;
  String username;

  LoginRequest({
    required this.deviceDetails,
    required this.otp,
    required this.password,
    required this.permissions,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceDetails'] = deviceDetails;
    data['otp'] = otp;
    data['password'] = password;
    data['permissions'] = permissions;
    data['username'] = username;
    return data;
  }
}

class LoginResponse {
  int userId;
  String token;
  String message;
  String error;

  LoginResponse(
      {required this.userId,
      required this.token,
      required this.message,
      required this.error});

  factory LoginResponse.fromSuccessJson(Map<String, dynamic> json) {
    return LoginResponse(
        userId: json['userId'],
        token: json['token'],
        message: json['message'],
        error: "");
  }

  factory LoginResponse.fromErrorJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: 0,
      token: "",
      message: "",
      error: json['error'],
    );
  }
}

// logout

class LogoutResponse {
  String message;
  String error;

  LogoutResponse({required this.message, required this.error});
  factory LogoutResponse.fromSuccessJson(Map<String, dynamic> json) {
    return LogoutResponse(message: json['message'], error: "");
  }

  factory LogoutResponse.fromErrorJson(Map<String, dynamic> json) {
    return LogoutResponse(
      message: "",
      error: json['error'],
    );
  }
}
