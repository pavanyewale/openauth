import 'package:admin/models/users/user.dart';

class CreateUpdateUserRequest {
  String bio;
  String email;
  String emailOTP;
  String firstName;
  int id;
  String lastName;
  String middleName;
  String mobile;
  String mobileOTP;
  String username;

  CreateUpdateUserRequest({
    this.bio = '',
    this.email = '',
    this.emailOTP = '',
    this.firstName = '',
    this.id = 0,
    this.lastName = '',
    this.middleName = '',
    this.mobile = '',
    this.mobileOTP = '',
    this.username = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'email': email,
      'emailOTP': emailOTP,
      'firstName': firstName,
      'id': id,
      'lastName': lastName,
      'middleName': middleName,
      'mobile': mobile,
      'mobileOTP': mobileOTP,
      'username': username,
    };
  }
}

class CreateUpdateUserResponse {
  UserDetails? userDetails;
  String error;
  int code;

  CreateUpdateUserResponse({
    this.userDetails,
    this.error = '',
    this.code = 500,
  });

  factory CreateUpdateUserResponse.fromSuccessJson(Map<String, dynamic> json) {
    return CreateUpdateUserResponse(
      userDetails: UserDetails.fromJson(json['data']),
      code: json['code'],
    );
  }

  factory CreateUpdateUserResponse.fromErrorJson(Map<String, dynamic> json) {
    return CreateUpdateUserResponse(
      error: json['error'],
      code: json['code'],
    );
  }
}
