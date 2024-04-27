import 'dart:convert';
import 'package:admin/models/permissions.dart';
import 'package:admin/utils/base_url.dart';
import 'package:admin/utils/widgets/login/service.dart';
import 'package:http/http.dart' as http;

class PermissionService {
  PermissionService._privateConstructor();
  static final PermissionService instance =
      PermissionService._privateConstructor();

  Future<GetPermissionsResponse> getPermissions(int offset, int limit) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url =
        Uri.parse('$baseUrl/openauth/permissions?offset=$offset&limit=$limit');
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
        return GetPermissionsResponse.fromSuccessJson(
            json.decode(response.body));
      } else {
        return GetPermissionsResponse.fromErrorJson(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return GetPermissionsResponse(error: "something went wrong!");
    }
  }

  Future<UpdatePermissionResponse> createPermission(
      PermissionDetails perm) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse('$baseUrl/openauth/permissions');
    try {
      final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': LoginService.instance.authToken
        },
        body: json.encode({
          {"description": perm.description, "name": perm.name}
        }),
      );

      if (response.statusCode == 200) {
        return UpdatePermissionResponse.fromSuccessJson(
            json.decode(response.body));
      } else {
        return UpdatePermissionResponse.fromErrorJson(
            json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return UpdatePermissionResponse(error: "something went wrong!");
    }
  }

  //delete permission
  Future<UpdatePermissionResponse> deletePermission(int permissionId) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse('$baseUrl/openauth/permissions');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': LoginService.instance.authToken
        },
        body: json.encode({'permId': permissionId}),
      );

      if (response.statusCode == 200) {
        return UpdatePermissionResponse.fromSuccessJson(
            json.decode(response.body));
      } else {
        return UpdatePermissionResponse.fromErrorJson(
            json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return UpdatePermissionResponse(error: "something went wrong!");
    }
  }
}
