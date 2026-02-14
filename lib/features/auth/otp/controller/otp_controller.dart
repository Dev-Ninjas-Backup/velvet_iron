// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/auth/otp/otp_service.dart';
import 'package:velvet_iron/features/auth/otp/validation/otp_validation.dart';

class OtpController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final OtpService _otpService = OtpService();

  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;
  final RxInt remainingSeconds = 120.obs;
  Timer? _countdownTimer;

  final RxString userEmail = ''.obs;
  final RxString userId = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    otpControllers = List.generate(6, (index) => TextEditingController());
    focusNodes = List.generate(6, (index) => FocusNode());
    _startCountdown();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final email = await SharedPreferencesHelper.getEmail();
    final id = await SharedPreferencesHelper.getUserId();

    if (email != null) {
      userEmail.value = email;
      print('📧 Loaded Email from SharedPreferences: $email');
    }
    if (id != null) {
      userId.value = id;
      print('🆔 Loaded User ID from SharedPreferences: $id');
    }
  }

  void _startCountdown() {
    remainingSeconds.value = 120;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value -= 1;
      } else {
        timer.cancel();
      }
    });
  }

  String get otp {
    return otpControllers.map((controller) => controller.text).join();
  }

  String getMaskedEmail() {
    if (userEmail.value.isEmpty) return 'your email';

    final parts = userEmail.value.split('@');
    if (parts.length != 2) return userEmail.value;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) {
      return '${username[0]}***@$domain';
    }

    return '${username.substring(0, 2)}${'*' * (username.length - 2)}@$domain';
  }

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }
  }

  String? validateOtp(String? value) {
    final String otpValue = otpControllers.map((c) => c.text).join();
    return OtpValidation.validateOtp(otpValue);
  }

  Future<void> verifyOtp(String previousPage) async {
    final bool isValid = formKey.currentState?.validate() ?? false;
    final String otpValue = otp;
    final String? validationError = OtpValidation.validateOtp(otpValue);

    print('🔍 Verifying OTP...');
    print('   - OTP Value: $otpValue');
    print('   - Is Valid: $isValid');
    print('   - Validation Error: $validationError');
    print('   - Email: ${userEmail.value}');
    print('   - Previous Page: $previousPage');

    if (!isValid || validationError != null) {
      print('❌ OTP validation failed!');
      Get.snackbar('Error', validationError ?? 'Please enter a valid OTP');
      return;
    }

    if (userEmail.value.isEmpty) {
      print('❌ Email is empty!');
      Get.snackbar('Error', 'Email not found. Please try again.');
      return;
    }

    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Verifying OTP...');

      final response = await _otpService.verifyEmail(
        email: userEmail.value,
        otp: otpValue,
      );

      EasyLoading.dismiss();

      if (response.isSuccess) {
        print('✅ OTP verification successful!');
        final message =
            response.responseData['message'] ?? 'Email verified successfully';

        EasyLoading.showSuccess(message);
        for (var controller in otpControllers) {
          controller.clear();
        }

        // Navigate based on previous page
        
        await Future.delayed(const Duration(milliseconds: 800));

        if (previousPage == 'SignUpScreen') {
          print('🔄 Navigating to login screen...');
          Get.offAllNamed('/loginScreen');
        } else {
          print('🔄 Navigating to set password screen...');
          Get.offAllNamed('/setPasswordScreen');
        }
      } else {
        print('❌ OTP verification failed!');
        print('   - Error: ${response.errorMessage}');
        EasyLoading.showError(response.errorMessage);
      }
    } catch (e) {
      print('💥 Exception during OTP verification: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (userEmail.value.isEmpty) {
      print('❌ Email is empty! Cannot resend OTP');
      Get.snackbar('Error', 'Email not found. Please try again.');
      return;
    }

    if (remainingSeconds.value > 0) {
      print('⏳ Timer still running. Please wait.');
      return;
    }

    try {
      print('🔄 Resending OTP...');
      print('   - Email: ${userEmail.value}');

      EasyLoading.show(status: 'Resending OTP...');

      final response = await _otpService.resendVerificationOtp(
        email: userEmail.value,
      );

      EasyLoading.dismiss();

      if (response.isSuccess) {
        print('✅ OTP resent successfully!');
        final message =
            response.responseData['message'] ??
            'OTP has been resent to your email';

        EasyLoading.showSuccess(message);

        // Restart timer
        _startCountdown();

        // Clear OTP fields
        for (var controller in otpControllers) {
          controller.clear();
        }

        // Focus on first field
        focusNodes[0].requestFocus();
      } else {
        print('❌ Failed to resend OTP!');
        print('   - Error: ${response.errorMessage}');
        EasyLoading.showError(response.errorMessage);
      }
    } catch (e) {
      print('💥 Exception during resend OTP: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    _countdownTimer?.cancel();
    super.onClose();
  }
}
