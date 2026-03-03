import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/profile/service/profile_service.dart';

class ProfileController extends GetxController {
  final fullName = ''.obs;
  final userName = ''.obs;
  final remoteProfilePhoto = ''.obs;

  final profileImage = ImagePath.profile.obs;
  final isLoading = false.obs;

  String? _localPickedPath;

  late TextEditingController fullNameController;
  late TextEditingController usernameController;

  final ImagePicker _picker = ImagePicker();
  final ProfileService _profileService = ProfileService();

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    usernameController = TextEditingController();
    _fetchProfile();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    usernameController.dispose();
    super.onClose();
  }

  // Fetch profile data

  Future<void> _fetchProfile() async {
    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      debugPrint('Profile Token missing — cannot fetch');
      return;
    }

    isLoading.value = true;

    try {
      final profile = await _profileService.getProfile(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      fullName.value = profile.name;
      fullNameController.text = profile.name;

      // ✅ Use profilePhoto if available, otherwise fall back to saved avatar
      if (profile.profilePhoto.isNotEmpty) {
        remoteProfilePhoto.value = profile.profilePhoto;
      } else {
        final savedAvatar = await SharedPreferencesHelper.getAvatar();
        if (savedAvatar != null && savedAvatar.isNotEmpty) {
          remoteProfilePhoto.value = savedAvatar;
          debugPrint('Profile using Discord avatar: $savedAvatar');
        }
      }

      final savedUsername = await SharedPreferencesHelper.getUsername();
      if (savedUsername != null && savedUsername.isNotEmpty) {
        userName.value = savedUsername;
        usernameController.text = savedUsername;
      }
    } on ProfileException catch (e) {
      debugPrint('Profile Fetch ProfileException: $e');
    } catch (e, stackTrace) {
      debugPrint('Profile Fetch unexpected error: $e');
      debugPrint('StackTrace:\n$stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  //  Image picker
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        _localPickedPath = image.path;
        profileImage.value = image.path;
        debugPrint('Profile Image picked: ${image.path}');
        EasyLoading.showSuccess('Profile picture selected!');
      }
    } catch (e) {
      debugPrint('Profile Image pick error: $e');
      EasyLoading.showError('Failed to pick image. Please try again.');
    }
  }

  //  Save changes
  Future<void> saveChanges() async {
    if (fullNameController.text.trim().isEmpty) {
      EasyLoading.showInfo('Please enter your full name');
      return;
    }
    if (usernameController.text.trim().isEmpty) {
      EasyLoading.showInfo('Please enter your username');
      return;
    }

    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    debugPrint('Profile accessToken : $accessToken');
    debugPrint('Profile refreshToken: $refreshToken');

    if (accessToken == null || refreshToken == null) {
      debugPrint('Profile Token missing — aborting save');
      EasyLoading.showError('Session expired. Please log in again.');
      return;
    }

    EasyLoading.show(status: 'Updating profile...');

    try {
      final result = await _profileService.updateProfile(
        name: fullNameController.text.trim(),
        username: usernameController.text.trim(),
        accessToken: accessToken,
        refreshToken: refreshToken,
        profilePhotoPath: _localPickedPath,
      );

      debugPrint('Profile Updated →');
      debugPrint('name        : ${result.user.name}');
      debugPrint('username    : ${result.user.username}');
      debugPrint('profilePhoto: ${result.user.profilePhoto}');

      //  State update
      fullName.value = result.user.name;
      userName.value = result.user.username;
      remoteProfilePhoto.value = result.user.profilePhoto.isNotEmpty
          ? result.user.profilePhoto
          : result.user.avatar;

      await SharedPreferencesHelper.saveUsername(result.user.username);
      debugPrint('Profile username saved to prefs: ${result.user.username}');

      _localPickedPath = null;

      EasyLoading.showSuccess(
        result.message.isNotEmpty
            ? result.message
            : 'Profile updated successfully!',
      );
      Get.back();
    } on ProfileException catch (e) {
      debugPrint('Profile Update ProfileException: $e');
      EasyLoading.showError(e.message);
    } catch (e, stackTrace) {
      debugPrint('Profile Update unexpected error: $e');
      debugPrint('StackTrace:\n$stackTrace');
      EasyLoading.showError('Failed to update profile. Please try again.');
    }
  }
}
