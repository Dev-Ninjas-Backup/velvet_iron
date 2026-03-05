import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
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

  static Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
