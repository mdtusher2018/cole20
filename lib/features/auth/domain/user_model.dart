// features/auth/domain/user.dart
class User {
  final String id;
  final String fullName;
  final String email;
  final String? profileImage;
  final String role;
  final String phone;
  final bool userVerification;
  final bool isProfileComplete;
  final bool isBlocked;
  final bool isDeleted;
  final String loginWith;
  final String? gender;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImage,
    required this.role,
    required this.phone,
    required this.userVerification,
    required this.isProfileComplete,
    required this.isBlocked,
    required this.isDeleted,
    required this.loginWith,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      profileImage: json['profileImage'],
      role: json['role'],
      phone: json['phone'],
      userVerification: json['userVerification'] ?? false,
      isProfileComplete: json['isProfileComplete'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      loginWith: json['loginWth'],
      gender: json['gender'],
    );
  }
}
