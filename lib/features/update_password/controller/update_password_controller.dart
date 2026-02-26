import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/update_password/service/update_password_service.dart';

class UpdatePasswordController extends GetxController {
  var isOldPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _service = ChangePasswordService();

  void toggleOldPassword() => isOldPasswordVisible.toggle();
  void toggleNewPassword() => isNewPasswordVisible.toggle();
  void toggleConfirmPassword() => isConfirmPasswordVisible.toggle();

  Future<void> updatePassword() async {
    final currentPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      EasyLoading.showInfo('Please enter your current password');
      return;
    }

    if (newPassword.isEmpty) {
      EasyLoading.showInfo('Please enter a new password');
      return;
    }

    if (newPassword.length < 8) {
      EasyLoading.showInfo('Password must be at least 8 characters');
      return;
    }

    if (newPassword != confirmPassword) {
      EasyLoading.showInfo('New password and confirm password do not match');
      return;
    }

    if (currentPassword == newPassword) {
      EasyLoading.showInfo(
        'New password must be different from current password',
      );
      return;
    }

    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    debugPrint('ChangePassword accessToken : $accessToken');
    debugPrint('ChangePassword refreshToken: $refreshToken');

    if (accessToken == null || refreshToken == null) {
      debugPrint('ChangePassword Token missing — aborting');
      EasyLoading.showError('Session expired. Please log in again.');
      return;
    }

    EasyLoading.show(status: 'Securing your Codex...');

    try {
      final result = await _service.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      debugPrint('ChangePassword Success → message: ${result.message}');

      EasyLoading.showSuccess(
        result.message.isNotEmpty
            ? result.message
            : 'Password Updated Successfully!',
      );

      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      Get.back();
    } on ChangePasswordException catch (e) {
      debugPrint('ChangePassword ChangePasswordException: $e');
      EasyLoading.showError(e.message);
    } catch (e, stackTrace) {
      debugPrint('ChangePassword Unexpected error: $e');
      debugPrint('   StackTrace:\n$stackTrace');
      EasyLoading.showError('Failed to update password. Please try again.');
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
