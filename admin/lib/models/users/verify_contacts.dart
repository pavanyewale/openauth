class VerifyContactsRequest {
  String email;
  String mobile;
  bool sendOtp;
  String username;

  VerifyContactsRequest({
    this.email = '',
    this.mobile = '',
    this.sendOtp = false,
    this.username = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'mobile': mobile,
      'sendOtp': sendOtp,
      'username': username,
    };
  }
}

class VerifyContactsResponse {
  String emailErr;
  String mobileErr;
  String usernameErr;
  int otpExpriry;

  String error;

  VerifyContactsResponse({
    this.emailErr = '',
    this.mobileErr = '',
    this.usernameErr = '',
    this.otpExpriry = 0,
    this.error = '',
  });

  factory VerifyContactsResponse.fromSuccessJson(Map<String, dynamic> json) {
    json = json['data'];
    return VerifyContactsResponse(
      emailErr: json['emailErr'],
      mobileErr: json['mobileErr'],
      usernameErr: json['usernameErr'],
      otpExpriry: json['otpExpriry'],
    );
  }

  factory VerifyContactsResponse.fromErrorJson(Map<String, dynamic> json) {
    return VerifyContactsResponse(
      error: json['error'],
    );
  }
}
