class GroupDetails {
  final int id;
  final String name;
  final String description;
  final int createdByUser;
  final int createdOn;
  final int updatedOn;

  GroupDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.createdByUser,
    required this.createdOn,
    required this.updatedOn,
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
