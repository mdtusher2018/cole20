
class RitualProgressCategory {
  final String categoryName;
  final String colorCode;
  final int completedRituals;

  RitualProgressCategory({
    required this.categoryName,
    required this.colorCode,
    required this.completedRituals,
  });

  factory RitualProgressCategory.fromJson(Map<String, dynamic> json) {
    return RitualProgressCategory(
      categoryName: json['categoryName'] ?? '',
      colorCode: json['colorCode'] ?? '',
      completedRituals: json['completedRituals'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'colorCode': colorCode,
      'completedRituals': completedRituals,
    };
  }
}
