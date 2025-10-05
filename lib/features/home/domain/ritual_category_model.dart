import 'ritual_model.dart';

class RitualCategory {
  final String id;
  final String categoryName;
  final String colorName;
  final String colorCode;
  final String icon;
  final int serialNumber;
  final int totalRitual;
  final int completeRitual;
  final List<Ritual> rituals;

  RitualCategory({
    required this.id,
    required this.categoryName,
    required this.colorName,
    required this.colorCode,
    required this.icon,
    required this.serialNumber,
    required this.totalRitual,
    required this.completeRitual,
    required this.rituals,
  });

  factory RitualCategory.fromJson(Map<String, dynamic> json) {
    return RitualCategory(
      id: json['_id'],
      categoryName: json['categoryName'],
      colorName: json['colorName'],
      colorCode: json['colorCode'],
      icon: json['icon'],
      serialNumber: json['serialNumber'],
      totalRitual: json['totalRitual'],
      completeRitual: json['completeRitual'],
      rituals: (json['rituals'] as List)
          .map((r) => Ritual.fromJson(r))
          .toList(),
    );
  }
}
