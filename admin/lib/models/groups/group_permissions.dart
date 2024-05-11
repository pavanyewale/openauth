import 'package:admin/models/permissions/permissions.dart';

class GetGroupPermissionsResponse {
  final List<PermissionDetails> permissions;
  final String error = '';

  GetGroupPermissionsResponse({
    this.permissions = const [],
    error = '',
  });

  factory GetGroupPermissionsResponse.fromSuccessJson(
      Map<String, dynamic> json) {
    return GetGroupPermissionsResponse(
      permissions: (json['data'] as List)
          .map((groupPermission) => PermissionDetails.fromJson(groupPermission))
          .toList(),
    );
  }

  factory GetGroupPermissionsResponse.fromErrorJson(Map<String, dynamic> json) {
    return GetGroupPermissionsResponse(
      error: json['error'],
    );
  }
}

class AddPermissionsToGroupRequest {
  final int groupId;
  final List<int> permissionIds;

  AddPermissionsToGroupRequest({
    required this.groupId,
    required this.permissionIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'permission_ids': permissionIds,
    };
  }
}
