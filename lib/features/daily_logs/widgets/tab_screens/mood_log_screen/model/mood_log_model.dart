enum MoodType {
  tired,
  good,
  pissed,
  great,
  poor;

  String get value {
    switch (this) {
      case MoodType.tired:
        return 'TIRED';
      case MoodType.good:
        return 'GOOD';
      case MoodType.pissed:
        return 'PISSED';
      case MoodType.great:
        return 'GREAT';
      case MoodType.poor:
        return 'POOR';
    }
  }

  static MoodType fromIndex(int index) {
    switch (index) {
      case 0:
        return MoodType.tired;
      case 1:
        return MoodType.good;
      case 2:
        return MoodType.pissed;
      case 3:
        return MoodType.great;
      case 4:
        return MoodType.poor;
      default:
        return MoodType.good;
    }
  }

  static int toIndex(String value) {
    switch (value.toUpperCase()) {
      case 'TIRED':
        return 0;
      case 'GOOD':
        return 1;
      case 'PISSED':
        return 2;
      case 'GREAT':
        return 3;
      case 'POOR':
        return 4;
      default:
        return 1;
    }
  }

  // icon path বের করতে — LogHistoryItem এ use হবে
  static String toIconPath(String value) {
    switch (value.toUpperCase()) {
      case 'TIRED':
        return 'tired';
      case 'GOOD':
        return 'good';
      case 'PISSED':
        return 'pissed';
      case 'GREAT':
        return 'great';
      case 'POOR':
        return 'poor';
      default:
        return 'good';
    }
  }
}

enum EnergyLevel {
  exhausted,
  low,
  moderate,
  energized,
  high;

  String get value {
    switch (this) {
      case EnergyLevel.exhausted:
        return 'EXHAUSTED';
      case EnergyLevel.low:
        return 'LOW';
      case EnergyLevel.moderate:
        return 'MODERATE';
      case EnergyLevel.energized:
        return 'ENERGIZED';
      case EnergyLevel.high:
        return 'HIGH';
    }
  }

  static EnergyLevel fromIndex(int index) {
    switch (index) {
      case 0:
        return EnergyLevel.exhausted;
      case 1:
        return EnergyLevel.low;
      case 2:
        return EnergyLevel.moderate;
      case 3:
        return EnergyLevel.energized;
      case 4:
        return EnergyLevel.high;
      default:
        return EnergyLevel.moderate;
    }
  }

  static int toIndex(String value) {
    switch (value.toUpperCase()) {
      case 'EXHAUSTED':
        return 0;
      case 'LOW':
        return 1;
      case 'MODERATE':
        return 2;
      case 'ENERGIZED':
        return 3;
      case 'HIGH':
        return 4;
      default:
        return 2;
    }
  }
}

enum HungerLevel {
  notHungry,
  hungry,
  veryHungry;

  String get value {
    switch (this) {
      case HungerLevel.notHungry:
        return 'NOT_HUNGRY';
      case HungerLevel.hungry:
        return 'HUNGRY';
      case HungerLevel.veryHungry:
        return 'VERY_HUNGRY';
    }
  }

  static HungerLevel fromIndex(int index) {
    switch (index) {
      case 0:
        return HungerLevel.notHungry;
      case 1:
        return HungerLevel.hungry;
      case 2:
        return HungerLevel.veryHungry;
      default:
        return HungerLevel.notHungry;
    }
  }

  static int toIndex(String value) {
    switch (value.toUpperCase()) {
      case 'NOT_HUNGRY':
        return 0;
      case 'HUNGRY':
        return 1;
      case 'VERY_HUNGRY':
        return 2;
      default:
        return 0;
    }
  }
}


class MoodLogResponse {
  final String id;
  final String userId;
  final String mood;
  final String energyLevel;
  final String hungerLevel;
  final String? note;
  final int earnedXp;
  final String loggedAt;

  MoodLogResponse({
    required this.id,
    required this.userId,
    required this.mood,
    required this.energyLevel,
    required this.hungerLevel,
    this.note,
    required this.earnedXp,
    required this.loggedAt,
  });

  factory MoodLogResponse.fromJson(Map<String, dynamic> json) {
    return MoodLogResponse(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      mood: json['mood'] as String? ?? '',
      energyLevel: json['energyLevel'] as String? ?? '',
      hungerLevel: json['hungerLevel'] as String? ?? '',
      note: json['note'] as String?,
      earnedXp: (json['earnedXp'] as num?)?.toInt() ?? 0,
      loggedAt: json['loggedAt'] as String? ?? '',
    );
  }

  // loggedAt → readable format: "27 Feb, Thu - 06:02 AM"
  String get formattedDate {
    try {
      final dt = DateTime.parse(loggedAt).toLocal();
      const months = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final day = days[dt.weekday - 1];
      final month = months[dt.month];
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour < 12 ? 'AM' : 'PM';
      return '${dt.day} $month, $day - $hour:$minute $period';
    } catch (_) {
      return loggedAt;
    }
  }
}

//  GET Mood-log

class MoodLogHistoryResponse {
  final List<MoodLogResponse> logs;
  final int totalCount;
  final String currentMood;

  MoodLogHistoryResponse({
    required this.logs,
    required this.totalCount,
    required this.currentMood,
  });

  factory MoodLogHistoryResponse.fromJson(Map<String, dynamic> json) {
    final rawLogs = json['logs'] as List<dynamic>? ?? [];
    return MoodLogHistoryResponse(
      logs: rawLogs
          .map((e) => MoodLogResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      currentMood: json['currentMood'] as String? ?? '',
    );
  }
}
