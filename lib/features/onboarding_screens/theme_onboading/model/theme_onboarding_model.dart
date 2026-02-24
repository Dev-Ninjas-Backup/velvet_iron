class ThemeModel {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final int unlockXp;
  final DateTime createdAt;
  final bool isActive;
  final bool isUnlocked;

  ThemeModel({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.unlockXp,
    required this.createdAt,
    required this.isActive,
    required this.isUnlocked,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      id: json['id'],
      name: json['name'],
      tagline: json['tagline'],
      description: json['description'],
      unlockXp: json['unlockXp'],
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isAcitve'] ?? false, 
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }
}

class ThemeResponse {
  final List<ThemeModel> themes;
  final int unlockable;
  final int level;
  final int unlockedThemes;

  ThemeResponse({
    required this.themes,
    required this.unlockable,
    required this.level,
    required this.unlockedThemes,
  });

  factory ThemeResponse.fromJson(Map<String, dynamic> json) {
    return ThemeResponse(
      themes: List<ThemeModel>.from(
        json['themes'].map((x) => ThemeModel.fromJson(x)),
      ),
      unlockable: json['Unlockable'],
      level: json['level'],
      unlockedThemes: json['unlockedThemes'],
    );
  }
}
