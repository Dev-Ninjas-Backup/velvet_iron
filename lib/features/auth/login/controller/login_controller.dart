// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/auth/login/validation/login_validation.dart';
import 'package:velvet_iron/features/auth/services/auth_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  late final TextEditingController userIdentifierController;
  late final TextEditingController passwordController;

  final rememberMe = false.obs;
  final passwordObscured = true.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    userIdentifierController = TextEditingController();
    passwordController = TextEditingController();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final savedRememberMe = await SharedPreferencesHelper.getRememberMe();
    rememberMe.value = savedRememberMe;

    if (savedRememberMe) {
      final email = await SharedPreferencesHelper.getEmail();
      if (email != null) {
        userIdentifierController.text = email;
      }
    }
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void togglePasswordVisibility() {
    passwordObscured.toggle();
  }

  String? userIdentifierValidator(String? value) {
    return LoginValidation.validateUsernameOrEmail(value);
  }

  String? passwordValidator(String? value) {
    return LoginValidation.validatePassword(value);
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    try {
      isLoading.value = true;
      print('Starting login process...');
      print('Email/Username: ${userIdentifierController.text.trim()}');

      EasyLoading.show(status: 'Logging in...');

      final response = await _authService.login(
        emailOrUsername: userIdentifierController.text.trim(),
        password: passwordController.text,
      );

      print('Response received:');
      print('Success: ${response.isSuccess}');
      print('Status Code: ${response.statusCode}');
      print('Error Message: ${response.errorMessage}');
      print('Response Data: ${response.responseData}');

      EasyLoading.dismiss();

      if (response.isSuccess && response.responseData != null) {
        final responseBody = response.responseData;

        print('Login successful!');

        // Extract tokens and user data

        final accessToken = responseBody['access_token'] ?? '';
        final refreshToken = responseBody['refresh_token'] ?? '';
        final userData = responseBody['user'];

        print('Tokens:');
        print('Access Token: ${accessToken.substring(0, 20)}...');
        print('Refresh Token: ${refreshToken.substring(0, 20)}...');

        print('User Data:');
        print('ID: ${userData['id']}');
        print('Email: ${userData['email']}');
        print('Name: ${userData['name']}');
        print('Username: ${userData['username']}');
        print('Role: ${userData['role']}');
        print('Email Verified: ${userData['emailVerified']}');
        print('Onboarded: ${userData['onBoarded']}');

        // Save login data to SharedPreferences

        print('Saving login data to SharedPreferences...');
        await SharedPreferencesHelper.saveLoginData(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userId: userData['id'],
          email: userData['email'],
          name: userData['name'],
          avatar: userData['avatar'] ?? '',
          role: userData['role'],
          rememberMe: rememberMe.value,
        );
        print('Login data saved successfully!');

        EasyLoading.showSuccess('Login successful!');

        // Navigate based on onboarding status
        await Future.delayed(const Duration(milliseconds: 800));

        if (userData['onBoarded'] == false) {
          print('User not onboarded. Navigating to welcome screen...');
          Get.offAllNamed(AppRoute.welcomeScreen);
        } else {
          print('User already onboarded. Navigating to home screen...');
          Get.offAllNamed(AppRoute.homeScreen);
        }
      } else {
        print('Login failed!');
        print('Error: ${response.errorMessage}');
        EasyLoading.showError(response.errorMessage);
      }
    } catch (e, stackTrace) {
      print('Exception occurred:');
      print('Error: $e');
      print('Stack Trace: $stackTrace');

      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred: ${e.toString()}');
    } finally {
      isLoading.value = false;
      print('Login process completed!');
    }
  }

  @override
  void onClose() {
    userIdentifierController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
