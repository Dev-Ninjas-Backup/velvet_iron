class AddXpResponse {
  final int xp;
  final String reason;

  const AddXpResponse({required this.xp, required this.reason});

  factory AddXpResponse.fromJson(Map<String, dynamic> json) {
    return AddXpResponse(
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      reason: json['reason'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'xp': xp, 'reason': reason};
  }
}

class UnifiedQuestMeta {
  final int totalQuests;
  final int completedQuests;
  final int todayCustomXpEarned;
  final int dailyCustomXpCap;

  const UnifiedQuestMeta({
    required this.totalQuests,
    required this.completedQuests,
    required this.todayCustomXpEarned,
    required this.dailyCustomXpCap,
  });

  factory UnifiedQuestMeta.fromJson(Map<String, dynamic> json) {
    return UnifiedQuestMeta(
      totalQuests: (json['totalQuests'] as num?)?.toInt() ?? 0,
      completedQuests: (json['completedQuests'] as num?)?.toInt() ?? 0,
      todayCustomXpEarned: (json['todayCustomXpEarned'] as num?)?.toInt() ?? 0,
      dailyCustomXpCap: (json['dailyCustomXpCap'] as num?)?.toInt() ?? 50,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalQuests': totalQuests,
      'completedQuests': completedQuests,
      'todayCustomXpEarned': todayCustomXpEarned,
      'dailyCustomXpCap': dailyCustomXpCap,
    };
  }
}

class DailyQuestResponse {
  final int todayTotalXp;
  final int todayLogCount;
  final List<Quest> quests;
  final UnifiedQuestMeta? meta;

  const DailyQuestResponse({
    required this.todayTotalXp,
    required this.todayLogCount,
    required this.quests,
    this.meta,
  });

  factory DailyQuestResponse.fromJson(Map<String, dynamic> json) {
    // 1. Support Backend Milestone 3 Unified Feed: { "success": true, "data": [...], "meta": {...} }
    if (json['data'] is List) {
      final list = json['data'] as List<dynamic>;
      final parsedQuests = list.map((q) => Quest.fromJson(q as Map<String, dynamic>)).toList();
      final meta = json['meta'] is Map<String, dynamic>
          ? UnifiedQuestMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null;
      final completed = meta?.completedQuests ?? parsedQuests.where((q) => q.isDone).length;
      final totalXp = parsedQuests.where((q) => q.isDone).fold(0, (sum, q) => sum + q.xp);

      return DailyQuestResponse(
        todayTotalXp: (json['todayTotalXp'] as num?)?.toInt() ?? totalXp,
        todayLogCount: (json['todayLogCount'] as num?)?.toInt() ?? completed,
        quests: parsedQuests,
        meta: meta,
      );
    }

    // 2. Support Legacy / XP-Stats Quests: { "todayTotalXp": 45, "todayLogCount": 2, "quests": [...] }
    final rawQuests = json['quests'] as List<dynamic>? ?? [];
    return DailyQuestResponse(
      todayTotalXp: (json['todayTotalXp'] as num?)?.toInt() ?? 0,
      todayLogCount: (json['todayLogCount'] as num?)?.toInt() ?? 0,
      quests: rawQuests.map((q) => Quest.fromJson(q as Map<String, dynamic>)).toList(),
      meta: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayTotalXp': todayTotalXp,
      'todayLogCount': todayLogCount,
      'quests': quests.map((q) => q.toJson()).toList(),
      if (meta != null) 'meta': meta!.toJson(),
    };
  }

  DailyQuestResponse copyWith({
    int? todayTotalXp,
    int? todayLogCount,
    List<Quest>? quests,
    UnifiedQuestMeta? meta,
  }) {
    return DailyQuestResponse(
      todayTotalXp: todayTotalXp ?? this.todayTotalXp,
      todayLogCount: todayLogCount ?? this.todayLogCount,
      quests: quests ?? this.quests,
      meta: meta ?? this.meta,
    );
  }
}

class Quest {
  final String id;
  final String title;
  final int xp;
  final String description;
  final bool isDone;
  final String questType; // 'CODEX' | 'CUSTOM' | 'MEDICATION_SCHEDULE' | 'WORKOUT_SCHEDULE'
  final String? originalRefId;
  final String? category;
  final DateTime? scheduledAt;

  const Quest({
    required this.id,
    required this.title,
    required this.xp,
    required this.description,
    required this.isDone,
    this.questType = 'CODEX',
    this.originalRefId,
    this.category,
    this.scheduledAt,
  });

  /// Formats scheduled workout subtitle in user's device local timezone
  static String formatWorkoutScheduleDescription({
    required String type,
    int? duration,
    required DateTime scheduledAt,
  }) {
    final local = scheduledAt.toLocal();
    final now = DateTime.now();
    final isToday = local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
    final hourNum = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final hour = hourNum.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    final timeStr = "$hour:$minute $period";

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayName = days[local.weekday - 1];
    final datePrefix = isToday ? 'Today' : dayName;

    final durationStr = (duration != null && duration > 0) ? '$duration min • ' : '';
    final typeUpper = type.toUpperCase();
    return "$typeUpper • $durationStr$datePrefix at $timeStr";
  }

  factory Quest.fromJson(Map<String, dynamic> json) {
    // Title may be 'title' or 'name' (from custom quests endpoint)
    String title = json['title'] as String? ?? json['name'] as String? ?? '';
    String description = json['description'] as String? ?? '';

    final lowerTitle = title.trim().toLowerCase();
    final idString = (json['id']?.toString() ?? '').toLowerCase();
    final refId = (json['originalRefId']?.toString() ?? '').toLowerCase();

    // Map generic quest names to fantasy/Codex-style names
    if (lowerTitle == 'step master' || idString.contains('step-master') || refId.contains('step-master')) {
      title = "Stride of the Realmwalker";
      if (description.isEmpty) description = "Complete your daily step goal or walk at least 8,000 steps";
    } else if (lowerTitle == 'three meals a day' || idString.contains('three-meals') || refId.contains('three-meals')) {
      title = "Feast of the Hearth";
      if (description.isEmpty) description = "Log breakfast, lunch, and dinner";
    } else if (lowerTitle == 'protein power' || idString.contains('protein-power') || refId.contains('protein-power')) {
      title = "Titan's Nourishment";
      if (description.isEmpty) description = "Log a meal with 120g+ protein";
    } else if (lowerTitle == 'track your shot' || idString.contains('track-your-shot') || refId.contains('track-your-shot')) {
      title = "Elixir of the Alchemist";
    } else if (lowerTitle == 'mood check' || idString.contains('mood-check') || refId.contains('mood-check')) {
      title = "Attunement of Spirit";
    }

    final id = json['id']?.toString() ?? '';
    final xp = (json['xpReward'] as num?)?.toInt() ?? (json['xp'] as num?)?.toInt() ?? 10;
    final isDone = json['isCompleted'] == true || json['isDone'] == true;

    // Determine quest type
    String qType = json['questType']?.toString() ?? '';
    if (qType.isEmpty) {
      if (json['isCustom'] == true || id.startsWith('custom_') || json['category'] != null) {
        qType = 'CUSTOM';
      } else if (id.startsWith('med_')) {
        qType = 'MEDICATION_SCHEDULE';
      } else if (id.startsWith('workout_')) {
        qType = 'WORKOUT_SCHEDULE';
      } else {
        qType = 'CODEX';
      }
    }

    DateTime? scheduledAt;
    if (json['scheduledAt'] != null) {
      if (json['scheduledAt'] is DateTime) {
        scheduledAt = json['scheduledAt'] as DateTime;
      } else {
        scheduledAt = DateTime.tryParse(json['scheduledAt'].toString());
      }
    }

    // Format workout schedule description using device local timezone if scheduledAt is present
    if (qType == 'WORKOUT_SCHEDULE' && scheduledAt != null) {
      final categoryType = json['category']?.toString() ??
          (description.contains('•') ? description.split('•').first.trim() : 'CARDIO');
      final duration = (json['duration'] as num?)?.toInt();
      description = formatWorkoutScheduleDescription(
        type: categoryType,
        duration: duration,
        scheduledAt: scheduledAt,
      );
    }

    // Default description for custom quests if empty
    if (description.isEmpty && json['category'] != null) {
      final rec = json['recurrence']?.toString() ?? 'DAILY';
      description = '${json['category']} • $rec';
    }

    return Quest(
      id: id,
      title: title,
      xp: xp,
      description: description,
      isDone: isDone,
      questType: qType,
      originalRefId: json['originalRefId']?.toString() ??
          json['customQuestId']?.toString() ??
          json['questId']?.toString() ??
          (id.startsWith('custom_') ? id.substring(7) : id),
      category: json['category']?.toString(),
      scheduledAt: scheduledAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'xp': xp,
      'description': description,
      'isDone': isDone,
      'questType': questType,
      if (originalRefId != null) 'originalRefId': originalRefId,
      if (category != null) 'category': category,
      if (scheduledAt != null) 'scheduledAt': scheduledAt!.toIso8601String(),
    };
  }

  Quest copyWith({
    String? id,
    String? title,
    int? xp,
    String? description,
    bool? isDone,
    String? questType,
    String? originalRefId,
    String? category,
    DateTime? scheduledAt,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      xp: xp ?? this.xp,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      questType: questType ?? this.questType,
      originalRefId: originalRefId ?? this.originalRefId,
      category: category ?? this.category,
      scheduledAt: scheduledAt ?? this.scheduledAt,
    );
  }
}
