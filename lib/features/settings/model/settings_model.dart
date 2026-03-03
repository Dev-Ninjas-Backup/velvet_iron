class UserProfileModel {
  final String id;
  final String userId;
  final String? activeThemeId;
  final String? activeCompanionId;
  final List<dynamic> availableCompanions;
  final int themeCredits;
  final int companionCredits;
  final int totalEarnXp;
  final int balanceXp;
  final int level;
  final bool onBoardingCompleted;
  final String? fitnessGoal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserInfo user;
  final String? profilePhoto;
  final String userName;
  final dynamic activeTheme;
  final dynamic activeCompanion;
  final String levelStatus;
  final NextLevel nextLevel;
  final XPCharts xpCharts;
  final TodaySchedules todaySchedules;
  final ThisPeriod thisWeek;
  final ThisPeriod thisMonth;
  final dynamic todayMood;
  final UpcomingItem? upcoming;

  UserProfileModel({
    required this.id,
    required this.userId,
    this.activeThemeId,
    this.activeCompanionId,
    required this.availableCompanions,
    required this.themeCredits,
    required this.companionCredits,
    required this.totalEarnXp,
    required this.balanceXp,
    required this.level,
    required this.onBoardingCompleted,
    this.fitnessGoal,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.profilePhoto,
    required this.userName,
    this.activeTheme,
    this.activeCompanion,
    required this.levelStatus,
    required this.nextLevel,
    required this.xpCharts,
    required this.todaySchedules,
    required this.thisWeek,
    required this.thisMonth,
    this.todayMood,
    this.upcoming,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      userId: json['userId'],
      activeThemeId: json['activeThemeId'],
      activeCompanionId: json['activeCompanionId'],
      availableCompanions: json['availableCompanions'] ?? [],
      themeCredits: json['themeCredits'] ?? 0,
      companionCredits: json['companionCredits'] ?? 0,
      totalEarnXp: json['totalEarnXp'] ?? 0,
      balanceXp: json['balanceXp'] ?? 0,
      level: json['level'] ?? 1,
      onBoardingCompleted: json['onBoardingCompleted'] ?? false,
      fitnessGoal: json['fitnessGoal'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: UserInfo.fromJson(json['user']),
      profilePhoto: json['profilePhoto'],
      userName: json['userName'] ?? '',
      activeTheme: json['activeTheme'],
      activeCompanion: json['activeCompanion'],
      levelStatus: json['levelStatus'] ?? '',
      nextLevel: NextLevel.fromJson(json['nextLevel']),
      xpCharts: XPCharts.fromJson(json['XPcharts']),
      todaySchedules: TodaySchedules.fromJson(json['todaySchedules']),
      thisWeek: ThisPeriod.fromJson(json['thisWeek']),
      thisMonth: ThisPeriod.fromJson(json['thisMonth']),
      todayMood: json['todayMood'],
      upcoming: json['upcoming'] != null
          ? UpcomingItem.fromJson(json['upcoming'])
          : null,
    );
  }
}

// ─── User Info ───────────────────────────────────────────────────────────────

class UserInfo {
  final UserProfileXp userProfile;
  final String name;

  UserInfo({required this.userProfile, required this.name});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userProfile: UserProfileXp.fromJson(json['userProfile']),
      name: json['name'] ?? '',
    );
  }
}

class UserProfileXp {
  final int balanceXp;

  UserProfileXp({required this.balanceXp});

  factory UserProfileXp.fromJson(Map<String, dynamic> json) {
    return UserProfileXp(balanceXp: json['balanceXp'] ?? 0);
  }
}

// ─── Next Level ───────────────────────────────────────────────────────────────

class NextLevel {
  final int level;
  final int xpRequired;

  NextLevel({required this.level, required this.xpRequired});

  factory NextLevel.fromJson(Map<String, dynamic> json) {
    return NextLevel(
      level: json['level'] ?? 0,
      xpRequired: json['xpRequired'] ?? 0,
    );
  }
}

// ─── XP Charts ───────────────────────────────────────────────────────────────

class XPCharts {
  final XPChartPeriod weekly;
  final XPChartPeriod monthly;

  XPCharts({required this.weekly, required this.monthly});

