import 'package:get/get.dart';
import 'package:velvet_iron/features/exercise/model/exercise_model.dart';

class ExerciseController extends GetxController {
  // Exercise Stats
  final exerciseStats = ExerciseStats(
    loggedExercises: 64,
    timeExercises: 120,
  ).obs;

  // Exercise History
  final exercises = <Exercise>[
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
  ].obs;

  // Form state
  final exerciseType = 'Cardio'.obs;
  final exerciseName = ''.obs;
  final duration = 30.obs;
  final intensity = 'Medium'.obs;
  final notes = ''.obs;
  final scheduleDate = DateTime.now().obs;
  final selectedExerciseTab = 0.obs;

  void setExerciseTab(int index) {
    selectedExerciseTab.value = index;
  }

  void logExercise() {
    // Logic to add a new exercise will go here
    // This will be called when the user clicks the "Log Exercise" button
  }

  void scheduleExercise() {
    // Logic to schedule a new exercise will go here
  }
}
