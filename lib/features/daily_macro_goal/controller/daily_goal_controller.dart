import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/daily_macro_goal/service/daily_macro_goal_service.dart';

class DailyGoalController extends GetxController {
  var carbs = 120.obs;
  var protein = 220.obs;
  var fats = 120.obs;
  var isLoading = false.obs;

  late final TextEditingController carbsController;
  late final TextEditingController proteinController;
  late final TextEditingController fatsController;

  int get totalCalories =>
      (carbs.value * 4) + (protein.value * 4) + (fats.value * 9);

  final MacroGoalService _service = MacroGoalService();

  @override
  void onInit() {
    super.onInit();
    carbsController = TextEditingController(text: carbs.value.toString());
    proteinController = TextEditingController(text: protein.value.toString());
    fatsController = TextEditingController(text: fats.value.toString());

    // Sync observable when user types — totalCalories updates reactively
    carbsController.addListener(
      () => carbs.value = int.tryParse(carbsController.text) ?? 0,
    );
    proteinController.addListener(
      () => protein.value = int.tryParse(proteinController.text) ?? 0,
    );
    fatsController.addListener(
      () => fats.value = int.tryParse(fatsController.text) ?? 0,
    );

    _fetchMacroGoals(); 
  }

  @override
  void onClose() {
    carbsController.dispose();
    proteinController.dispose();
    fatsController.dispose();
    super.onClose();
  }

  //  Fetch existing macro goals 
  Future<void> _fetchMacroGoals() async {
    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    debugPrint('MacroGoal accessToken : $accessToken');
    debugPrint('MacroGoal refreshToken: $refreshToken');

    if (accessToken == null || refreshToken == null) {
      debugPrint('MacroGoal Token missing — cannot fetch');
      return;
    }

    isLoading.value = true;

    try {
      final result = await _service.getMacroGoals(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      debugPrint('MacroGoal Fetched ${result.data.length} goal(s)');

      final latest = result.latest;
      if (latest != null) {
        carbs.value = latest.carbs;
        protein.value = latest.protein;
        fats.value = latest.fat;

        carbsController.text = latest.carbs.toString();
        proteinController.text = latest.protein.toString();
        fatsController.text = latest.fat.toString();

        debugPrint('carbs   : ${latest.carbs} g');
        debugPrint('protein : ${latest.protein} g');
        debugPrint('fat     : ${latest.fat} g');
        debugPrint('calories: ${latest.calories} kcal');
      } else {
        debugPrint('No saved goals — keeping defaults');
      }
    } on MacroGoalException catch (e) {
      debugPrint('MacroGoal Fetch MacroGoalException: $e');
    } catch (e, stackTrace) {
      debugPrint('MacroGoal Fetch unexpected error: $e');
      debugPrint('StackTrace:\n$stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  //  Save goals 
  Future<void> saveGoals() async {
    if (carbs.value <= 0 || protein.value <= 0 || fats.value <= 0) {
      EasyLoading.showInfo('Please enter valid values for all macros');
      return;
    }

    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    debugPrint('MacroGoal accessToken : $accessToken');
    debugPrint('MacroGoal refreshToken: $refreshToken');

    if (accessToken == null || refreshToken == null) {
      debugPrint('MacroGoal Token missing — aborting save');
      EasyLoading.showError('Session expired. Please log in again.');
      return;
    }

    debugPrint('MacroGoal Saving →');
    debugPrint('carbs  : ${carbs.value} g');
    debugPrint('protein: ${protein.value} g');
    debugPrint('fats   : ${fats.value} g  (sent as "fat")');
    debugPrint('total  : $totalCalories kcal');

    EasyLoading.show(status: 'Saving your macro goal...');

    try {
      final result = await _service.createMacroGoal(
        carbs: carbs.value,
        protein: protein.value,
        fat: fats.value,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      debugPrint('MacroGoal Saved →');
      debugPrint('id      : ${result.data.id}');
      debugPrint('calories: ${result.data.calories} kcal');

      EasyLoading.showSuccess(
        result.message.isNotEmpty ? result.message : 'Daily goals updated!',
      );

      await Future.delayed(const Duration(milliseconds: 1500));
      Get.back();
    } on MacroGoalException catch (e) {
      debugPrint('MacroGoal MacroGoalException: $e');
      EasyLoading.showError(e.message);
    } catch (e, stackTrace) {
      debugPrint('MacroGoal Unexpected error: $e');
      debugPrint('StackTrace:\n$stackTrace');
      EasyLoading.showError('Failed to save macro goal. Please try again.');
    }
  }
}
