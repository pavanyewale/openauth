class LoginRequest {
  String deviceDetails;
  String otp;
  String password;
  bool permissions;
  String username;
  bool sendOtp = false;

  LoginRequest({
    required this.deviceDetails,
    required this.otp,
    required this.password,
    required this.permissions,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceDetails'] = deviceDetails;
    data['otp'] = otp;
    data['password'] = password;
    data['permissions'] = permissions;
    data['username'] = username;
    return data;
  }
}

class LoginResponse {
  int userId;
  String token;
  String message;
  String error;

  bool get hasError => error.isNotEmpty;

  LoginResponse(
      {required this.userId,
      required this.token,
      required this.message,
      required this.error});

  factory LoginResponse.fromSuccessJson(Map<String, dynamic> json) {
    json = json['data'];
    return LoginResponse(
        userId: json['userId'],
        token: json['token'],
        message: json['message'],
        error: "");
  }

  factory LoginResponse.fromErrorJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: 0,
      token: "",
      message: "",
      error: json['error'],
    );
  }
}
