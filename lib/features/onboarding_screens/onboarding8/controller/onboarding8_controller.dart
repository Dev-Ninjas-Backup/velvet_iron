import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding8/model/meal_log_request.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding8/service/meal_log_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingController8 extends GetxController {
  final currentStep = 9.obs;
  final totalSteps = 11.obs;

  final selectedMeal = 'Dinner'.obs;
  final foodController = TextEditingController();
  final calorieController = TextEditingController();

  final _mealLogService = MealLogService();

  double get progressValue => currentStep.value / totalSteps.value;

  void selectMeal(String value) {
    selectedMeal.value = value;
  }

  Future<void> onContinue() async {
    //  Validatio
    if (selectedMeal.value.isEmpty || foodController.text.trim().isEmpty) {
      EasyLoading.showInfo(
        'Please select a meal and enter the food description',
      );
      return;
    }

    final calorieText = calorieController.text.trim();
    if (calorieText.isEmpty) {
      EasyLoading.showInfo('Please enter the number of calories');
      return;
    }

    final calories = double.tryParse(calorieText);
    if (calories == null || calories <= 0) {
      EasyLoading.showInfo('Please enter a valid calorie amount');
      return;
    }

    //  Fetch tokens from SharedPreference
    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    debugPrint('MealLog accessToken : $accessToken');
    debugPrint('MealLog refreshToken: $refreshToken');

    if (accessToken == null || refreshToken == null) {
      debugPrint('MealLog Token missing — aborting');
      EasyLoading.showError('Session expired. Please log in again.');
      return;
    }

    //  Build request macros auto-calculated from calories
    final request = MealLogRequest(
      mealType: MealType.fromString(selectedMeal.value),
      description: foodController.text.trim(),
      calories: calories,
    );

    debugPrint('MealLog Sending request...');
    debugPrint('mealType   : ${request.mealType.value}');
    debugPrint('description: ${request.description}');
    debugPrint('calories   : ${request.calories}');
    debugPrint('carbs      : ${request.carbs.toStringAsFixed(2)} g');
    debugPrint('protein    : ${request.protein.toStringAsFixed(2)} g');
    debugPrint('fats       : ${request.fats.toStringAsFixed(2)} g');

    EasyLoading.show(status: 'Calculating nourishment...');

    try {
      final result = await _mealLogService.logMeal(
        request: request,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      debugPrint('MealLog Success → ${result.toJson()}');
      EasyLoading.showSuccess('Meal logged successfully!');
      Get.toNamed(AppRoute.getonboardingScreen9());
    } on MealLogException catch (e) {
      debugPrint('MealLog MealLogException: $e');
      EasyLoading.showError(e.message);
    } catch (e, stackTrace) {
      debugPrint('MealLog Unexpected error: $e');
      debugPrint('StackTrace:\n$stackTrace');
      EasyLoading.showError('Something went wrong. Please try again.');
    }
  }

  void onBackPressed() {
    Get.back();
  }

  @override
  void onClose() {
    foodController.dispose();
    calorieController.dispose();
    super.onClose();
  }
}
