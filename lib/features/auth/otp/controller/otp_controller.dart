import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/auth/otp/validation/otp_validation.dart';

class OtpController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;
  final RxInt remainingSeconds = 120.obs;
  Timer? _countdownTimer;

  @override
  void onInit() {
    super.onInit();
    otpControllers = List.generate(4, (index) => TextEditingController());
    focusNodes = List.generate(4, (index) => FocusNode());
    _startCountdown();
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

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
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
    // Each TextFormField passes a single-character `value`, but we want to
    // validate the full OTP composed of all 4 fields.
    final String otpValue = otpControllers.map((c) => c.text).join();
    return OtpValidation.validateOtp(otpValue);
  }

  void verifyOtp(String previousPage) {
    // Trigger form validators so field-level errors show up in the UI.
    final bool isValid = formKey.currentState?.validate() ?? false;
    final String otpValue = otp;
    final String? validationError = OtpValidation.validateOtp(otpValue);

    if (isValid && validationError == null) {
      if (previousPage == 'SignUpScreen') {
        Get.offAllNamed('/loginScreen');
      } else {
        Get.offAllNamed('/setPasswordScreen');
      }
    } else {
      Get.snackbar('Error', validationError ?? 'Please enter a valid OTP');
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
