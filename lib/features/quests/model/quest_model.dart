import 'package:flutter/material.dart';

class Quest {
  final String id;
  final String header;
  final String title;
  final String tagText;
  final List<Color> tagGradient;
  final int xp;
  final bool completed;

  Quest({
    required this.id,
    required this.header,
    required this.title,
    required this.tagText,
    required this.tagGradient,
    required this.xp,
    this.completed = false,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'] ?? '',
      header: json['header'] as String,
      title: json['title'] as String,
      tagText: json['tagText'] as String,
      tagGradient:
          (json['tagGradient'] as List<dynamic>?)
              ?.map((e) => Color(e as int))
              .toList() ??
          [],
      xp: json['xp'] as int,
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'header': header,
      'title': title,
      'tagText': tagText,
      // ignore: deprecated_member_use
      'tagGradient': tagGradient.map((e) => e.value).toList(),
      'xp': xp,
      'completed': completed,
    };
  }
}

class QuestProgress {
  final String header;
  final String points;
  final String iconPath;

  QuestProgress({
    required this.header,
    required this.points,
    required this.iconPath,
  });

  factory QuestProgress.fromJson(Map<String, dynamic> json) {
    return QuestProgress(
      header: json['header'] ?? '',
      points: json['points'] ?? '',
      iconPath: json['iconPath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'header': header, 'points': points, 'iconPath': iconPath};
  }
}

class QuestsData {
  final QuestProgress progressPoints;
  final QuestProgress totalXp;
  final List<Quest> todaysQuests;

  QuestsData({
    required this.progressPoints,
    required this.totalXp,
    required this.todaysQuests,
  });

  factory QuestsData.fromJson(Map<String, dynamic> json) {
    return QuestsData(
      progressPoints: QuestProgress.fromJson(
        json['progressPoints'] as Map<String, dynamic>,
      ),
      totalXp: QuestProgress.fromJson(json['totalXp'] as Map<String, dynamic>),
      todaysQuests:
          (json['todaysQuests'] as List<dynamic>?)
              ?.map((e) => Quest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'progressPoints': progressPoints.toJson(),
      'totalXp': totalXp.toJson(),
      'todaysQuests': todaysQuests.map((e) => e.toJson()).toList(),
    };
  }
}
