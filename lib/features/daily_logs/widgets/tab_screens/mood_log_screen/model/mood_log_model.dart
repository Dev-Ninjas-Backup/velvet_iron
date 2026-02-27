// ── Mood enums ────────────────────────────────────────────────────────────────

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

  // index → enum (moods list: Tired=0, Good=1, Pissed=2, Great=3, Poor=4)
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

  // API string → index (for pre-selecting from today's log)
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

  // index → enum (energyLevels: Exhausted=0, Low=1, Moderate=2, Energized=3, High=4)
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

  // API string → index
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

  // index → enum (hungerLevels: Not Hungry=0, Hungry=1, Very Hungry=2)
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

  // API string → index
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

// ── API response model ────────────────────────────────────────────────────────

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
}
