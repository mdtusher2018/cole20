class AboutResponse {
  final String id;
  final String about;

  AboutResponse({
    required this.id,
    required this.about,
  });

  factory AboutResponse.fromJson(Map<String, dynamic> json) {
    return AboutResponse(
      id: json['_id'] ?? "",
      about: json['about'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "about": about,
    };
  }
}
