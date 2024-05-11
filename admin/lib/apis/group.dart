import 'dart:convert';
import 'package:admin/models/groups/create_update.dart';
import 'package:admin/models/groups/filters.dart';
import 'package:admin/models/groups/group_users.dart';
import 'package:admin/models/groups/list.dart';
import 'package:admin/models/groups/groups.dart';
import 'package:admin/models/permissions/permissions.dart';
import 'package:admin/utils/base_url.dart';
import 'package:admin/utils/widgets/login/service.dart';
import 'package:http/http.dart' as http;

class GroupService {
  static Future<GetGroupsResponse> getGroups(
      GroupFilters filters, int limit, int offset) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse(
        '$baseUrl/openauth/group?offset=$offset&limit=$limit&name=${filters.name ?? ''}');
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
        return GetGroupsResponse.fromSuccessJson(json.decode(response.body));
      } else {
        return GetGroupsResponse.fromErrorJson(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return GetGroupsResponse(code: 500, error: "something went wrong!");
    }
  }

  static Future<CreateUpdateGroupResponse> createUpdateGroup(
      GroupDetails groupDetails) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse('$baseUrl/openauth/group');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': LoginService.instance.authToken
        },
        body: json.encode(groupDetails.toCreateUpdateGroupRequest()),
      );

      if (response.statusCode == 200) {
        return CreateUpdateGroupResponse.fromSuccessJson(
            json.decode(response.body));
      } else {
        return CreateUpdateGroupResponse.fromErrorJson(
            json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return CreateUpdateGroupResponse(
          code: 500,
          error: "Something went wrong!",
          groupDetails: GroupDetails());
    }
  }

  static Future<String> deleteGroup(int id) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse('$baseUrl/openauth/group/$id');
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
        return "";
      } else {
        return json.decode(response.body)['error'];
      }
    } catch (e) {
      print(e);
      return "Something went wrong!";
    }
  }

  // group users

  static Future<GetUsersOfGroupResponse> getUsersOfGroup(int groupId) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse('$baseUrl/openauth/group/user?groupId=$groupId');
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
        return GetUsersOfGroupResponse.fromSuccessJson(
            json.decode(response.body));
      } else {
        return GetUsersOfGroupResponse.fromErrorJson(
            json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return GetUsersOfGroupResponse(code: 500, error: "something went wrong!");
    }
  }

  static Future<String> addUsersToGroup(
      AddUsersToGroupRequest addUsersToGroupRequest) async {
    if (addUsersToGroupRequest.userIds.isEmpty) {
      // no need to update
      return "";
    }
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse('$baseUrl/openauth/group/user');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': LoginService.instance.authToken
        },
        body: json.encode(addUsersToGroupRequest.toJson()),
      );

      if (response.statusCode == 200) {
        return "";
      } else {
        return json.decode(response.body)['error'];
      }
    } catch (e) {
      print(e);
      return "Something went wrong!";
    }
  }

  static Future<String> removeUserFromGroup(int groupId, int userID) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse('$baseUrl/openauth/group/user');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AuthToken': LoginService.instance.authToken,
        },
        body: json.encode({
          "groupId": groupId,
          "userIds": [userID],
        }),
      );

      if (response.statusCode == 200) {
        return "";
      } else {
        return json.decode(response.body)['error'];
      }
    } catch (e) {
      print(e);
      return "Something went wrong!";
    }
  }

  static savePermissions(int id, List<PermissionDetails> list) {}

  static getPermissions(int id) {}
}
