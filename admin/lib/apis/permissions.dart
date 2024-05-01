import 'dart:convert';
import 'package:admin/models/permissions/filters.dart';
import 'package:admin/models/permissions/permissions.dart';
import 'package:admin/utils/base_url.dart';
import 'package:admin/utils/widgets/login/service.dart';
import 'package:http/http.dart' as http;

class PermissionService {
  static Future<GetPermissionsResponse> getPermissions(
      PermissionsFilters filters, int offset, int limit) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse(
        '$baseUrl/openauth/permissions?offset=$offset&limit=$limit&name=${filters.name ?? ''}&category=${filters.category ?? ''}');
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
      return GetPermissionsResponse(error: "something went wrong!");
    }
  }

  static Future<UpdatePermissionResponse> createPermission(
      PermissionDetails perm) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse('$baseUrl/openauth/permissions');
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = perm.name;
    data['category'] = perm.category;
    data['description'] = perm.description;
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': LoginService.instance.authToken
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UpdatePermissionResponse.fromSuccessJson(
            json.decode(response.body));
      } else {
        return UpdatePermissionResponse.fromErrorJson(
            json.decode(response.body));
      }
    } catch (e) {
      return UpdatePermissionResponse(error: "something went wrong!");
    }
  }

  //delete permission
  static Future<UpdatePermissionResponse> deletePermission(
      int permissionId) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse('$baseUrl/openauth/permissions');
    final Map<String, dynamic> data = <String, dynamic>{};
    data['permId'] = permissionId;
    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': LoginService.instance.authToken
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return UpdatePermissionResponse.fromSuccessJson(
            json.decode(response.body));
      } else {
        return UpdatePermissionResponse.fromErrorJson(
            json.decode(response.body));
      }
    } catch (e) {
      return UpdatePermissionResponse(error: "something went wrong!");
    }
  }
}
