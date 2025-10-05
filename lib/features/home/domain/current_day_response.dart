class CurrentDayResponse {
  final bool success;
  final int statusCode;
  final String message;
  final String userId;
  final String createdAt;
  final int days;

  CurrentDayResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.userId,
    required this.createdAt,
    required this.days,
  });

  factory CurrentDayResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return CurrentDayResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] ?? '',
      days: data['days'] ?? 0,
    );
  }
}
