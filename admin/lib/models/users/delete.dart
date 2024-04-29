class DeleteUserResponse {
  final String message;
  final int code;
  final String error;

  DeleteUserResponse({
    this.message = '',
    required this.code,
    this.error = '',
  });

  factory DeleteUserResponse.fromSuccessJson(Map<String, dynamic> json) {
    return DeleteUserResponse(
      message: json['message'],
      code: json['code'],
    );
  }

  factory DeleteUserResponse.fromErrorJson(Map<String, dynamic> json) {
    return DeleteUserResponse(
      code: json['code'],
      error: json['error'],
    );
  }
}
