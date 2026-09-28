import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/revenuecat_service.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/auth/services/auth_service.dart';
import 'package:velvet_iron/features/auth/services/onboarding_status_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class SplashController extends GetxController {
  final _onboardingService = OnboardingStatusService();
  final _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final awaitingDeletion =
        await SharedPreferencesHelper.getString('awaiting_account_deletion');
    if (awaitingDeletion == 'true') {
      await SharedPreferencesHelper.setString(
        'awaiting_account_deletion',
        'false',
      );
      await SharedPreferencesHelper.clearAll();
      await RevenueCatService.logOut();
      Get.offAllNamed(AppRoute.getLoginScreen());
      return;
    }

    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    // 1. Check if tokens are present in SharedPreferences
    if (accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      debugPrint("[SplashController] No stored tokens found. Clearing preferences and going to Login.");
      await SharedPreferencesHelper.clearAll();
      await RevenueCatService.logOut();
      Get.offAllNamed(AppRoute.getLoginScreen());
      return;
    }

    debugPrint("[SplashController] AccessToken: $accessToken");
    debugPrint("[SplashController] RefreshToken: $refreshToken");

    // 2. Use them to hit the profile API to know token validity
    debugPrint("[SplashController] Checking token validity via profile endpoint...");
    final isValid = await _authService.validateProfileToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    if (isValid) {
      debugPrint("[SplashController] Token is valid. Moving forward.");
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId != null && userId.isNotEmpty) {
        await RevenueCatService.logIn(userId);
      }
      await _checkOnboardingStatus();
      return;
    }

    // 3. If it returns expired/invalid token, hit the refresh token API
    debugPrint("[SplashController] Access token expired or invalid. Attempting to refresh token...");
    final refreshData = await _authService.refreshAuthToken(
      refreshToken: refreshToken,
    );

    if (refreshData != null &&
        refreshData['access_token'] != null &&
        refreshData['refresh_token'] != null) {
      final newAccessToken = refreshData['access_token'] as String;
      final newRefreshToken = refreshData['refresh_token'] as String;
      final user = refreshData['user'] as Map<String, dynamic>?;

      debugPrint("[SplashController] Tokens refreshed successfully! Updating SharedPreferences...");
      await SharedPreferencesHelper.saveRefreshedTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
        user: user,
      );

      final userId = user?['id']?.toString() ?? await SharedPreferencesHelper.getUserId();
      if (userId != null && userId.isNotEmpty) {
        await RevenueCatService.logIn(userId);
      }

      debugPrint("[SplashController] Proceeding with new tokens.");
      await _checkOnboardingStatus();
    } else {
      // 4. If refresh token also returns error, clear SharedPreferences and go to login page
      debugPrint("[SplashController] Refresh token also failed or expired. Clearing SharedPreferences and going to Login.");
      await SharedPreferencesHelper.clearAll();
      await RevenueCatService.logOut();
      Get.offAllNamed(AppRoute.getLoginScreen());
    }
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final result = await _onboardingService.getOnboardingStatus();
      final isComplete = result['iscomplete'] ?? false;

      if (isComplete) {
        Get.offAllNamed(AppRoute.bottomNavScreen);
      } else {
        final isLoggedIn = await SharedPreferencesHelper.checkLogin();
        if (isLoggedIn) {
          Get.offAllNamed(AppRoute.bottomNavScreen);
        } else {
          Get.offAllNamed(AppRoute.welcomeScreen);
        }
      }
    } catch (e) {
      // On error, default to bottomNavScreen
      Get.offAllNamed(AppRoute.bottomNavScreen);
    }
  }
}
