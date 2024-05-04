class ShortUserDetails {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String mobile;
  final String email;
  final int createdOn;
  final bool deleted;

  ShortUserDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.mobile,
    required this.email,
    required this.createdOn,
    required this.deleted,
  });

  factory ShortUserDetails.fromJson(Map<String, dynamic> json) {
    return ShortUserDetails(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      mobile: json['mobile'],
      email: json['email'],
      createdOn: json['createdOn'],
      deleted: json['deleted'],
    );
  }
}

class GetUsersResponse {
  final int code;
  final List<ShortUserDetails> data;
  final String error;

  GetUsersResponse({
    required this.code,
    this.data = const [],
    this.error = '',
  });

  factory GetUsersResponse.fromSuccessJson(Map<String, dynamic> json) {
    return GetUsersResponse(
      code: json['code'],
      data: List<ShortUserDetails>.from(
          json['data'].map((x) => ShortUserDetails.fromJson(x))),
    );
  }

  factory GetUsersResponse.fromErrorJson(Map<String, dynamic> json) {
    return GetUsersResponse(
      code: json['code'],
      error: json['error'],
    );
  }
}

// get users filters

class GetUsersFilters {
  int userId = 0;
  String username = '';
  String email = '';
  String mobile = '';

  String toQueryParams() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userId != 0) {
      data['userId'] = userId;
    }
    if (username.isNotEmpty) {
      data['username'] = username;
    }
    if (email.isNotEmpty) {
      data['email'] = email;
    }
    if (mobile.isNotEmpty) {
      data['mobile'] = mobile;
    }
    return data.toString(); // this is not correct
  }
}
