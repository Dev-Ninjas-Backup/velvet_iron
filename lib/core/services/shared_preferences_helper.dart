import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvet_iron/core/services/app_timezone_helper.dart';

class SharedPreferencesHelper {
  static Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<void> saveString(String key, String value) async {
    await setString(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<void> saveBool(String key, bool value) async {
    await setBool(key, value);
  }

  static Future<int?> getInt(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<void> setInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static const String _accessTokenKey = 'token';
  static const String _userIdKey = 'userId';
  static const String _emailKey = 'email';
  static const String _nameKey = 'name';
  static const String _usernameKey = 'username';
  static const String _avatarKey = 'avatar';
  static const String _roleKey = 'role';
  static const String _isLoginKey = 'isLogin';

  static const String _refreshTokenKey = 'refresh_token';
  static const String _rememberMeKey = 'rememberMe';
  static const String _activeThemeIdKey = 'activeThemeId';
  static const String _lastDailyLoginTimestampKey = 'lastDailyLoginTimestamp';

  static Future<void> saveTokenAndRole(
    String token,
    String role,
    String userId,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
    await prefs.setString(_roleKey, role);
    await prefs.setString(_userIdKey, userId);
    await prefs.setBool(_isLoginKey, true);
  }

  // Add this new method
  static Future<void> saveUserData({
    required String userId,
    required String email,
    required String name,
    required String avatar,
    required String role,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_nameKey, name);
    await prefs.setString(_avatarKey, avatar);
    await prefs.setString(_roleKey, role);
  }

  static Future<void> saveUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // save user login data

  static Future<void> saveLoginData({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email,
    required String name,
    required String avatar,
    required String role,
    bool rememberMe = false,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_nameKey, name);
    await prefs.setString(_avatarKey, avatar);
    await prefs.setString(_roleKey, role);
    await prefs.setBool(_isLoginKey, true);
    await prefs.setBool(_rememberMeKey, rememberMe);
  }

  static Future<void> saveRefreshedTokens({
    required String accessToken,
    required String refreshToken,
    Map<String, dynamic>? user,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setBool(_isLoginKey, true);
    if (user != null) {
      if (user['id'] != null) await prefs.setString(_userIdKey, user['id'].toString());
      if (user['email'] != null) await prefs.setString(_emailKey, user['email'].toString());
      if (user['name'] != null) await prefs.setString(_nameKey, user['name'].toString());
      if (user['username'] != null) await prefs.setString(_usernameKey, user['username'].toString());
      if (user['avatar'] != null) await prefs.setString(_avatarKey, user['avatar'].toString());
      if (user['role'] != null) await prefs.setString(_roleKey, user['role'].toString());
    }
  }

  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  //  Get refresh token
  static Future<String?> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<String?> getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  static Future<String?> getAvatar() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarKey);
  }

  static Future<void> saveAvatar(String avatar) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarKey, avatar);
  }

  static Future<String?> getRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  static Future<bool> checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoginKey) ?? false;
  }

  static Future<bool> getRememberMe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  static const String _lastDailyLoginDateKey = 'lastDailyLoginDate';

  static Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save daily login tracking before clearing
    final lastDailyLoginTimestamp = prefs.getString(
      _lastDailyLoginTimestampKey,
    );
    final lastDailyLoginDate = prefs.getString(_lastDailyLoginDateKey);

    // Clear all data
    await prefs.clear();

    // Restore daily login persistence across logout/login
    if (lastDailyLoginTimestamp != null) {
      await prefs.setString(
        _lastDailyLoginTimestampKey,
        lastDailyLoginTimestamp,
      );
    }
    if (lastDailyLoginDate != null) {
      await prefs.setString(_lastDailyLoginDateKey, lastDailyLoginDate);
    }
  }

  // Theme persistence methods
  static Future<void> saveActiveThemeId(String themeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeThemeIdKey, themeId);
  }

  static Future<String?> getActiveThemeId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeThemeIdKey);
  }

  static Future<void> saveActiveThemeName(String themeName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_activeThemeIdKey}_name', themeName);
  }

  static Future<String?> getActiveThemeName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('${_activeThemeIdKey}_name');
  }

  // Daily login persistence methods
  static Future<void> saveLastDailyLoginDate(String dateStr) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDailyLoginDateKey, dateStr);
  }

  static Future<String?> getLastDailyLoginDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastDailyLoginDateKey);
  }

  static Future<bool> hasClaimedDailyLoginToday() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(_lastDailyLoginDateKey);
    final today = AppTimezoneHelper.getTodayDateString();
    return lastDate == today;
  }

  static Future<void> saveLastDailyLoginTimestamp(DateTime timestamp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _lastDailyLoginTimestampKey,
      timestamp.toIso8601String(),
    );
  }

  static Future<String?> getLastDailyLoginTimestamp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastDailyLoginTimestampKey);
  }

  // Active Companion persistence
  static const String _activeCompanionNameKey = 'activeCompanionName';
  static const String _activeCompanionImageKey = 'activeCompanionImage';

  static Future<void> saveActiveCompanion({
    required String name,
    required String imagePath,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeCompanionNameKey, name);
    await prefs.setString(_activeCompanionImageKey, imagePath);
  }

  static Future<Map<String, String>?> getActiveCompanion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_activeCompanionNameKey);
    final image = prefs.getString(_activeCompanionImageKey);
    if (name != null && image != null) {
      return {'name': name, 'imagePath': image};
    }
    return null;
  }

  // Full-body daily greeting tracking
  static const String _lastFullBodyGreetingDateKey = 'lastFullBodyGreetingDate';

  static Future<bool> isFullBodyGreetingShownToday() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(_lastFullBodyGreetingDateKey);
    final today = AppTimezoneHelper.getTodayDateString();
    return lastDate == today;
  }

  static Future<void> markFullBodyGreetingShownToday() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final today = AppTimezoneHelper.getTodayDateString();
    await prefs.setString(_lastFullBodyGreetingDateKey, today);
  }

  // Daily Step Goal persistence
  static const String _dailyStepGoalKey = 'dailyStepGoal';

  static Future<void> saveDailyStepGoal(int goal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyStepGoalKey, goal);
  }

  static Future<int?> getDailyStepGoal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyStepGoalKey);
  }

  // Royal Summons narrative onboarding tracking (scoped to userId)
  static Future<bool> hasAcceptedRoyalSummons() async {
    final userId = await getUserId() ?? 'default';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_accepted_royal_summons_$userId') ?? false;
  }

  static Future<void> markRoyalSummonsAccepted() async {
    final userId = await getUserId() ?? 'default';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_accepted_royal_summons_$userId', true);
  }
}

