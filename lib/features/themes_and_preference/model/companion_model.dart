class CompanionModel {
  final String id;
  final String name;
  final String avatarPath;
  final String leadingIconPath;
  final bool locked;

  CompanionModel({
    required this.id,
    required this.name,
    required this.avatarPath,
    required this.leadingIconPath,
    this.locked = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatarPath': avatarPath,
    'leadingIconPath': leadingIconPath,
    'locked': locked,
  };

  factory CompanionModel.fromJson(Map<String, dynamic> json) => CompanionModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    avatarPath: json['avatarPath'] ?? '',
    leadingIconPath: json['leadingIconPath'] ?? '',
    locked: json['locked'] ?? false,
  );
}
