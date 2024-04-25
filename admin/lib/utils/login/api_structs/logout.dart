class LogoutResponse {
  String message;
  String error;

  LogoutResponse({required this.message, required this.error});
  factory LogoutResponse.fromSuccessJson(Map<String, dynamic> json) {
    return LogoutResponse(message: json['message'], error: "");
  }

  factory LogoutResponse.fromErrorJson(Map<String, dynamic> json) {
    return LogoutResponse(
      message: "",
      error: json['error'],
    );
  }
}
