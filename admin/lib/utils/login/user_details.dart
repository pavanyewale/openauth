class User {
  int userId;
  String username;
  String firstName;
  String lastName;
  List<String> permissions;

  User({
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      permissions: List<String>.from(json['permissions']),
    );
  }
}