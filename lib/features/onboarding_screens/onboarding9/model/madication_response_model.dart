class MedicationResponseModel {
  final String id;
  final String userId;
  final String name;
  final int earnedXp;
  final String type;
  final bool isTaken;
  final int doseMg;
  final String createdAt;

  MedicationResponseModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.earnedXp,
    required this.type,
    required this.isTaken,
    required this.doseMg,
    required this.createdAt,
  });

  factory MedicationResponseModel.fromJson(Map<String, dynamic> json) {
    return MedicationResponseModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      earnedXp: json['earnedXp'] ?? 0,
      type: json['type'] ?? '',
      isTaken: json['isTaken'] ?? false,
      doseMg: json['doseMg'] ?? 0,
      createdAt: json['createdAt'] ?? '',
    );
  }
}
