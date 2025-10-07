import 'package:cole20/features/rituals/domain/ritual_model.dart';

class AddRitualsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final Ritual data;

  AddRitualsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AddRitualsResponse.fromJson(Map<String, dynamic> json) {
    return AddRitualsResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: Ritual.fromJson(json['data']??{})
    );
  }
}