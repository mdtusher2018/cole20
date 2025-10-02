class ApiEndpoints {

  // Live url

  // static const String baseUrl =
  //     'http://206.162.244.133:8041/api/v1/'; // Replace with actual base URL
  // static const String baseImageUrl =
  //     'http://206.162.244.133:8041';

  // Local url

  static const String baseUrl =
      'http://10.10.10.31:7720/api/v1/';
  static const String baseImageUrl =
      'http://10.10.10.31:7720';



  static String signin="auth/login";

  static String signup="users/signup";

  static String verifyEmail="users/create-user-verify-otp";

  static String forgetPassword="auth/forgot-password-otpByEmail";

  static String resendOTP="otp/resend-otp";




}
