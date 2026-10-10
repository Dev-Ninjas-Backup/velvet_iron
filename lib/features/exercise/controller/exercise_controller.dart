// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/companion_dialogue_engine.dart';
import 'package:velvet_iron/core/services/notification_service.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/exercise/model/exercise_model.dart';
import 'package:velvet_iron/features/exercise/service/exercise_service.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/features/quests/controller/quest_controller.dart';

class ExerciseController extends GetxController {
  final _exerciseService = ExerciseService();
  final selectedRecurrence = 'DAILY'.obs;

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
  final durationController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchExerciseData();
  }

  @override
  void onClose() {
    exerciseNameController.dispose();
    notesController.dispose();
    durationController.dispose();
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
  final completedDate = DateTime.now().obs;
  final completedTime = TimeOfDay.now().obs;

  void setSelectedDate(DateTime date) {
    scheduleDate.value = date;
  }

  void setSelectedTime(TimeOfDay time) {
    scheduleTime.value = time;
  }

  void setCompletedDate(DateTime date) {
    completedDate.value = date;
  }

  void setCompletedTime(TimeOfDay time) {
    completedTime.value = time;
  }

  final selectedExerciseTab = 0.obs;

  void setExerciseTab(int index) {
    selectedExerciseTab.value = index;
  }

  void _clearFields() {
    exerciseNameController.clear();
    notesController.clear();
    durationController.clear();
    exerciseType.value = 'Cardio'; // Reset dropdown
    intensity.value = 'Medium'; // Reset dropdown
    duration.value = 30;
    exerciseName.value = '';
    notes.value = '';
    // Always reset scheduling and completed state to avoid pollution between tabs
    scheduleDate.value = DateTime.now();
    scheduleTime.value = TimeOfDay.now();
    completedDate.value = DateTime.now();
    completedTime.value = TimeOfDay.now();
  }

  /// Log a completed exercise (Completed tab)
  /// Sends fields required for completion including backdated loggedAt timestamp
  Future<void> logExercise() async {
    try {
      EasyLoading.show(status: 'Logging exercise...');
      final parsedDuration =
          int.tryParse(durationController.text.trim()) ?? duration.value;
      final effectiveDuration = parsedDuration > 0 ? parsedDuration : 30;

      final completedDateTime = DateTime(
        completedDate.value.year,
        completedDate.value.month,
        completedDate.value.day,
        completedTime.value.hour,
        completedTime.value.minute,
      );

      final response = await _exerciseService.logExercise(
        type: exerciseType.value,
        name: exerciseNameController.text,
        intensity: intensity.value,
        duration: effectiveDuration,
        note: notesController.text,
        loggedAt: completedDateTime,
      );
      if (response == null) {
        EasyLoading.showError('Failed to log exercise. Please try again.');
        return;
      }
      print('✅ Exercise Logged Successfully: ${jsonEncode(response)}');
      await fetchExerciseHistory();
      final earnedXp = response['earnedXp'] ?? 10;
      EasyLoading.showSuccess('Exercise logged! +$earnedXp XP');
      _clearFields();

      // Auto-complete corresponding Codex quest and sync
      if (Get.isRegistered<QuestController>()) {
        Get.find<QuestController>().onActivityLogged('exercise');
      }
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchData();
      }

      CompanionDialogueEngine.showDialogueSnackbar(
        trigger: 'Workout Completed',
      );
    } catch (e) {
      print('❌ Log Exercise Error: $e');
      EasyLoading.showError('Failed to log exercise. Please try again.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Schedule an exercise for the future (Schedule tab)
  Future<void> scheduleExercise() async {
    try {
      EasyLoading.show(status: 'Scheduling exercise...');
      final scheduledDateTime = DateTime(
        scheduleDate.value.year,
        scheduleDate.value.month,
        scheduleDate.value.day,
        scheduleTime.value.hour,
        scheduleTime.value.minute,
      );

      final parsedDuration =
          int.tryParse(durationController.text.trim()) ?? duration.value;
      final effectiveDuration = parsedDuration > 0 ? parsedDuration : 30;

      final response = await _exerciseService.scheduleExercise(
        type: exerciseType.value,
        name: exerciseNameController.text,
        intensity: intensity.value,
        duration: effectiveDuration,
        note: notesController.text,
        scheduledAt: scheduledDateTime,
      );
      if (response == null) {
        EasyLoading.showError('Failed to schedule exercise. Please try again.');
        return;
      }
      print('✅ Exercise Scheduled Successfully: ${jsonEncode(response)}');

      // Schedule notification reminder
      final exerciseId = response['id']?.toString() ?? '';
      final notifId = (exerciseId.hashCode & 0x7FFFFFFF);
      await NotificationService.scheduleItemReminder(
        id: notifId,
        title: 'Workout Reminder',
        body: 'Time for your scheduled ${exerciseNameController.text.isNotEmpty ? exerciseNameController.text : exerciseType.value} session!',
        scheduledAt: scheduledDateTime,
      );

      await fetchExerciseHistory();
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchData();
      }
      EasyLoading.showSuccess('Exercise scheduled!');
      _clearFields();
      CompanionDialogueEngine.showDialogueSnackbar(
        trigger: 'Workout / Exercise Started',
      );
    } catch (e) {
      print('❌ Schedule Exercise Error: $e');
      EasyLoading.showError('Failed to schedule exercise. Please try again.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Delete a scheduled exercise
  Future<void> deleteExerciseSchedule(String exerciseId) async {
    try {
      EasyLoading.show(status: 'Deleting exercise...');
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();
      if (accessToken == null || refreshToken == null) {
        EasyLoading.showError('Session expired.');
        return;
      }

      final success = await _exerciseService.deleteExerciseSchedule(
        exerciseId: exerciseId,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      if (success) {
        // Cancel reminder
        await NotificationService.cancelItemReminder(exerciseId.hashCode & 0x7FFFFFFF);
        exercises.removeWhere((e) => e.id == exerciseId);
        EasyLoading.showSuccess('Exercise removed');
        await fetchExerciseHistory();
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchData();
        }
      } else {
        EasyLoading.showError('Failed to delete exercise.');
      }
    } catch (e) {
      EasyLoading.showError('Error: $e');
    }
  }

  /// Edit a scheduled exercise
  Future<void> editExerciseSchedule({
    required String exerciseId,
    required String type,
    required String name,
    required String intensity,
    required int duration,
    required String note,
    required DateTime scheduledAt,
  }) async {
    try {
      EasyLoading.show(status: 'Updating exercise...');
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();
      if (accessToken == null || refreshToken == null) {
        EasyLoading.showError('Session expired.');
        return;
      }

      final updated = await _exerciseService.updateExerciseSchedule(
        exerciseId: exerciseId,
        type: type,
        name: name,
        intensity: intensity,
        duration: duration,
        note: note,
        scheduledAt: scheduledAt,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      if (updated != null) {
        final notifId = (exerciseId.hashCode & 0x7FFFFFFF);
        await NotificationService.cancelItemReminder(notifId);
        await NotificationService.scheduleItemReminder(
          id: notifId,
          title: 'Workout Reminder',
          body: 'Time for your scheduled $name session!',
          scheduledAt: scheduledAt,
        );
        EasyLoading.showSuccess('Exercise updated');
        await fetchExerciseHistory();
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchData();
        }
      } else {
        EasyLoading.showError('Failed to update exercise.');
      }
    } catch (e) {
      EasyLoading.showError('Error: $e');
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

      // Cancel reminder once completed
      await NotificationService.cancelItemReminder(exerciseId.hashCode & 0x7FFFFFFF);

      await fetchExerciseHistory();
      EasyLoading.showSuccess('Exercise marked as taken!');

      // Auto-complete corresponding quest if active
      if (Get.isRegistered<QuestController>()) {
        Get.find<QuestController>().onActivityLogged('exercise');
      }
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchData();
      }

      CompanionDialogueEngine.showDialogueSnackbar(
        trigger: 'Workout Completed',
      );
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
