class PermissionDetails {
  int id;
  String name;
  String description;
  int createdByUser;
  int createdOn;
  int updatedOn;

  PermissionDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.createdByUser,
    required this.createdOn,
    required this.updatedOn,
  });

  factory PermissionDetails.fromJson(Map<String, dynamic> json) {
    return PermissionDetails(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdByUser: json['createdByUser'],
      createdOn: json['createdOn'],
      updatedOn: json['updatedOn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdByUser': createdByUser,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }
}

class GetPermissionsResponse {
  List<PermissionDetails> permissions;
  String error;

  GetPermissionsResponse({this.error = '', this.permissions = const []});

  factory GetPermissionsResponse.fromSuccessJson(Map<String, dynamic> json) {
    return GetPermissionsResponse(
      permissions: (json['permissions'] as List)
          .map((i) => PermissionDetails.fromJson(i))
          .toList(),
    );
  }
  factory GetPermissionsResponse.fromErrorJson(Map<String, dynamic> json) {
    return GetPermissionsResponse(
      permissions: json['error'],
    );
  }
}
