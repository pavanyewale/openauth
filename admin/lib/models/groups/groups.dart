class GroupDetails {
  int id;
  String name;
  String description;
  int createdByUser;
  int createdOn;
  int updatedOn;

  GroupDetails({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.createdByUser = 0,
    this.createdOn = 0,
    this.updatedOn = 0,
  });

  factory GroupDetails.fromJson(Map<String, dynamic> json) {
    return GroupDetails(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdByUser: json['createdByUser'],
      createdOn: json['createdOn'],
      updatedOn: json['updatedOn'],
    );
  }

  Map<String, dynamic> toCreateUpdateGroupRequest() {
    return {'id': id, 'name': name, 'description': description};
  }
}

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
