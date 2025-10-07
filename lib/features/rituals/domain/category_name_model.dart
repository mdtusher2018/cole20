class RitualCategoryNameModel {
  final String id;
  final String name;
  final int serialNumber;

  RitualCategoryNameModel({
    required this.id,
    required this.name,
    required this.serialNumber,
  });

  factory RitualCategoryNameModel.fromJson(Map<String, dynamic> json) {
    return RitualCategoryNameModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      serialNumber: json['serialNumber'] as int,
    );
  }
}
