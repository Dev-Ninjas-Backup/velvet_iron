import 'dart:math';

import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/home/models/activity_model.dart';
import 'package:velvet_iron/features/home/models/home_screen_model.dart';
import 'package:velvet_iron/features/home/models/user_model.dart';

class HomeController extends GetxController {
  final selectedMood = 1.obs;
  final isLoading = true.obs;

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final Rx<ActivityModel?> activity = Rx<ActivityModel?>(null);

  final todos = <HomeScreenModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      fetchUserData();
      fetchActivityData();
      fetchTodos();
    } finally {
      isLoading(false);
    }
  }

  void fetchUserData() {
    user.value = UserModel(
      name: "Varga Boglárka",
      title: "Unbound",
      xp: 220,
      profileImage: 'assets/images/homeProfile.png',
    );
  }

  void fetchActivityData() {
    final Random random = Random();
    activity.value = ActivityModel(
      weeklyData: List.generate(
        7,
        (index) => 20 + random.nextDouble() * 80,
      ),
    );
  }

  void fetchTodos() {
    todos.assignAll([
      HomeScreenModel(
        title: "Breakfast",
        sub: "350 kcal",
        time: "Wed - 8:30 AM",
        iconPath: IconPath.todo,
      ),
      HomeScreenModel(
        title: "Ozempic (4mg)",
        sub: "1 Injection",
        time: "Wed - 09:30 AM",
        iconPath: IconPath.todo2,
      ),
      HomeScreenModel(
        title: "Walk the dog",
        sub: "30 minutes",
        time: "Wed - 06:00 PM",
        iconPath: IconPath.grass,
      ),
      HomeScreenModel(
        title: "Vitamin B12 Shot",
        sub: "1 Injection",
        time: "Wed - 07:00 PM",
        iconPath: IconPath.injection,
      ),
    ]);
  }
}
