import 'package:admin/models/groups/groups.dart';

class CreateUpdateGroupResponse {
  final GroupDetails groupDetails;
  final String error;
  final int code;

  CreateUpdateGroupResponse({
    required this.groupDetails,
    this.error = '',
    required this.code,
  });

  factory CreateUpdateGroupResponse.fromSuccessJson(Map<String, dynamic> json) {
    return CreateUpdateGroupResponse(
      groupDetails: GroupDetails.fromJson(json['data']),
      code: json['code'],
    );
  }

  factory CreateUpdateGroupResponse.fromErrorJson(Map<String, dynamic> json) {
    return CreateUpdateGroupResponse(
      groupDetails: GroupDetails(),
      error: json['error'],
      code: json['code'],
    );
  }
}
