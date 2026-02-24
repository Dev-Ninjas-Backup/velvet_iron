class Urls {
  static const String baseUrl = 'https://velvet.api.softvence.app';

  static const String register = '$baseUrl/auth/register';
  static const String verifyOtp = '$baseUrl/auth/verify-email';
  static const String resendOtp = '$baseUrl/auth/resend-verification-otp';
  static const String login = '$baseUrl/auth/login';
  static const String forgetPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String myProfile = '$baseUrl/user-info/my-profile';
  static const String logout = '$baseUrl/auth/logout';
  static const String googleLogin = '$baseUrl/auth/firebase-login';
  static const String profile = '$baseUrl/auth/profile';
}
