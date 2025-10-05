class Ritual {
  final String id;
  final String title;
  final int startDay;
  final int? duration;
  final String createdByUser;
  final String creatorRole;
  final DateTime createdAt;
  final bool isComplete;

  Ritual({
    required this.id,
    required this.title,
    required this.startDay,
    required this.duration,
    required this.createdByUser,
    required this.creatorRole,
    required this.createdAt,
    required this.isComplete,
  });

  factory Ritual.fromJson(Map<String, dynamic> json) {
    return Ritual(
      id: json['_id'],
      title: json['title'],
      startDay: json['startDay'],
      duration: json['duration'],
      createdByUser: json['createdByUser'],
      creatorRole: json['creatorRole'],
      createdAt: DateTime.parse(json['createdAt']),
      isComplete: json['isComplete'],
    );
  }
}
