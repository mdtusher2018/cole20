class Ritual {
  final String id;
  final String title;
  final String categoryId;
  final int startDay;
  final int? duration;
  final String createdByUser;
  final String creatorRole;
  final DateTime createdAt;
  final bool isComplete;

  Ritual({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.startDay,
    this.duration,
    required this.createdByUser,
    required this.creatorRole,
    required this.createdAt,
    required this.isComplete,
  });

  factory Ritual.fromJson(Map<String, dynamic> json) {
    return Ritual(
      id: json['_id'] ?? "",
      title: json['title'] ?? "",
      categoryId: json['categoryId'] ?? "",
      startDay: json['startDay'] ?? 0,
      duration: json['duration'],
      createdByUser: json['createdByUser'] ?? "",
      creatorRole: json['creatorRole'] ?? "",
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isComplete: json['isComplete'] ?? false,
    );
  }

  Ritual copyWith({
    String? id,
    String? title,
    String? categoryId,
    int? startDay,
    int? duration,
    String? createdByUser,
    String? creatorRole,
    DateTime? createdAt,
    bool? isComplete,
  }) {
    return Ritual(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      startDay: startDay ?? this.startDay,
      duration: duration ?? this.duration,
      createdByUser: createdByUser ?? this.createdByUser,
      creatorRole: creatorRole ?? this.creatorRole,
      createdAt: createdAt ?? this.createdAt,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
