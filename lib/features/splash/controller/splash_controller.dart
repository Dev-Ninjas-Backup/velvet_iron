import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/auth/services/onboarding_status_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class SplashController extends GetxController {
  final _onboardingService = OnboardingStatusService();

  @override
  void onInit() {
    super.onInit();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    if (accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty) {
      // User is logged in, check onboarding status
      await _checkOnboardingStatus();
    } else {
      // No tokens, go to login
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
        Get.offAllNamed(AppRoute.welcomeScreen);
      }
    } catch (e) {
      // On error, default to home screen
      Get.offAllNamed(AppRoute.getHomeScreen());
    }
  }
}
