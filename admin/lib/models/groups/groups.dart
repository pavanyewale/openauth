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
