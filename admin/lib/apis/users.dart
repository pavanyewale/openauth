import 'dart:convert';

import 'package:admin/models/users/delete.dart';
import 'package:admin/models/users/edit_user.dart';
import 'package:admin/models/users/user.dart';
import 'package:admin/models/users/users.dart';
import 'package:admin/models/users/verify_contacts.dart';
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

  static Future<GetUserResponse> getUser(int id) async {
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
        return GetUserResponse.fromSuccessJson(json.decode(response.body));
      } else {
        return GetUserResponse.fromErrorJson(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return GetUserResponse(code: 500, error: "something went wrong!");
    }
  }

  static Future<VerifyContactsResponse> verifyContacts(
      VerifyContactsRequest request) async {
    final baseUrl = BaseURL.instance.baseURL;
    Uri url = Uri.parse('$baseUrl/openauth/user/verify');

    try {
      final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': LoginService.instance.authToken
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return VerifyContactsResponse.fromSuccessJson(
            json.decode(response.body));
      } else {
        return VerifyContactsResponse.fromErrorJson(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return VerifyContactsResponse(error: "something went wrong!");
    }
  }

  static Future<CreateUpdateUserResponse> createUpdateUser(
      CreateUpdateUserRequest req) async {
    final baseUrl = BaseURL.instance.baseURL;
    Uri url = Uri.parse('$baseUrl/openauth/user');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': LoginService.instance.authToken
        },
        body: json.encode(req.toJson()),
      );

      if (response.statusCode == 200) {
        return CreateUpdateUserResponse.fromSuccessJson(
            json.decode(response.body));
      } else {
        return CreateUpdateUserResponse.fromErrorJson(
            json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return CreateUpdateUserResponse(
          code: 500, error: "something went wrong!");
    }
  }

  static Future<String> undeleteUser(int id) async {
    final baseUrl = BaseURL.instance.baseURL;
    Uri url = Uri.parse('$baseUrl/openauth/user/undelete/$id');

    try {
      final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': LoginService.instance.authToken
        },
      );

      if (response.statusCode == 200) {
        return '';
      } else {
        return json.decode(response.body)['error'];
      }
    } catch (e) {
      print(e);
      return "something went wrong!";
    }
  }
}
