// ignore_for_file: avoid_print

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
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

  // Active companion image
  final activeCompanionImage = Rx<String?>(null);
  final activeCompanionName = Rx<String?>(null);

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

  // ── Mood logging state ───────────────────────────────────────

  /// Check if user has logged mood for today
  bool get hasMoodLoggedToday {
    final todayMood = userProfile.value?.todayMood;
    if (todayMood == null) return false;

    final today = DateTime.now();
    final moodDate = DateTime(
      todayMood.loggedAt.year,
      todayMood.loggedAt.month,
      todayMood.loggedAt.day,
    );
    final todayDate = DateTime(today.year, today.month, today.day);

    return moodDate.compareTo(todayDate) == 0;
  }

  /// Get today's mood if logged
  TodayMood? get todayMoodData => userProfile.value?.todayMood;

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

  /// Navigate to MoodLog tab in Daily Logs screen
  void navigateToMoodLog() {
    try {
      Get.toNamed('/dailyLogScreen');
      Future.delayed(const Duration(milliseconds: 100), () {
        try {
          final dailyLogController = Get.find<DailyLogController>();
          dailyLogController.setTab(1);
          print('[HomeController] Navigated to MoodLog tab');
        } catch (e) {
          print('[HomeController] Error setting MoodLog tab: $e');
        }
      });
    } catch (e) {
      print('[HomeController] Error navigating to MoodLog: $e');
    }
  }

  // ── Lifecycle ────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    fetchData();
    fetchActiveCompanion();

    // Rebuild todos when filter changes
    ever(selectedTodoFilter, (_) {
      _buildTodos();
    });
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
      print('[HomeController] hasMoodLoggedToday → $hasMoodLoggedToday');
      if (todayMoodData != null) {
        print(
          '[HomeController] todayMoodData  → mood: ${todayMoodData!.mood}, loggedAt: ${todayMoodData!.loggedAt}',
        );
      }
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

  /// Fetch active companion from API
  Future<void> fetchActiveCompanion() async {
    try {
      final companionData = await HomeService().fetchActiveCompanion();
      if (companionData != null) {
        activeCompanionImage.value = companionData['imagePath'] as String?;
        activeCompanionName.value = companionData['name'] as String?;
        print(
          '[HomeController] Active Companion: ${activeCompanionName.value} → ${activeCompanionImage.value}',
        );
      }
    } catch (e) {
      print('[HomeController] Error fetching companion: $e');
    }
  }

  // ── Mock data (remove once API is wired up) ──────────────────

  // ── Todos ────────────────────────────────────────────────────

  void _buildTodos() {
    final profile = userProfile.value;
    if (profile == null) {
      todos.clear();
      return;
    }

    List<ScheduleItem> scheduleItems = [];

    // Get the appropriate schedule based on filter
    if (selectedTodoFilter.value == 'Weekly') {
      scheduleItems = profile.thisWeek.combined;
    } else if (selectedTodoFilter.value == 'Monthly') {
      scheduleItems = profile.thisMonth.combined;
    } else {
      // Default: 'Today'
      scheduleItems = profile.todaySchedules.combined;
    }

    // Convert ScheduleItem to HomeScreenModel
    todos.assignAll(
      scheduleItems.map((item) {
        final iconPath = _getIconPathForScheduleType(item.type);
        return HomeScreenModel(
          title: item.title,
          sub: item.description,
          time: item.scheduledAt,
          iconPath: iconPath,
          xp: item.earnedXp,
          isChecked: item.details.isTaken.obs,
        );
      }).toList(),
    );

    print(
      '[HomeController] _buildTodos() → ${todos.length} items built for ${selectedTodoFilter.value}',
    );
  }

  /// Map ScheduleType to icon path
  String _getIconPathForScheduleType(ScheduleType type) {
    switch (type) {
      case ScheduleType.medication:
        return IconPath.injection;
      case ScheduleType.exercise:
        return IconPath.grass;
      case ScheduleType.meal:
        return IconPath.todo;
    }
  }
}
