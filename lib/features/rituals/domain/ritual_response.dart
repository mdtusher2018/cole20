import 'package:cole20/features/rituals/domain/ritual_category_model.dart';

class RitualsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<RitualCategory> data;

  RitualsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory RitualsResponse.fromJson(Map<String, dynamic> json) {
    return RitualsResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => RitualCategory.fromJson(e))
          .toList(),
    );
  }
}