// ignore_for_file: avoid_print

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/home/models/home_screen_model.dart';
import 'package:velvet_iron/features/home/service/home_service.dart';

class HomeController extends GetxController {
  final selectedMood = 1.obs;
  final isLoading = true.obs;

  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  final todos = <HomeScreenModel>[].obs;

  // ── Chart filter: 'currentWeek' | 'lastWeek' ────────────────
  final selectedChartFilter = 'currentWeek'.obs;

  // ── Todo filter: 'Today' | 'Weekly' | 'Monthly' ──────────────
  final selectedTodoFilter = 'Today'.obs;

  // ── Convenience getters ──────────────────────────────────────

  String get userName => userProfile.value?.userName ?? '';
  String get levelStatus => userProfile.value?.levelStatus ?? '';
  int get balanceXp => userProfile.value?.balanceXp ?? 0;
  int get currentLevel => userProfile.value?.level ?? 0;
  int get nextLevelXp => userProfile.value?.nextLevel.xpRequired ?? 0;
  double get xpProgress => nextLevelXp > 0 ? balanceXp / nextLevelXp : 0.0;

  String get companionName =>
      userProfile.value?.activeCompanion?.companion.name ?? '';
  String get companionTitle =>
      userProfile.value?.activeCompanion?.companion.title ?? '';
  String get companionQuote =>
      userProfile.value?.activeCompanion?.companion.quote ?? '';

  String get themeName => userProfile.value?.activeTheme?.theme.name ?? '';

  int get totalWeeklyXp => userProfile.value?.xpCharts.currentWeek.totalXp ?? 0;

  // ── Chart data based on selected filter ─────────────────────

  List<double> get chartData {
    final profile = userProfile.value;
    if (profile == null) return List.filled(7, 0.0);

    if (selectedChartFilter.value == 'lastWeek') {
      return profile.xpCharts.lastWeek.data
          .map((d) => d.xp.toDouble())
          .toList();
    }

    // default: currentWeek
    return profile.xpCharts.currentWeek.data
        .map((d) => d.xp.toDouble())
        .toList();
  }

  void selectChartFilter(String filter) {
    selectedChartFilter.value = filter;
    print('[HomeController] Chart filter changed → $filter');
    print('[HomeController] Chart data → $chartData');
  }

  // ── Lifecycle ────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // ── Data fetching ────────────────────────────────────────────

  Future<void> fetchData() async {
    try {
      isLoading(true);
      print(
        '[HomeController] fetchData() started: Hitting the user profile API...',
      );

      try {
        userProfile.value = await HomeService().getProfile();
        print('[HomeController] API Response received and parsed successfully');
      } catch (e) {
        print('[HomeController] API Error: $e');
        print('[HomeController] Falling back to mock data...');
        EasyLoading.showError('Failed to load data.');
      }

      _buildTodos();

      print('[HomeController] API data mapped to controller properties:');
      print('[HomeController] levelStatus    → $levelStatus');
      print('[HomeController] balanceXp      → $balanceXp');
      print('[HomeController] currentLevel   → $currentLevel');
      print('[HomeController] nextLevelXp    → $nextLevelXp');
      print('[HomeController] xpProgress     → $xpProgress');
      print('[HomeController] companionName  → $companionName');
      print('[HomeController] companionTitle → $companionTitle');
      print('[HomeController] companionQuote → $companionQuote');
      print('[HomeController] themeName      → $themeName');
      print('[HomeController] totalWeeklyXp  → $totalWeeklyXp');
      print(
        '[HomeController] currentWeek XP → ${userProfile.value?.xpCharts.currentWeek.data.map((d) => '${d.day}: ${d.xp}xp').toList()}',
      );
      print(
        '[HomeController] lastWeek XP    → ${userProfile.value?.xpCharts.lastWeek.data.map((d) => '${d.day}: ${d.xp}xp').toList()}',
      );
      print(
        '[HomeController] todos          → ${todos.map((t) => t.title).toList()}',
      );
    } finally {
      isLoading(false);
      print('[HomeController] fetchData() completed');
    }
  }

  // ── Mock data (remove once API is wired up) ──────────────────

  // ── Todos ────────────────────────────────────────────────────

  void _buildTodos() {
    todos.assignAll([
      HomeScreenModel(
        title: "Breakfast",
        sub: "350 kcal",
        time: "Wed - 8:30 AM",
        iconPath: IconPath.todo,
        xp: 15,
      ),
      HomeScreenModel(
        title: "Ozempic (4mg)",
        sub: "1 Injection",
        time: "Wed - 09:30 AM",
        iconPath: IconPath.injection,
        xp: 10,
      ),
      HomeScreenModel(
        title: "Walk the dog",
        sub: "30 minutes",
        time: "Wed - 06:00 PM",
        iconPath: IconPath.grass,
        xp: 20,
      ),
      HomeScreenModel(
        title: "Vitamin B12 Shot",
        sub: "1 Injection",
        time: "Wed - 07:00 PM",
        iconPath: IconPath.injection,
        xp: 10,
      ),
    ]);

    print('[HomeController] _buildTodos() → ${todos.length} items built');
  }
}
