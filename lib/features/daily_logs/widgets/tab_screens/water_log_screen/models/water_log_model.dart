class WaterTodayResponse {
  final double currentIntake;
  final double goal;
  final String unit;
  final String display;
  final double fillPercentage;
  final bool isGoalReached;
  final PotionFlaskMetadata potionFlask;
  final List<double> quickAdds;
  final List<WaterLogItem> todayLogs;

  WaterTodayResponse({
    required this.currentIntake,
    required this.goal,
    required this.unit,
    required this.display,
    required this.fillPercentage,
    required this.isGoalReached,
    required this.potionFlask,
    required this.quickAdds,
    required this.todayLogs,
  });

  factory WaterTodayResponse.fromJson(Map<String, dynamic> json) {
    return WaterTodayResponse(
      currentIntake: (json['currentIntake'] as num?)?.toDouble() ?? 0.0,
      goal: (json['goal'] as num?)?.toDouble() ?? 64.0,
      unit: json['unit']?.toString() ?? 'OZ',
      display: json['display']?.toString() ?? '0 / 64 oz',
      fillPercentage: (json['fillPercentage'] as num?)?.toDouble() ?? 0.0,
      isGoalReached: json['isGoalReached'] == true,
      potionFlask: json['potionFlask'] is Map<String, dynamic>
          ? PotionFlaskMetadata.fromJson(json['potionFlask'])
          : PotionFlaskMetadata(theme: 'mana_potion_blue', fillLevel: 0.0),
      quickAdds: (json['quickAdds'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [8.0, 16.0, 24.0, 32.0],
      todayLogs: (json['todayLogs'] as List<dynamic>?)
              ?.map((e) => WaterLogItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PotionFlaskMetadata {
  final String theme;
  final double fillLevel;

  PotionFlaskMetadata({
    required this.theme,
    required this.fillLevel,
  });

  factory PotionFlaskMetadata.fromJson(Map<String, dynamic> json) {
    return PotionFlaskMetadata(
      theme: json['theme']?.toString() ?? 'mana_potion_blue',
      fillLevel: (json['fillLevel'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class WaterLogItem {
  final String id;
  final double amount;
  final String unit;
  final double amountMl;
  final double amountOz;
  final int earnedXp;
  final DateTime loggedAt;

  WaterLogItem({
    required this.id,
    required this.amount,
    required this.unit,
    required this.amountMl,
    required this.amountOz,
    required this.earnedXp,
    required this.loggedAt,
  });

  factory WaterLogItem.fromJson(Map<String, dynamic> json) {
    return WaterLogItem(
      id: json['id']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit']?.toString() ?? 'OZ',
      amountMl: (json['amountMl'] as num?)?.toDouble() ?? 0.0,
      amountOz: (json['amountOz'] as num?)?.toDouble() ?? 0.0,
      earnedXp: (json['earnedXp'] as num?)?.toInt() ?? 5,
      loggedAt: json['loggedAt'] != null
          ? DateTime.tryParse(json['loggedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
