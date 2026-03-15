class Urls {
  static String markMealAsTaken(String id) =>
      '$baseUrl/meal-schedule/$id/taken?isTaken=true';
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
  static const String getProfile = '$baseUrl/profile';
  static const String getThemes = '$baseUrl/themes/my-themes';
  static String themes(String themeId) => '$baseUrl/themes/$themeId';
  static String unlockTheme(String themeId) =>
      '$baseUrl/onboarding/theme/$themeId';
  static const String getCompanions = '$baseUrl/companions/my-companions';
  static String unlockCompanion(String companionId) =>
      '$baseUrl/onboarding/companion/$companionId';
  static const String fitnessGoal = '$baseUrl/profile/fitness-goal';
  static const String weightLog = '$baseUrl/weight-log';
  static const String weightLogHistory = '$baseUrl/weight-log/history';
  static const String medication = '$baseUrl/medication';
  static const String medicationHistory = '$baseUrl/medication/history';
  static const String medicationSchedule = '$baseUrl/medication-schedule';
  static String updateMedicationHHistory(String id) =>
      '$baseUrl/medication-schedule/$id/taken?isTaken=true';
  static const String moodLog = '$baseUrl/mood-log';
  static String getMoodLogHistory(int limit, int offset) =>
      '$baseUrl/mood-log/history?limit=$limit&offset=$offset';
  static const String macroGoal = '$baseUrl/macro-goal';
  static const String getTodayMoodLog = '$baseUrl/mood-log/today';
  static const String mealLog = '$baseUrl/meal-log';
  static const String mealSchedule = '$baseUrl/meal-schedule';
  static String mealLogHistory(int limit, int offset) =>
      '$baseUrl/meal-log/history?limit=$limit&offset=$offset';
  // static const String mealLog = '$baseUrl/meal-log';
  static const String discordSignIn = '$baseUrl/auth/discord-auth-url';
  static const String discordCallback = '$baseUrl/auth/discord/callback';
  static const String authDiscord = '$baseUrl/auth/discord';
  static const String exerciseLog = '$baseUrl/exercise-log';
  static const String exerciseHistory = '$baseUrl/exercise-log/history';
  static const String exerciseLogSchedule = '$baseUrl/exercise-log/schedule';
  static String updateExerciseHHistory(String id) =>
      '$baseUrl/exercise-log/$id/taken?isTaken=true';
  static const String firebaseLogin = '$baseUrl/auth/firebase-login';
  static const String quests = '$baseUrl/xp-stats/quests';
  static const String addXP = '$baseUrl/profile/add-xp/log';
  static const String homeScreen = '$baseUrl/profile';
  static const String onboardingStatus = '$baseUrl/onboarding';
  static const String dailyLogsXP = '$baseUrl/profile/daily-login';
  static const String activeTheme = '$baseUrl/themes/my-themes';
  static const String activeCompanion = '$baseUrl/companions/my-companions';
  static const String weeklyWeightLog = '$baseUrl/weight-log/chart/weekly';
  static String unlockNewTheme(String id) => '$baseUrl/themes/$id/unlock';
  static String activateNewTheme(String id) => '$baseUrl/themes/$id/activate';
  static String unlockNewCompanion(String id) =>
      '$baseUrl/companions/$id/unlock';
  static String activateNewCompanion(String id) =>
      '$baseUrl/companions/$id/activate';
}
