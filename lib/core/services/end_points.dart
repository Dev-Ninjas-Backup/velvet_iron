class Urls {
  static const String baseUrl = 'https://velvet.api.softvence.app';

  static const String register = '$baseUrl/auth/register';
  static const String verifyOtp = '$baseUrl/auth/verify-email';
  static const String resendOtp = '$baseUrl/auth/resend-verification-otp';
  static const String login = '$baseUrl/auth/login';
  static const String forgetPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String changePassword = '$baseUrl/auth/change-password';
  static const String myProfile = '$baseUrl/user-info/my-profile';
  static const String logout = '$baseUrl/auth/logout';
  static const String googleLogin = '$baseUrl/auth/firebase-login';
  static const String profile = '$baseUrl/auth/profile';
  static const String getThemes = '$baseUrl/themes/my-themes';
  static String unlockTheme(String themeId) => '$baseUrl/onboarding/theme/$themeId';
  static const String getCompanions = '$baseUrl/companions/my-companions';
  static String unlockCompanion(String companionId) => '$baseUrl/onboarding/companion/$companionId';
  static const String fitnessGoal = '$baseUrl/profile/fitness-goal';
  static const String weightLog = '$baseUrl/weight-log';
  static const String medication = '$baseUrl/medication';
  static const String moodLog = '$baseUrl/mood-log';
  static const String mealLog = '$baseUrl/meal-log';
}
