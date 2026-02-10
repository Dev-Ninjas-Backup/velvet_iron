import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/exercise/model/exercise_model.dart';

class ExerciseController extends GetxController {
  final isLoading = true.obs;

  // Exercise Stats
  final exerciseStats = ExerciseStats(
    loggedExercises: 0,
    timeExercises: 0,
  ).obs;

  // Exercise History
  final exercises = <Exercise>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchExerciseData();
  }

  Future<void> fetchExerciseData() async {
    try {
      isLoading(true);
      await Future.wait([
        fetchExerciseStats(),
        fetchExerciseHistory(),
      ]);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchExerciseStats() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    exerciseStats.value = ExerciseStats(
      loggedExercises: 64,
      timeExercises: 120,
    );
  }

  Future<void> fetchExerciseHistory() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    exercises.assignAll([
      Exercise(
        id: '1',
        name: 'Yoga Meditation',
        type: 'Cardio',
        duration: 30,
        intensity: 'Medium',
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        isCompleted: true,
      ),
      Exercise(
        id: '2',
        name: 'Running',
        type: 'Cardio',
        duration: 30,
        intensity: 'High',
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        isCompleted: true,
      ),
      Exercise(
        id: '3',
        name: 'Squats',
        type: 'Strength',
        duration: 30,
        intensity: 'High',
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        isCompleted: true,
      ),
    ]);
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

  void logExercise() {
    // Logic to add a new exercise will go here
    // This will be called when the user clicks the "Log Exercise" button
    // This would typically involve making a POST request to an API
  }

  void scheduleExercise() {
    // Logic to schedule a new exercise will go here
    // This would typically involve making a POST request to an API
  }
}
