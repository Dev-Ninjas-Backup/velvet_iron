
class NextLevel {
  final int level;
  final int xpRequired;

  NextLevel({required this.level, required this.xpRequired});

  factory NextLevel.fromJson(Map<String, dynamic> json) {
    return NextLevel(
      level: json['level'] ?? 2,
      xpRequired: json['xpRequired'] ?? 0,
    );
  }
}

class UserProfile {
  final String userName;
  final int level;
  final String levelStatus;
  final int totalEarnXp;
  final int balanceXp;
  final NextLevel nextLevel;

  UserProfile({
    required this.userName,
    required this.level,
    required this.levelStatus,
    required this.totalEarnXp,
    required this.balanceXp,
    required this.nextLevel,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userName: json['userName'] ?? json['user']?['name'] ?? '',
      level: json['level'] ?? 1,
      levelStatus: json['levelStatus'] ?? '',
      totalEarnXp: json['totalEarnXp'] ?? 0,
      balanceXp: json['balanceXp'] ?? 0,
      nextLevel: NextLevel.fromJson(
        (json['nextLevel'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }
}
