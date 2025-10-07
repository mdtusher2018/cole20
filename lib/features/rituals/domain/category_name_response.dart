import 'package:cole20/features/rituals/domain/category_name_model.dart';

class CategoryNameResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<RitualCategoryNameModel> data;

  CategoryNameResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CategoryNameResponse.fromJson(Map<String, dynamic> json) {
    return CategoryNameResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data:
          (json['data']["categories"] as List<dynamic>? ?? []).map((e) {
            return RitualCategoryNameModel.fromJson(e);
          }).toList(),
    );
  }
}
