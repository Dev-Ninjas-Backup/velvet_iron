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
  final TodayMood? todayMood;
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
      id: (json['id'] ?? '') as String,
      userId: (json['userId'] ?? '') as String,
      activeThemeId: json['activeThemeId'] as String?,
      activeCompanionId: json['activeCompanionId'] as String?,
      availableCompanions: json['availableCompanions'] as List<dynamic>? ?? [],
      themeCredits: (json['themeCredits'] ?? 0) as int,
      companionCredits: (json['companionCredits'] ?? 0) as int,
      totalEarnXp: (json['totalEarnXp'] ?? 0) as int,
      balanceXp: (json['balanceXp'] ?? 0) as int,
      level: (json['level'] ?? 0) as int,
      onBoardingCompleted: (json['onBoardingCompleted'] ?? false) as bool,
      fitnessGoal: (json['fitnessGoal'] ?? '') as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      profilePhoto: json['profilePhoto'] as String?,
      userName: (json['userName'] ?? 'User') as String,
      activeTheme: json['activeTheme'] != null
          ? ActiveTheme.fromJson(json['activeTheme'] as Map<String, dynamic>)
          : null,
      activeCompanion: json['activeCompanion'] != null
          ? ActiveCompanion.fromJson(
              json['activeCompanion'] as Map<String, dynamic>,
            )
          : null,
      levelStatus: (json['levelStatus'] ?? '') as String,
      nextLevel: json['nextLevel'] != null
          ? NextLevel.fromJson(json['nextLevel'] as Map<String, dynamic>)
          : NextLevel(level: 1, xpRequired: 0),
      xpCharts: json['XPcharts'] != null
          ? XPCharts.fromJson(json['XPcharts'] as Map<String, dynamic>)
          : XPCharts(
              currentWeek: XPPeriod(
                period: 'current',
                timezone: 'UTC',
                data: [],
                totalXp: 0,
              ),
              lastWeek: XPPeriod(
                period: 'last',
                timezone: 'UTC',
                data: [],
                totalXp: 0,
              ),
            ),
      todaySchedules: json['todaySchedules'] != null
          ? TodaySchedules.fromJson(
              json['todaySchedules'] as Map<String, dynamic>,
            )
          : TodaySchedules(combined: []),
      thisWeek: json['thisWeek'] != null
          ? WeeklyActivity.fromJson(json['thisWeek'] as Map<String, dynamic>)
          : WeeklyActivity(
              combined: [],
              totalMeals: 0,
              totalMedications: 0,
              totalExercises: 0,
            ),
      thisMonth: json['thisMonth'] != null
          ? WeeklyActivity.fromJson(json['thisMonth'] as Map<String, dynamic>)
          : WeeklyActivity(
              combined: [],
              totalMeals: 0,
              totalMedications: 0,
              totalExercises: 0,
            ),
      todayMood: json['todayMood'] != null
          ? TodayMood.fromJson(json['todayMood'] as Map<String, dynamic>)
          : null,
      upcoming: json['upcoming'],
      user: json['user'] != null
          ? UserInfo.fromJson(json['user'] as Map<String, dynamic>)
          : UserInfo(name: 'User', userProfile: UserProfileXp(balanceXp: 0)),
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
    'todayMood': todayMood?.toJson(),
    'upcoming': upcoming,
    'user': user.toJson(),
  };
}

// ─── TodayMood ─────────────────────────────────────────────

class TodayMood {
  final String id;
  final String mood;
  final String energyLevel;
  final String hungerLevel;
  final String? note;
  final DateTime loggedAt;

  const TodayMood({
    required this.id,
    required this.mood,
    required this.energyLevel,
    required this.hungerLevel,
    this.note,
    required this.loggedAt,
  });

  factory TodayMood.fromJson(Map<String, dynamic> json) => TodayMood(
    id: (json['id'] ?? '') as String,
    mood: (json['mood'] ?? '') as String,
    energyLevel: (json['energyLevel'] ?? '') as String,
    hungerLevel: (json['hungerLevel'] ?? '') as String,
    note: json['note'] as String?,
    loggedAt: json['loggedAt'] != null
        ? DateTime.parse(json['loggedAt'] as String)
        : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'mood': mood,
    'energyLevel': energyLevel,
    'hungerLevel': hungerLevel,
    'note': note,
    'loggedAt': loggedAt.toIso8601String(),
  };
}

// ─── UserInfo ───────────────────────────────────────────────

class UserInfo {
  final String name;
  final UserProfileXp userProfile;

  const UserInfo({required this.name, required this.userProfile});

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    name: (json['name'] ?? 'User') as String,
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
      UserProfileXp(balanceXp: (json['balanceXp'] ?? 0) as int);

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
    id: (json['id'] ?? '') as String,
    name: (json['name'] ?? '') as String,
    tagline: (json['tagline'] ?? '') as String,
    description: (json['description'] ?? '') as String,
    unlockXp: (json['unlockXp'] ?? 0) as int,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now(),
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
    id: (json['id'] ?? '') as String,
    name: (json['name'] ?? '') as String,
    title: (json['title'] ?? '') as String,
    quote: (json['quote'] ?? '') as String,
    unlockXp: (json['unlockXp'] ?? 0) as int,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now(),
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
    period: (json['period'] ?? '') as String,
    timezone: (json['timezone'] ?? '') as String,
    data:
        (json['data'] as List<dynamic>?)
            ?.map((e) => XPDayData.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    totalXp: (json['totalXp'] ?? 0) as int,
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
    day: (json['day'] ?? '') as String,
    dateLabel: (json['dateLabel'] ?? '') as String,
    isoDate: (json['isoDate'] ?? '') as String,
    xp: (json['xp'] ?? 0) as int,
    logsCount: (json['logsCount'] ?? 0) as int,
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
    id: (json['id'] ?? '') as String,
    type: ScheduleType.values.firstWhere(
      (e) => e.name == (json['type'] ?? ''),
      orElse: () => ScheduleType.medication,
    ),
    title: (json['title'] ?? '') as String,
    description: (json['description'] ?? '') as String,
    scheduledAt: (json['scheduledAt'] ?? '') as String,
    earnedXp: (json['earnedXp'] ?? 0) as int,
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
        type: (json['type'] ?? '') as String,
        isTaken: (json['isTaken'] ?? false) as bool,
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
