// ignore_for_file: avoid_print

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/companion_dialogue_engine.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/home/models/home_screen_model.dart';
import 'package:velvet_iron/features/home/service/home_service.dart';
import 'package:velvet_iron/features/quests/controller/quest_controller.dart';
import 'package:velvet_iron/features/quests/model/quest_model.dart';

class HomeController extends GetxController {
  final selectedMood = 1.obs;
  final isLoading = true.obs;

  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  final profilePhotoUrl = Rx<String?>(null);
  final todos = <HomeScreenModel>[].obs;

  // ── Chart filter: 'currentWeek' | 'lastWeek' ────────────────
  final selectedChartFilter = 'currentWeek'.obs;

  // ── Todo filter: 'Today' | 'Weekly' | 'Monthly' ──────────────
  final selectedTodoFilter = 'Today'.obs;

  // Active companion image & dialogue
  final activeCompanionImage = Rx<String?>(null);
  final activeCompanionName = Rx<String?>(null);
  final dailyRewardQuote = Rx<String?>(null);
  final companionGreeting = Rx<String?>(null);

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
    return userProfile.value?.todayMood != null;
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
    _loadCachedProfilePhoto();
    _loadCachedCompanion();
    fetchData();
    fetchActiveCompanion();

    // Ensure QuestController is active
    final questController = Get.isRegistered<QuestController>()
        ? Get.find<QuestController>()
        : Get.put(QuestController(), permanent: true);

    // Rebuild todos when filter changes
    ever(selectedTodoFilter, (_) {
      _buildTodos();
    });

    // Rebuild todos when quests update
    ever(questController.questsData, (_) {
      _buildTodos();
    });
  }

  Future<void> _loadCachedProfilePhoto() async {
    final cached = await SharedPreferencesHelper.getAvatar();
    if (cached != null && cached.isNotEmpty) {
      profilePhotoUrl.value = cached;
    }
  }

  Future<void> _loadCachedCompanion() async {
    final cached = await SharedPreferencesHelper.getActiveCompanion();
    if (cached != null) {
      activeCompanionName.value = cached['name'];
      activeCompanionImage.value = cached['imagePath'];
      await _updateDialogueQuotes();
    }
  }

  Future<void> _updateDialogueQuotes() async {
    final companion = activeCompanionName.value ?? 'Thyra';
    dailyRewardQuote.value = await CompanionDialogueEngine().getDialogue(
      companionName: companion,
      trigger: 'Streak',
    );
    companionGreeting.value = await CompanionDialogueEngine().getDialogue(
      companionName: companion,
      trigger: 'App Open / Welcome Back',
    );
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

        final effectiveImage = userProfile.value?.effectiveProfileImage;
        if (effectiveImage != null && effectiveImage.isNotEmpty) {
          profilePhotoUrl.value = effectiveImage;
          await SharedPreferencesHelper.saveAvatar(effectiveImage);
        } else {
          final cached = await SharedPreferencesHelper.getAvatar();
          if (cached != null && cached.isNotEmpty) {
            profilePhotoUrl.value = cached;
          }
        }
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
        await _updateDialogueQuotes();
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
    List<ScheduleItem> scheduleItems = [];

    if (profile != null) {
      if (selectedTodoFilter.value == 'Weekly') {
        scheduleItems = profile.thisWeek.combined;
      } else if (selectedTodoFilter.value == 'Monthly') {
        scheduleItems = profile.thisMonth.combined;
      } else {
        // Default: 'Today'
        scheduleItems = profile.todaySchedules.combined;
      }
    }

    final items = <HomeScreenModel>[];

    // 1. Scheduled activities (medication, exercise, meals)
    for (final item in scheduleItems) {
      final iconPath = _getIconPathForScheduleType(item.type);
      items.add(
        HomeScreenModel(
          id: item.id,
          title: item.title,
          sub: item.description,
          time: item.scheduledAt,
          iconPath: iconPath,
          xp: item.earnedXp,
          isChecked: item.details.isTaken.obs,
        ),
      );
    }

    // 2. Active daily quests from QuestController (populate on Home screen)
    final questController = Get.isRegistered<QuestController>()
        ? Get.find<QuestController>()
        : Get.put(QuestController(), permanent: true);

    var quests = questController.questsData.value?.quests;
    if (quests == null || quests.isEmpty) {
      // Heroic daily quests fallback so Today's Quests is always populated
      quests = const [
        Quest(
          id: 'daily_water',
          title: 'Hydration of the Ancients',
          description: 'Drink 8 glasses of water throughout the day',
          xp: 15,
          isDone: false,
        ),
        Quest(
          id: 'daily_steps',
          title: 'Stride of the Ranger',
          description: 'Walk 5,000 steps or complete active movement',
          xp: 25,
          isDone: false,
        ),
        Quest(
          id: 'daily_mindful',
          title: 'Codex Reflection',
          description: 'Log your daily mood & check in with your companion',
          xp: 10,
          isDone: false,
        ),
      ];
    }

    for (final quest in quests) {
      items.add(
        HomeScreenModel(
          id: quest.id,
          title: quest.title,
          sub: quest.description,
          time: 'Active Quest',
          iconPath: IconPath.todo,
          xp: quest.xp,
          isChecked: quest.isDone.obs,
          onToggle: () {
            questController.completeQuest(quest.id);
          },
        ),
      );
    }

    todos.assignAll(items);

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
