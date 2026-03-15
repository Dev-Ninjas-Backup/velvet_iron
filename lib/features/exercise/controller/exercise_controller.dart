// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/exercise/model/exercise_model.dart';
import 'package:velvet_iron/features/exercise/service/exercise_service.dart';

class ExerciseController extends GetxController {
  final _exerciseService = ExerciseService();

  final isLoading = true.obs;

  // Exercise Stats
  final totalCount = 0.obs;
  final pendingCount = 0.obs;
  final totalEarnedXp = 0.obs;
  final nextSchedule = Rxn<Exercise>();

  // Exercise Stats (legacy)
  final exerciseStats = ExerciseStats(loggedExercises: 0, timeExercises: 0).obs;

  // Exercise History
  final exercises = <Exercise>[].obs;

  // Text controllers for clearing fields
  final exerciseNameController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchExerciseData();
  }

  @override
  void onClose() {
    exerciseNameController.dispose();
    notesController.dispose();
    super.onClose();
  }

  Future<void> fetchExerciseData() async {
    try {
      isLoading(true);
      await fetchExerciseHistory();
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchExerciseHistory() async {
    try {
      final response = await _exerciseService.fetchExerciseHistory();

      if (response == null) {
        print('❌ Failed to fetch exercise history');
        return;
      }

      print('✅ Exercise History Response: ${jsonEncode(response)}');

      // Parse stats from response
      totalCount.value = response['totalCount'] ?? 0;
      pendingCount.value = response['pendingCount'] ?? 0;
      totalEarnedXp.value = response['totalEarnedXp'] ?? 0;
      nextSchedule.value = response['nextSchedule'] != null
          ? Exercise.fromJson(response['nextSchedule'])
          : null;

      // Update legacy stats
      exerciseStats.value = ExerciseStats(
        loggedExercises: totalCount.value,
        timeExercises: totalEarnedXp.value,
      );

      // Parse logs list
      final List<dynamic> logs = response['logs'] ?? [];
      final List<Exercise> parsed = logs
          .map((e) => Exercise.fromJson(e))
          .toList();

      exercises.assignAll(parsed);

      print('✅ Parsed ${exercises.length} exercises');
    } catch (e) {
      print('❌ fetchExerciseHistory Error: $e');
    }
  }

  // Form state
  final exerciseType = 'Cardio'.obs;
  final exerciseName = ''.obs;
  final duration = 30.obs;
  final intensity = 'Medium'.obs;
  final notes = ''.obs;
  final scheduleDate = DateTime.now().obs;
  final scheduleTime = TimeOfDay.now().obs;

  void setSelectedDate(DateTime date) {
    scheduleDate.value = date;
  }

  void setSelectedTime(TimeOfDay time) {
    scheduleTime.value = time;
  }

  final selectedExerciseTab = 0.obs;

  void setExerciseTab(int index) {
    selectedExerciseTab.value = index;
  }

  void _clearFields() {
    exerciseNameController.clear();
    notesController.clear();
    exerciseType.value = 'Cardio'; // Reset dropdown
    intensity.value = 'Medium'; // Reset dropdown
    duration.value = 30;
    exerciseName.value = '';
    notes.value = '';
    // Always reset scheduling state to avoid pollution between tabs
    scheduleDate.value = DateTime.now();
    scheduleTime.value = TimeOfDay.now();
  }

  /// Log a completed exercise (Completed tab)
  /// Only sends fields required for completion, never scheduling fields
  Future<void> logExercise() async {
    try {
      EasyLoading.show(status: 'Logging exercise...');
      final response = await _exerciseService.logExercise(
        type: exerciseType.value,
        name: exerciseNameController.text,
        intensity: intensity.value,
        duration: duration.value,
        note: notesController.text,
      );
      if (response == null) {
        EasyLoading.showError('Failed to log exercise. Please try again.');
        return;
      }
      print('✅ Exercise Logged Successfully: ${jsonEncode(response)}');
      final logged = Exercise.fromJson({
        ...response,
        'userId': response['userId'] ?? '',
        'entryType': response['entryType'] ?? 'LOG',
      });
      exercises.insert(0, logged);
      // Update stats
      totalCount.value += 1;
      totalEarnedXp.value += logged.earnedXp;
      exerciseStats.value = ExerciseStats(
        loggedExercises: totalCount.value,
        timeExercises: totalEarnedXp.value,
      );
      EasyLoading.showSuccess('Exercise logged! +${logged.earnedXp} XP');
      _clearFields(); // Always clear all state after logging
    } catch (e) {
      print('❌ Log Exercise Error: $e');
      EasyLoading.showError('Failed to log exercise. Please try again.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Schedule an exercise for the future (Schedule tab)
  /// Only updates nextSchedule, does not add to history list
  Future<void> scheduleExercise() async {
    try {
      EasyLoading.show(status: 'Scheduling exercise...');
      final response = await _exerciseService.scheduleExercise(
        type: exerciseType.value,
        name: exerciseNameController.text,
        intensity: intensity.value,
        duration: duration.value,
        note: notesController.text,
        scheduledAt: DateTime(
          scheduleDate.value.year,
          scheduleDate.value.month,
          scheduleDate.value.day,
          scheduleTime.value.hour,
          scheduleTime.value.minute,
        ),
      );
      if (response == null) {
        EasyLoading.showError('Failed to schedule exercise. Please try again.');
        return;
      }
      print('✅ Exercise Scheduled Successfully: ${jsonEncode(response)}');
      await fetchExerciseHistory();
      EasyLoading.showSuccess('Exercise scheduled!');
      _clearFields();
    } catch (e) {
      print('❌ Schedule Exercise Error: $e');
      EasyLoading.showError('Failed to schedule exercise. Please try again.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Mark a scheduled exercise as taken (PATCH)
  Future<void> markExerciseAsTaken(String exerciseId) async {
    try {
      print(
        '[ExerciseController] 🔄 Starting markExerciseAsTaken for ID: $exerciseId',
      );
      EasyLoading.show(status: 'Marking as taken...');
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();
      if (accessToken == null || refreshToken == null) {
        print('[ExerciseController] ❌ Tokens are null!');
        EasyLoading.showError('Session expired. Please log in again.');
        return;
      }
      final response = await _exerciseService.markExerciseAsTaken(
        exerciseId: exerciseId,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      if (response == null) {
        print('[ExerciseController] ❌ Mark as taken failed');
        EasyLoading.showError('Failed to mark as taken.');
        return;
      }
      print('[ExerciseController] ✅ Marked as taken: $response');
      await fetchExerciseHistory();
      EasyLoading.showSuccess('Exercise marked as taken!');
    } catch (e) {
      print('[ExerciseController] ❌ MarkExerciseAsTaken Error: $e');
      EasyLoading.showError('Failed to mark as taken.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Computed: All scheduled exercises (not taken)
  List<Exercise> get scheduledExercises =>
      exercises.where((e) => !e.isTaken).toList();
  // Computed: All completed exercises (taken)
  List<Exercise> get completedExercises =>
      exercises.where((e) => e.isTaken).toList();
}
