import 'package:get/get.dart';

class UserProfile {
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
  final String fitnessGoal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? profilePhoto;
  final String userName;
  final ActiveTheme? activeTheme;
  final ActiveCompanion? activeCompanion;
  final String levelStatus;
  final NextLevel nextLevel;
  final XPCharts xpCharts;
  final TodaySchedules todaySchedules;
  final WeeklyActivity thisWeek;
  final WeeklyActivity thisMonth;
  final dynamic todayMood;
  final dynamic upcoming;
  final UserInfo user;

  const UserProfile({
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
    required this.fitnessGoal,
    required this.createdAt,
    required this.updatedAt,
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
    required this.user,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      activeThemeId: json['activeThemeId'] as String?,
      activeCompanionId: json['activeCompanionId'] as String?,
      availableCompanions: json['availableCompanions'] as List<dynamic>? ?? [],
      themeCredits: json['themeCredits'] as int,
      companionCredits: json['companionCredits'] as int,
      totalEarnXp: json['totalEarnXp'] as int,
      balanceXp: json['balanceXp'] as int,
      level: json['level'] as int,
      onBoardingCompleted: json['onBoardingCompleted'] as bool,
      fitnessGoal: json['fitnessGoal'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      profilePhoto: json['profilePhoto'] as String?,
      userName: json['userName'] as String,
      activeTheme: json['activeTheme'] != null
          ? ActiveTheme.fromJson(json['activeTheme'] as Map<String, dynamic>)
          : null,
      activeCompanion: json['activeCompanion'] != null
          ? ActiveCompanion.fromJson(
              json['activeCompanion'] as Map<String, dynamic>,
            )
          : null,
      levelStatus: json['levelStatus'] as String,
      nextLevel: NextLevel.fromJson(json['nextLevel'] as Map<String, dynamic>),
      xpCharts: XPCharts.fromJson(json['XPcharts'] as Map<String, dynamic>),
      todaySchedules: TodaySchedules.fromJson(
        json['todaySchedules'] as Map<String, dynamic>,
      ),
      thisWeek: WeeklyActivity.fromJson(
        json['thisWeek'] as Map<String, dynamic>,
      ),
      thisMonth: WeeklyActivity.fromJson(
        json['thisMonth'] as Map<String, dynamic>,
      ),
      todayMood: json['todayMood'],
      upcoming: json['upcoming'],
      user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'activeThemeId': activeThemeId,
    'activeCompanionId': activeCompanionId,
    'availableCompanions': availableCompanions,
    'themeCredits': themeCredits,
    'companionCredits': companionCredits,
    'totalEarnXp': totalEarnXp,
    'balanceXp': balanceXp,
    'level': level,
    'onBoardingCompleted': onBoardingCompleted,
    'fitnessGoal': fitnessGoal,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'profilePhoto': profilePhoto,
    'userName': userName,
    'activeTheme': activeTheme?.toJson(),
    'activeCompanion': activeCompanion?.toJson(),
    'levelStatus': levelStatus,
    'nextLevel': nextLevel.toJson(),
    'XPcharts': xpCharts.toJson(),
    'todaySchedules': todaySchedules.toJson(),
    'thisWeek': thisWeek.toJson(),
    'thisMonth': thisMonth.toJson(),
    'todayMood': todayMood,
    'upcoming': upcoming,
    'user': user.toJson(),
  };
}

// ─── UserInfo ───────────────────────────────────────────────

class UserInfo {
  final String name;
  final UserProfileXp userProfile;

  const UserInfo({required this.name, required this.userProfile});

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    name: json['name'] as String,
    userProfile: UserProfileXp.fromJson(
      json['userProfile'] as Map<String, dynamic>,
    ),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'userProfile': userProfile.toJson(),
  };
}

class UserProfileXp {
  final int balanceXp;

  const UserProfileXp({required this.balanceXp});

  factory UserProfileXp.fromJson(Map<String, dynamic> json) =>
      UserProfileXp(balanceXp: json['balanceXp'] as int);

