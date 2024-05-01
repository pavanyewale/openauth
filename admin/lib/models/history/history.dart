class History {
  History({
    required this.id,
    required this.operation,
    required this.data,
    required this.createdByUser,
    required this.createdOn,
  });

  final int id;
  final String operation;
  final String data;
  final int createdByUser;
  final int createdOn;

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"],
        operation: json["operation"],
        data: json["data"],
        createdByUser: json["createdByUser"],
        createdOn: json["createdOn"],
      );
}

class GetHistoryResponse {
  final int code;
  final String error;
  final List<History> history;

  GetHistoryResponse({
    required this.code,
    this.error = "",
    this.history = const [],
  });

  factory GetHistoryResponse.fromSuccessJson(Map<String, dynamic> json) =>
      GetHistoryResponse(
        code: json["code"],
        history: List<History>.from(
            json["data"]["history"].map((x) => History.fromJson(x))),
      );

  factory GetHistoryResponse.fromErrorJson(Map<String, dynamic> json) =>
      GetHistoryResponse(
        code: json["code"],
        error: json["error"],
      );
}
