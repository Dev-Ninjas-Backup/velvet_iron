// ignore_for_file: avoid_print

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
    fetchActiveCompanion();
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
        _loadMockProfile();
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

  void _loadMockProfile() {
    userProfile.value = UserProfile.fromJson({
      "id": "d47088b7-0ff7-4ada-a4b5-a257ae2a19de",
      "userId": "b2ffb21e-c701-4b2e-b9c8-449ae7963770",
      "activeThemeId": null,
      "activeCompanionId": null,
      "availableCompanions": [],
      "themeCredits": 0,
      "companionCredits": 0,
      "totalEarnXp": 810,
      "balanceXp": 810,
      "level": 3,
      "onBoardingCompleted": false,
      "fitnessGoal": "Transform my body and grow stronger",
      "createdAt": "2026-03-04T19:35:20.187Z",
      "updatedAt": "2026-03-06T16:39:56.069Z",
      "profilePhoto": null,
      "userName": "shahria",
      "activeTheme": {
        "theme": {
          "id": "842fea8e-38b0-470e-b7b8-e5b79a1040ac",
          "name": "Reader",
          "tagline": "Knowledge is Power",
          "description": "For those who find wisdom in books and stories",
          "unlockXp": 250,
          "createdAt": "2026-02-25T18:51:52.572Z",
        },
      },
      "activeCompanion": {
        "companion": {
          "id": "6ea950a3-e4ed-4d02-a574-45ed38fe8aaa",
          "name": "Pyraxis",
          "title": "The Emberbound",
          "quote":
              "Rise, little warrior. I don't guard the weak — I forge the strong.",
          "unlockXp": 250,
          "createdAt": "2026-02-25T18:51:52.612Z",
        },
      },
      "levelStatus": "Novice",
      "nextLevel": {"level": 4, "xpRequired": 850},
      "XPcharts": {
        "currentWeek": {
          "period": "week",
          "timezone": "Asia/Dhaka",
          "data": [
            {
              "day": "Sunday",
              "dateLabel": "",
              "isoDate": "2026-03-01",
              "xp": 0,
              "logsCount": 0,
            },
            {
              "day": "Monday",
              "dateLabel": "",
              "isoDate": "2026-03-02",
              "xp": 0,
              "logsCount": 0,
            },
            {
              "day": "Tuesday",
              "dateLabel": "",
              "isoDate": "2026-03-03",
              "xp": 0,
              "logsCount": 0,
            },
            {
              "day": "Wednesday",
              "dateLabel": "",
              "isoDate": "2026-03-04",
              "xp": 0,
              "logsCount": 0,
            },
            {
              "day": "Thursday",
              "dateLabel": "",
              "isoDate": "2026-03-05",
              "xp": 800,
              "logsCount": 31,
            },
            {
              "day": "Friday",
              "dateLabel": "",
              "isoDate": "2026-03-06",
              "xp": 10,
              "logsCount": 1,
            },
            {
              "day": "Saturday",
              "dateLabel": "",
              "isoDate": "2026-03-07",
              "xp": 0,
              "logsCount": 0,
            },
          ],
          "totalXp": 810,
        },
        "lastWeek": {
          "period": "lastWeek",
          "timezone": "Asia/Dhaka",
          "data": [
            {
              "day": "Sunday",
              "dateLabel": "",
              "isoDate": "2026-02-22",
              "xp": 0,
              "logsCount": 0,
            },
            {
              "day": "Monday",
              "dateLabel": "",
              "isoDate": "2026-02-23",
              "xp": 0,
              "logsCount": 0,
            },
            {
              "day": "Tuesday",
              "dateLabel": "",
              "isoDate": "2026-02-24",
              "xp": 0,
              "logsCount": 0,
            },
            {
              "day": "Wednesday",
              "dateLabel": "",
              "isoDate": "2026-02-25",
              "xp": 0,
              "logsCount": 0,
            },
            {
              "day": "Thursday",
              "dateLabel": "",
              "isoDate": "2026-02-26",
              "xp": 0,
              "logsCount": 0,
            },
            {
              "day": "Friday",
              "dateLabel": "",
              "isoDate": "2026-02-27",
              "xp": 0,
              "logsCount": 0,
            },
            {
              "day": "Saturday",
              "dateLabel": "",
              "isoDate": "2026-02-28",
              "xp": 0,
              "logsCount": 0,
            },
          ],
          "totalXp": 0,
        },
      },
      "todaySchedules": {"combined": []},
      "thisWeek": {
        "combined": [
          {
            "id": "68dd1598-1014-461e-ae43-5347eba63e8e",
            "type": "medication",
            "title": "dsd",
            "description": "CAPSULE • 32mg",
            "scheduledAt": "Thursday, March 5, 2026 at 3:04 AM",
            "earnedXp": 10,
            "details": {"type": "CAPSULE", "doseMg": 32, "isTaken": false},
          },
          {
            "id": "11e2d435-f7cb-4441-aa80-b5a441705575",
            "type": "medication",
            "title": "popo",
            "description": "CAPSULE • 500mg",
            "scheduledAt": "Thursday, March 5, 2026 at 3:03 AM",
            "earnedXp": 10,
            "details": {"type": "CAPSULE", "doseMg": 500, "isTaken": false},
          },
          {
            "id": "9f80f412-4297-4f29-83dc-45178be3dd5a",
            "type": "exercise",
            "title": "ttt",
            "description": "CARDIO • HIGH • 33 min",
            "scheduledAt": "Thursday, March 5, 2026 at 5:48 AM",
            "earnedXp": 10,
            "details": {
              "type": "CARDIO",
              "intensity": "HIGH",
              "duration": 33,
              "isTaken": false,
            },
          },
        ],
        "totalMeals": 0,
        "totalMedications": 2,
        "totalExercises": 1,
      },
      "thisMonth": {
        "combined": [],
        "totalMeals": 0,
        "totalMedications": 2,
        "totalExercises": 1,
      },
      "todayMood": null,
      "upcoming": null,
      "user": {
        "name": "shahria",
        "userProfile": {"balanceXp": 810},
      },
    });

    print(
      '[HomeController] userProfile loaded → ${userProfile.value?.userName}',
    );
  }

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
