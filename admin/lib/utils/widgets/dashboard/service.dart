import 'dart:convert';

import 'package:admin/utils/base_url.dart';
import 'package:admin/utils/widgets/dashboard/models.dart';
import 'package:admin/utils/widgets/login/service.dart';
import 'package:http/http.dart' as http;

class DashboardService {
  static Future<DashboardResponse> getDashboardData() async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse('$baseUrl/openauth/dashboard');
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
        return DashboardResponse.fromSuccessJson(json.decode(response.body));
      } else {
        return DashboardResponse.fromErrorJson(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return DashboardResponse(code: 500, error: "something went wrong!");
    }
  }
}
