class AddXpResponse {
  final int xp;
  final String reason;

  const AddXpResponse({required this.xp, required this.reason});

  factory AddXpResponse.fromJson(Map<String, dynamic> json) {
    return AddXpResponse(
      xp: json['xp'] as int,
      reason: json['reason'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'xp': xp, 'reason': reason};
  }
}

class DailyQuestResponse {
  final int todayTotalXp;
  final int todayLogCount;
  final List<Quest> quests;

  const DailyQuestResponse({
    required this.todayTotalXp,
    required this.todayLogCount,
    required this.quests,
  });

  factory DailyQuestResponse.fromJson(Map<String, dynamic> json) {
    return DailyQuestResponse(
      todayTotalXp: json['todayTotalXp'] as int,
      todayLogCount: json['todayLogCount'] as int,
      quests: (json['quests'] as List<dynamic>)
          .map((q) => Quest.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayTotalXp': todayTotalXp,
      'todayLogCount': todayLogCount,
      'quests': quests.map((q) => q.toJson()).toList(),
    };
  }

  DailyQuestResponse copyWith({
    int? todayTotalXp,
    int? todayLogCount,
    List<Quest>? quests,
  }) {
    return DailyQuestResponse(
      todayTotalXp: todayTotalXp ?? this.todayTotalXp,
      todayLogCount: todayLogCount ?? this.todayLogCount,
      quests: quests ?? this.quests,
    );
  }
}

class Quest {
  final String id;
  final String title;
  final int xp;
  final String description;
  final bool isDone;

  const Quest({
    required this.id,
    required this.title,
    required this.xp,
    required this.description,
    required this.isDone,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'] as String,
      title: json['title'] as String,
      xp: json['xp'] as int,
      description: json['description'] as String,
      isDone: json['isDone'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'xp': xp,
      'description': description,
      'isDone': isDone,
    };
  }

  Quest copyWith({
    String? id,
    String? title,
    int? xp,
    String? description,
    bool? isDone,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      xp: xp ?? this.xp,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }
}
