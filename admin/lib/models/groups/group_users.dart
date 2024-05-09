import 'package:admin/models/users/users.dart';

class GetUsersOfGroupResponse {
  List<ShortUserDetails> users;
  String error;
  int code;

  GetUsersOfGroupResponse({
    this.users = const [],
    this.error = '',
    required this.code,
  });

  factory GetUsersOfGroupResponse.fromSuccessJson(Map<String, dynamic> json) {
    return GetUsersOfGroupResponse(
      users: List<ShortUserDetails>.from(
          json['data'].map((x) => ShortUserDetails.fromJson(x))),
      error: '',
      code: json['code'],
    );
  }

  factory GetUsersOfGroupResponse.fromErrorJson(Map<String, dynamic> json) {
    return GetUsersOfGroupResponse(
      users: [],
      error: json['error'],
      code: json['code'],
    );
  }
}

class AddUsersToGroupRequest {
  final int groupId;
  final List<int> userIds;

  AddUsersToGroupRequest({
    required this.groupId,
    required this.userIds,
  });

  Map<String, dynamic> toJson() {
    return {'groupId': groupId, 'userIds': userIds};
  }
}
