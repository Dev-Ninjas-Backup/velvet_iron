// ignore_for_file: avoid_print, unnecessary_nullable_for_final_variable_declarations, await_only_futures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/auth/login/validation/login_validation.dart';
import 'package:velvet_iron/features/auth/services/auth_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class LoginController extends GetxController {
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Signing in with Google...');

      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) {
        isLoading.value = false;
        EasyLoading.dismiss();
        print('DEBUG: Google Sign-In cancelled by user');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? googleIdToken = googleAuth.idToken;

      print('DEBUG: Google ID Token obtained: ${googleIdToken != null}');

      if (googleIdToken == null) {
        isLoading.value = false;
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to get Google ID token');
        return;
      }
      final OAuthCredential firebaseCredential = GoogleAuthProvider.credential(
        idToken: googleIdToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(firebaseCredential);

      final String? firebaseIdToken = await userCredential.user?.getIdToken(
        true,
      );

      print('DEBUG: Firebase ID Token obtained: ${firebaseIdToken != null}');
      print(
        'DEBUG: Firebase ID Token preview: ${firebaseIdToken?.substring(0, 50)}...',
      );

      if (firebaseIdToken == null) {
        isLoading.value = false;
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to get Firebase ID token');
        return;
      }

      await _performFirebaseLogin(firebaseIdToken);
    } on GoogleSignInException catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss();
      if (e.code == GoogleSignInExceptionCode.canceled) {
        print('DEBUG: Google Sign-In cancelled by user');
      } else {
        EasyLoading.showError(
          'Google Sign-In failed: ${e.description ?? e.code.name}',
        );
        print('DEBUG: Google Sign-In error: $e');
      }
    } catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss();
      EasyLoading.showError('Google Sign-In failed: $e');
      print('DEBUG: Google Sign-In error: $e');
    }
  }

  Future<void> _performFirebaseLogin(String token) async {
    try {
      final response = await _authService.firebaseLogin(token: token);

      isLoading.value = false;
      EasyLoading.dismiss();

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData;
        final accessToken = data['access_token'] ?? '';
        final refreshToken = data['refresh_token'] ?? '';
        final user = data['user'];

        if (user != null) {
          await SharedPreferencesHelper.saveLoginData(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: user['id'] ?? '',
            email: user['email'] ?? '',
            name: user['name'] ?? '',
            avatar: user['avatar'] ?? '',
            role: user['role'] ?? '',
            rememberMe: rememberMe.value,
          );
        }

        print('DEBUG: Firebase Login Response: $data');
        print('DEBUG: Token: $accessToken');
        print('DEBUG: User: $user');

        if (accessToken.isNotEmpty) {
          EasyLoading.showSuccess('Login successful!');
          await Future.delayed(const Duration(milliseconds: 800));
          if (user != null && user['onBoarded'] == false) {
            print('User not onboarded. Navigating to welcome screen...');
            Get.offAllNamed(AppRoute.welcomeScreen);
          } else {
            print('User already onboarded. Navigating to home screen...');
            Get.offAllNamed(AppRoute.homeScreen);
          }
        } else {
          EasyLoading.showError('Login failed: No token received');
        }
      } else {
        EasyLoading.showError(response.errorMessage);
        print('DEBUG: Firebase login failed: ${response.errorMessage}');
      }
    } catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss();
      EasyLoading.showError('Login failed: $e');
      print('DEBUG: Firebase Login error: $e');
    }
  }

  Future<void> signInWithDiscord() async {
    try {
      isLoading.value = true;
      final url = await _authService.getDiscordOAuthUrl();
      if (url != null) {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      } else {
        EasyLoading.showError('Failed to generate Discord OAuth URL');
      }
    } catch (e) {
      EasyLoading.showError('Discord sign-in failed: ${e.toString()}');
      print('Discord sign-in failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

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
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      await GoogleSignIn.instance.initialize();
      print('DEBUG: GoogleSignIn initialized successfully');
    } catch (e) {
      print('DEBUG: GoogleSignIn initialization error: $e');
    }
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

        await Future.delayed(const Duration(milliseconds: 800));

        // if (userData['onBoarded'] == false) {
        //   print('User not onboarded. Navigating to welcome screen...');
        //   Get.offAllNamed(AppRoute.welcomeScreen);
        // } else {
        //   print('User already onboarded. Navigating to home screen...');
        //   Get.offAllNamed(AppRoute.homeScreen);
        // }
        Get.offAllNamed(AppRoute.bottomNavScreen);
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