  factory XPCharts.fromJson(Map<String, dynamic> json) {
    return XPCharts(
      weekly: XPChartPeriod.fromJson(json['weekly']),
      monthly: XPChartPeriod.fromJson(json['monthly']),
    );
  }
}

class XPChartPeriod {
  final String period;
  final int totalXp;
  final List<XPChartData> data;

  XPChartPeriod({
    required this.period,
    required this.totalXp,
    required this.data,
  });

  factory XPChartPeriod.fromJson(Map<String, dynamic> json) {
    return XPChartPeriod(
      period: json['period'] ?? '',
      totalXp: json['totalXp'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => XPChartData.fromJson(e))
          .toList(),
    );
  }
}

class XPChartData {
  // Weekly fields
  final String? day;
  final String? dateLabel;
  final String? isoDate;
  // Monthly fields
  final String? week;
  final String? startDate;
  final String? endDate;
  // Common
  final int xp;
  final int logsCount;

  XPChartData({
    this.day,
    this.dateLabel,
    this.isoDate,
    this.week,
    this.startDate,
    this.endDate,
    required this.xp,
    required this.logsCount,
  });

  factory XPChartData.fromJson(Map<String, dynamic> json) {
    return XPChartData(
      day: json['day'],
      dateLabel: json['dateLabel'],
      isoDate: json['isoDate'],
      week: json['week'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      xp: json['xp'] ?? 0,
      logsCount: json['logsCount'] ?? 0,
    );
  }
}

// ─── Today Schedules ─────────────────────────────────────────────────────────

class TodaySchedules {
  final List<ScheduleItem> combined;

  TodaySchedules({required this.combined});

  factory TodaySchedules.fromJson(Map<String, dynamic> json) {
    return TodaySchedules(
      combined: (json['combined'] as List<dynamic>? ?? [])
          .map((e) => ScheduleItem.fromJson(e))
          .toList(),
    );
  }
}

class ScheduleItem {
  final String id;
  final String type; // 'medication' or 'exercise'
  final String title;
  final String description;
  final String scheduledAt;
  final ScheduleDetails details;

  ScheduleItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.scheduledAt,
    required this.details,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id'],
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      scheduledAt: json['scheduledAt'] ?? '',
      details: ScheduleDetails.fromJson(json['details']),
    );
  }
}

class ScheduleDetails {
  final String type;
  final bool isTaken;
  // Medication fields
  final int? doseMg;
  // Exercise fields
  final String? intensity;
  final int? duration;
  final String? note;

  ScheduleDetails({
    required this.type,
    required this.isTaken,
    this.doseMg,
    this.intensity,
    this.duration,
    this.note,
  });

  factory ScheduleDetails.fromJson(Map<String, dynamic> json) {
    return ScheduleDetails(
      type: json['type'] ?? '',
      isTaken: json['isTaken'] ?? false,
      doseMg: json['doseMg'],
      intensity: json['intensity'],
      duration: json['duration'],
      note: json['note'],
    );
  }
}

// ─── This Week / This Month ───────────────────────────────────────────────────

class ThisPeriod {
  final List<dynamic> combined;
  final int totalMeals;
  final int totalMedications;
  final int totalExercises;

  ThisPeriod({
    required this.combined,
    required this.totalMeals,
    required this.totalMedications,
    required this.totalExercises,
  });

  factory ThisPeriod.fromJson(Map<String, dynamic> json) {
    return ThisPeriod(
      combined: json['combined'] ?? [],
      totalMeals: json['totalMeals'] ?? 0,
      totalMedications: json['totalMedications'] ?? 0,
      totalExercises: json['totalExercises'] ?? 0,
    );
  }
}

// ─── Upcoming ────────────────────────────────────────────────────────────────

class UpcomingItem {
  final String id;
  final String type;
  final String title;
  final String description;
  final String scheduledAt;
  final int earnedXp;
  final ScheduleDetails details;

  UpcomingItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.scheduledAt,
    required this.earnedXp,
    required this.details,
  });

  factory UpcomingItem.fromJson(Map<String, dynamic> json) {
    return UpcomingItem(
      id: json['id'],
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      scheduledAt: json['scheduledAt'] ?? '',
      earnedXp: json['earnedXp'] ?? 0,
      details: ScheduleDetails.fromJson(json['details']),
    );
  }
}
