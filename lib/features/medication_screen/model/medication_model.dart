class Medication {
  final String id;
  final String userId;
  final String name;
  final String type;
  final double doseMg;
  final bool isTaken;
  final int earnedXp;
  final DateTime? createdAt;
  final DateTime? loggedAt;
  final DateTime? scheduledAt;
  final String? entryType;

  Medication({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.doseMg,
    required this.isTaken,
    required this.earnedXp,
    this.createdAt,
    this.loggedAt,
    this.scheduledAt,
    this.entryType,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      doseMg: (json['doseMg'] is int)
          ? (json['doseMg'] as int).toDouble()
          : (json['doseMg'] ?? 0.0),
      isTaken: json['isTaken'] ?? false,
      earnedXp: json['earnedXp'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      loggedAt: json['loggedAt'] != null
          ? DateTime.parse(json['loggedAt'])
          : null,
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.parse(json['scheduledAt'])
          : null,
      entryType: json['entryType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'type': type,
      'doseMg': doseMg,
      'isTaken': isTaken,
      'earnedXp': earnedXp,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (loggedAt != null) 'loggedAt': loggedAt!.toIso8601String(),
      if (scheduledAt != null) 'scheduledAt': scheduledAt!.toIso8601String(),
      if (entryType != null) 'entryType': entryType,
    };
  }
}
