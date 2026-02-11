class Medication {
  final String id;
  final String name;
  final double dose;
  final DateTime timestamp;

  Medication({
    required this.id,
    required this.name,
    required this.dose,
    required this.timestamp,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      dose: (json['dose'] is int)
          ? (json['dose'] as int).toDouble()
          : (json['dose'] ?? 0.0),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
