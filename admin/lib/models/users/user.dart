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
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String username;
  final String bio;
  final String mobile;
  final String email;
  final bool mobileVerified;
  final bool emailVerified;
  final int createdBy;
  final int createdOn;
  final int updatedOn;
  final bool deleted;

  UserDetails({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.username,
    required this.bio,
    required this.mobile,
    required this.email,
    required this.mobileVerified,
    required this.emailVerified,
    required this.createdBy,
    required this.createdOn,
    required this.updatedOn,
    required this.deleted,
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
  final UserDetails data;
  final String error;

  GetUserResponse({
    required this.code,
    required this.data,
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