  Map<String, dynamic> toJson() => {'balanceXp': balanceXp};
}

// ─── Theme ──────────────────────────────────────────────────

class ActiveTheme {
  final ThemeInfo theme;

  const ActiveTheme({required this.theme});

  factory ActiveTheme.fromJson(Map<String, dynamic> json) => ActiveTheme(
    theme: ThemeInfo.fromJson(json['theme'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {'theme': theme.toJson()};
}

class ThemeInfo {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final int unlockXp;
  final DateTime createdAt;

  const ThemeInfo({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.unlockXp,
    required this.createdAt,
  });

  factory ThemeInfo.fromJson(Map<String, dynamic> json) => ThemeInfo(
    id: json['id'] as String,
    name: json['name'] as String,
    tagline: json['tagline'] as String,
    description: json['description'] as String,
    unlockXp: json['unlockXp'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tagline': tagline,
    'description': description,
    'unlockXp': unlockXp,
    'createdAt': createdAt.toIso8601String(),
  };
}

// ─── Companion ──────────────────────────────────────────────

class ActiveCompanion {
  final CompanionInfo companion;

  const ActiveCompanion({required this.companion});

  factory ActiveCompanion.fromJson(Map<String, dynamic> json) =>
      ActiveCompanion(
        companion: CompanionInfo.fromJson(
          json['companion'] as Map<String, dynamic>,
        ),
      );

  Map<String, dynamic> toJson() => {'companion': companion.toJson()};
}

class CompanionInfo {
  final String id;
  final String name;
  final String title;
  final String quote;
  final int unlockXp;
  final DateTime createdAt;

  const CompanionInfo({
    required this.id,
    required this.name,
    required this.title,
    required this.quote,
    required this.unlockXp,
    required this.createdAt,
  });

  factory CompanionInfo.fromJson(Map<String, dynamic> json) => CompanionInfo(
    id: json['id'] as String,
    name: json['name'] as String,
    title: json['title'] as String,
    quote: json['quote'] as String,
    unlockXp: json['unlockXp'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'title': title,
    'quote': quote,
    'unlockXp': unlockXp,
    'createdAt': createdAt.toIso8601String(),
  };
}

// ─── NextLevel ──────────────────────────────────────────────

class NextLevel {
  final int level;
  final int xpRequired;

  const NextLevel({required this.level, required this.xpRequired});

  factory NextLevel.fromJson(Map<String, dynamic> json) => NextLevel(
    level: json['level'] as int,
    xpRequired: json['xpRequired'] as int,
  );

  Map<String, dynamic> toJson() => {'level': level, 'xpRequired': xpRequired};
}

// ─── XP Charts ──────────────────────────────────────────────

class XPCharts {
  final XPPeriod currentWeek;
  final XPPeriod lastWeek;

  const XPCharts({required this.currentWeek, required this.lastWeek});

  factory XPCharts.fromJson(Map<String, dynamic> json) => XPCharts(
    currentWeek: XPPeriod.fromJson(json['currentWeek'] as Map<String, dynamic>),
    lastWeek: XPPeriod.fromJson(json['lastWeek'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'currentWeek': currentWeek.toJson(),
    'lastWeek': lastWeek.toJson(),
  };
}

class XPPeriod {
  final String period;
  final String timezone;
  final List<XPDayData> data;
  final int totalXp;

  const XPPeriod({
    required this.period,
    required this.timezone,
    required this.data,
    required this.totalXp,
  });

  factory XPPeriod.fromJson(Map<String, dynamic> json) => XPPeriod(
    period: json['period'] as String,
    timezone: json['timezone'] as String,
    data: (json['data'] as List<dynamic>)
        .map((e) => XPDayData.fromJson(e as Map<String, dynamic>))
        .toList(),
    totalXp: json['totalXp'] as int,
  );

  Map<String, dynamic> toJson() => {
    'period': period,
    'timezone': timezone,
    'data': data.map((e) => e.toJson()).toList(),
    'totalXp': totalXp,
  };
}

class XPDayData {
  final String day;
  final String dateLabel;
  final String isoDate;
  final int xp;
  final int logsCount;

  const XPDayData({
    required this.day,
    required this.dateLabel,
    required this.isoDate,
    required this.xp,
    required this.logsCount,
  });

  factory XPDayData.fromJson(Map<String, dynamic> json) => XPDayData(
    day: json['day'] as String,
    dateLabel: json['dateLabel'] as String,
    isoDate: json['isoDate'] as String,
    xp: json['xp'] as int,
    logsCount: json['logsCount'] as int,
  );

  Map<String, dynamic> toJson() => {
    'day': day,
    'dateLabel': dateLabel,
    'isoDate': isoDate,
    'xp': xp,
    'logsCount': logsCount,
  };
}

// ─── Schedules ──────────────────────────────────────────────

class TodaySchedules {
  final List<ScheduleItem> combined;

  const TodaySchedules({required this.combined});

  factory TodaySchedules.fromJson(Map<String, dynamic> json) => TodaySchedules(
    combined: (json['combined'] as List<dynamic>)
        .map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'combined': combined.map((e) => e.toJson()).toList(),
  };
}

class WeeklyActivity {
  final List<ScheduleItem> combined;
  final int totalMeals;
  final int totalMedications;
  final int totalExercises;

  const WeeklyActivity({
    required this.combined,
    required this.totalMeals,
    required this.totalMedications,
    required this.totalExercises,
  });

  factory WeeklyActivity.fromJson(Map<String, dynamic> json) => WeeklyActivity(
    combined: (json['combined'] as List<dynamic>)
        .map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    totalMeals: json['totalMeals'] as int,
    totalMedications: json['totalMedications'] as int,
    totalExercises: json['totalExercises'] as int,
  );

  Map<String, dynamic> toJson() => {
    'combined': combined.map((e) => e.toJson()).toList(),
    'totalMeals': totalMeals,
    'totalMedications': totalMedications,
    'totalExercises': totalExercises,
  };
}

// ─── Schedule Item ───────────────────────────────────────────

enum ScheduleType { medication, exercise, meal }

class ScheduleItem {
  final String id;
  final ScheduleType type;
  final String title;
  final String description;
  final String scheduledAt;
  final int earnedXp;
  final ScheduleDetails details;

  const ScheduleItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.scheduledAt,
    required this.earnedXp,
    required this.details,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) => ScheduleItem(
    id: json['id'] as String,
    type: ScheduleType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => ScheduleType.medication,
    ),
    title: json['title'] as String,
    description: json['description'] as String,
    scheduledAt: json['scheduledAt'] as String,
    earnedXp: json['earnedXp'] as int,
    details: ScheduleDetails.fromJson(json['details'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'title': title,
    'description': description,
    'scheduledAt': scheduledAt,
    'earnedXp': earnedXp,
    'details': details.toJson(),
  };
}

// ─── Schedule Details ────────────────────────────────────────

class ScheduleDetails {
  final String type;
  final bool isTaken;

  // Medication-specific
  final int? doseMg;

  // Exercise-specific
  final String? intensity;
  final int? duration;

  const ScheduleDetails({
    required this.type,
    required this.isTaken,
    this.doseMg,
    this.intensity,
    this.duration,
  });

  factory ScheduleDetails.fromJson(Map<String, dynamic> json) =>
      ScheduleDetails(
        type: json['type'] as String,
        isTaken: json['isTaken'] as bool,
        doseMg: json['doseMg'] as int?,
        intensity: json['intensity'] as String?,
        duration: json['duration'] as int?,
      );

  Map<String, dynamic> toJson() => {
    'type': type,
    'isTaken': isTaken,
    if (doseMg != null) 'doseMg': doseMg,
    if (intensity != null) 'intensity': intensity,
    if (duration != null) 'duration': duration,
  };
}

class HomeScreenModel {
  final String title;
  final String sub;
  final String time;
  final String iconPath;
  final int xp;
  final RxBool isChecked;

  HomeScreenModel({
    required this.title,
    required this.sub,
    required this.time,
    required this.iconPath,
    this.xp = 10,
    RxBool? isChecked,
  }) : isChecked = isChecked ?? false.obs;
}
