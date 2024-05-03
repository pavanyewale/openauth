/*
{
  "code": 200,
  "data": {
    "id": 1,
    "firstName": "Admin",
    "middleName": "",
    "lastName": "User",
    "username": "admin",
    "bio": "",
    "mobile": "",
    "email": "",
    "mobileVerified": false,
    "emailVerified": false,
    "createdBy": 1,
    "createdOn": 0,
    "updatedOn": 0,
    "deleted": false
  }
}
 */

class UserDetails {
  int id;
  String firstName;
  String middleName;
  String lastName;
  String username;
  String bio;
  String mobile;
  String email;
  bool mobileVerified;
  bool emailVerified;
  int createdBy;
  int createdOn;
  int updatedOn;
  bool deleted;

  UserDetails({
    this.id = 0,
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.username = '',
    this.bio = '',
    this.mobile = '',
    this.email = '',
    this.mobileVerified = false,
    this.emailVerified = false,
    this.createdBy = 0,
    this.createdOn = 0,
    this.updatedOn = 0,
    this.deleted = false,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      username: json['username'],
      bio: json['bio'],
      mobile: json['mobile'],
      email: json['email'],
      mobileVerified: json['mobileVerified'],
      emailVerified: json['emailVerified'],
      createdBy: json['createdBy'],
      createdOn: json['createdOn'],
      updatedOn: json['updatedOn'],
      deleted: json['deleted'],
    );
  }
}

class GetUserResponse {
  final int code;
  final UserDetails? data;
  final String error;

  GetUserResponse({
    required this.code,
    this.data,
    this.error = '',
  });

  factory GetUserResponse.fromSuccessJson(Map<String, dynamic> json) {
    return GetUserResponse(
      code: json['code'],
      data: UserDetails.fromJson(json['data']),
    );
  }

  factory GetUserResponse.fromErrorJson(Map<String, dynamic> json) {
    return GetUserResponse(
      code: json['code'],
      error: json['error'],
      data: UserDetails(
        id: 0,
        firstName: '',
        middleName: '',
        lastName: '',
        username: '',
        bio: '',
        mobile: '',
        email: '',
        mobileVerified: false,
        emailVerified: false,
        createdBy: 0,
        createdOn: 0,
        updatedOn: 0,
        deleted: false,
      ),
    );
  }
}
