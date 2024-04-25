import 'dart:convert';

import 'package:admin/utils/base_url.dart';
import 'package:admin/utils/local_storage.dart';
import 'package:admin/utils/login/api_structs/login.dart';
import 'package:admin/utils/login/api_structs/logout.dart';
import 'package:admin/utils/login/user_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';


class LoginService extends ChangeNotifier {
  bool isLoggedIn = false;
  String authToken = "";
  User user = User(userId: 0, username: "", firstName: "", lastName: "", permissions: []) ;
  // Private constructor to prevent instantiation from outside
  LoginService._();

  // Singleton instance variable
  static final LoginService _instance = LoginService._();

  // Getter to access the singleton instance
  static LoginService get instance => _instance;

  updateUser(String token){
     Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
     user = User.fromJson( jsonDecode( decodedToken["userDetails"]));
  }

  loadAuthTokenFromLocal() async {
    if (authToken.isNotEmpty) {
      return;
    }

    authToken = (await LocalStorage().getString("authToken")) ?? '';
    if (authToken.isNotEmpty) {
      isLoggedIn = true;
      updateUser(authToken);
    }
  }

  _saveAuthToken(String value) async {
    LocalStorage storage = LocalStorage();
    storage.setString('authToken', value);
    authToken = value;
    isLoggedIn = true;
    if (authToken.isEmpty) {
      isLoggedIn = false;
    }else{
      updateUser(authToken);
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
