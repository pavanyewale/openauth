import 'dart:convert';
import 'package:admin/models/groups/groups.dart';
import 'package:admin/utils/base_url.dart';
import 'package:admin/utils/widgets/login/service.dart';
import 'package:http/http.dart' as http;

class GroupService {
  static Future<GetGroupsResponse> getGroups(int limit, int offset) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url =
        Uri.parse('$baseUrl/openauth/group?offset=$offset&limit=$limit');
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
}
