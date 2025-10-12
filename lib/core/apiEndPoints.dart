class ApiEndpoints {
  // Live url

  // static const String baseUrl =
  //     'http://206.162.244.133:8041/api/v1/'; // Replace with actual base URL
  // static const String baseImageUrl =
  //     'http://206.162.244.133:8041';

  // Local url

  static const String baseUrl = 'https://cole-wellness-productivity.onrender.com/api/v1/';
  static const String baseImageUrl = 'https://cole-wellness-productivity.onrender.com/';

  static String signin = "auth/login";
  static String googleSignin = "auth/google-login";
  static String facebookSignin = "auth/facebook-login";

  static String signup = "users/signup";

  static String verifyEmail = "users/create-user-verify-otp";

  static String forgetPassword = "auth/forgot-password-otpByEmail";

  static String verifyOTP = "auth/forgot-password-otp-match";

  static String resendOTP = "otp/resend-otp";

  static String resetPassword = "auth/forgot-password-reset";
  static String changePassword = "auth/change-password";

  static String completeProfile = "users/complete-profile";

  static String getProfile = "users/get-my-profile";

  static String updateProfile = "users/update-my-profile";

  static String fetchCurrentDay = "users/me/days-since";

  static String rituals(int day) =>
      "ritual/user-get-rituals-grouped-by-category?startDay=$day";

  static String addRitual = "ritual/create-ritual";
  static String editRitual(String id) => "ritual/update-ritual/$id";

  static String categoryName =
      "category/get-all-categories?sort=serialNumber&limit=1000";

  static String userProgress = "completion-ritual/progress/category";

  static String about = "about/get-about";

  static String notifications({required int page, int? limit}) {
    limit ??= 10;
    return "notifications/my-notifications?page=$page&limit=$limit";
  }

  static String completeRitual(String ritualId) {
    return 'completion-ritual/ritual/$ritualId';
  }

  static String deleteRitual(String ritualId) {
    return 'ritual/delete-ritual/$ritualId';
  }
}
