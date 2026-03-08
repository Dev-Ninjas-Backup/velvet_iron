import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/app.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/auth/services/onboarding_status_service.dart';
import 'package:velvet_iron/firebase_options.dart';
import 'package:velvet_iron/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initDeepLinks();
  runApp(VelvetIron());
  configLoading();
}

void initDeepLinks() {
  final appLinks = AppLinks();
  final onboardingService = OnboardingStatusService();

  appLinks.uriLinkStream.listen((Uri uri) async {
    if (uri.host == 'auth' && uri.path.contains('discord')) {
      final accessToken = uri.queryParameters['access_token'];
      final refreshToken = uri.queryParameters['refresh_token'];
      final userEncoded = uri.queryParameters['user'];

      if (accessToken != null && refreshToken != null && userEncoded != null) {
        try {
          final userJson =
              jsonDecode(Uri.decodeComponent(userEncoded))
                  as Map<String, dynamic>;

          await SharedPreferencesHelper.saveLoginData(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: userJson['id'] ?? '',
            email: userJson['email'] ?? '',
            name: userJson['name'] ?? '',
            avatar: userJson['avatar'] ?? '',
            role: userJson['role'] ?? 'USER',
          );

          await SharedPreferencesHelper.saveUsername(
            userJson['username'] ?? '',
          );

          // Check onboarding status and navigate accordingly
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final result = await onboardingService.getOnboardingStatus();
            final isComplete = result['iscomplete'] ?? false;

            if (isComplete) {
              Get.offAllNamed(AppRoute.bottomNavScreen);
            } else {
              Get.offAllNamed(AppRoute.welcomeScreen);
            }
          });
        } catch (e) {
          debugPrint('Failed to parse Discord user data: $e');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed(AppRoute.welcomeScreen);
          });
        }
      }
    }
  });
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false
    ..dismissOnTap = false;
}
