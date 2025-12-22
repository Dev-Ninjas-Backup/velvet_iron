class Urls {
  static const String baseUrl = 'http://13.236.184.158:5050/api';

  static const String register = '$baseUrl/auth/register';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String login = '$baseUrl/auth/login';
  static const String forgetPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String myProfile = '$baseUrl/user-info/my-profile';
}
