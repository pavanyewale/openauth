import 'dart:convert';

import 'package:admin/models/users/delete.dart';
import 'package:admin/models/users/users.dart';
import 'package:admin/utils/base_url.dart';
import 'package:admin/utils/widgets/login/service.dart';
import 'package:http/http.dart' as http;

class UsersService {
  static Future<GetUsersResponse> getUsers(
      GetUsersFilters filters, int offset, int limit) async {
    final baseUrl = BaseURL.instance.baseURL;
    Uri url = Uri.parse(
        '$baseUrl/openauth/user?offset=$offset&limit=$limit&email=${filters.email}&mobile=${filters.mobile}&userId=${filters.userId}&username=${filters.username}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': LoginService.instance.authToken
        },
      );

      if (response.statusCode == 200) {
        return GetUsersResponse.fromSuccessJson(json.decode(response.body));
      } else {
        return GetUsersResponse.fromErrorJson(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return GetUsersResponse(code: 500, error: "something went wrong!");
    }
  }

  static Future<DeleteUserResponse> deleteUser(int id) async {
    final baseUrl = BaseURL.instance.baseURL;
    Uri url = Uri.parse('$baseUrl/openauth/user/$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': LoginService.instance.authToken
        },
      );

      if (response.statusCode == 200) {
        return DeleteUserResponse.fromSuccessJson(json.decode(response.body));
      } else {
        return DeleteUserResponse.fromErrorJson(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return DeleteUserResponse(code: 500, error: "something went wrong!");
    }
  }

  static Future<GetUsersResponse> getUser(int id) async {
    final baseUrl = BaseURL.instance.baseURL;
    Uri url = Uri.parse('$baseUrl/openauth/user/$id');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': LoginService.instance.authToken
        },
      );

      if (response.statusCode == 200) {
        return GetUsersResponse.fromSuccessJson(json.decode(response.body));
      } else {
        return GetUsersResponse.fromErrorJson(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return GetUsersResponse(code: 500, error: "something went wrong!");
    }
  }
}
