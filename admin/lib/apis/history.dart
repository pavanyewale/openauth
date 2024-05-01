import 'dart:convert';

import 'package:admin/models/history/filters.dart';
import 'package:admin/models/history/history.dart';
import 'package:admin/utils/base_url.dart';
import 'package:admin/utils/widgets/login/service.dart';
import 'package:http/http.dart' as http;

class HistoryService {
  static Future<GetHistoryResponse> getHistory(
      HistoryFilters filters, int limit, int offset) async {
    final baseUrl = BaseURL.instance.baseURL;
    final url = Uri.parse(
        '$baseUrl/openauth/history?offset=$offset&limit=$limit&startDate=${filters.startDate}&endDate=${filters.endDate}');
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
        return GetHistoryResponse.fromSuccessJson(json.decode(response.body));
      } else {
        return GetHistoryResponse.fromErrorJson(json.decode(response.body));
      }
    } catch (e) {
      return GetHistoryResponse(code: 500, error: "something went wrong!");
    }
  }
}
