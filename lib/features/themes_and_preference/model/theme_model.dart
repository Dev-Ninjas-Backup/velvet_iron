class ThemeModel {
  final String id;
  final String title;
  final String badgeText;
  final String? subtitle;
  final List<int> gradientColors; // hex ints
  final String iconPath;
  final bool locked;

  ThemeModel({
    required this.id,
    required this.title,
    required this.badgeText,
    this.subtitle,
    required this.gradientColors,
    required this.iconPath,
    this.locked = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'badgeText': badgeText,
    'subtitle': subtitle,
    'gradientColors': gradientColors,
    'iconPath': iconPath,
    'locked': locked,
  };

  factory ThemeModel.fromJson(Map<String, dynamic> json) => ThemeModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    badgeText: json['badgeText'] ?? '',
    subtitle: json['subtitle'],
    gradientColors: List<int>.from(json['gradientColors'] ?? []),
    iconPath: json['iconPath'] ?? '',
    locked: json['locked'] ?? false,
  );
}
