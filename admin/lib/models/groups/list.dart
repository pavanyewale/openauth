import 'package:admin/models/groups/groups.dart';

class GetGroupsResponse {
  final List<GroupDetails> groups;
  final String error;
  final int code;

  GetGroupsResponse({
    this.groups = const [],
    this.error = '',
    required this.code,
  });

  //fromSuccessJson
  factory GetGroupsResponse.fromSuccessJson(Map<String, dynamic> json) {
    return GetGroupsResponse(
      groups: List<GroupDetails>.from(
          json['data'].map((x) => GroupDetails.fromJson(x))),
      error: '',
      code: json['code'],
    );
  }

  //fromErrorJson
  factory GetGroupsResponse.fromErrorJson(Map<String, dynamic> json) {
    return GetGroupsResponse(
      groups: [],
      error: json['error'],
      code: json['code'],
    );
  }
}
