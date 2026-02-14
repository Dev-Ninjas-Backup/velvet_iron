class UserData {
  final String id;
  final String email;
  final String username;
  final String name;
  final String avatar;
  final String? profilePhoto;
  final String? gender;
  final String? dateOfBirth;
  final bool emailVerified;
  final String emailVerificationOtp;
  final String emailVerificationExpiry;
  final String? resetPasswordOtp;
  final String? resetPasswordOtpExpiry;
  final bool resetPasswordVerified;
  final bool onBoarded;
  final String? googleId;
  final String? githubId;
  final String? discord;
  final String role;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  UserData({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.avatar,
    this.profilePhoto,
    this.gender,
    this.dateOfBirth,
    required this.emailVerified,
    required this.emailVerificationOtp,
    required this.emailVerificationExpiry,
    this.resetPasswordOtp,
    this.resetPasswordOtpExpiry,
    required this.resetPasswordVerified,
    required this.onBoarded,
    this.googleId,
    this.githubId,
    this.discord,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      profilePhoto: json['profilePhoto'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      emailVerified: json['emailVerified'] ?? false,
      emailVerificationOtp: json['emailVerificationOtp'] ?? '',
      emailVerificationExpiry: json['emailVerificationExpiry'] ?? '',
      resetPasswordOtp: json['resetPasswordOtp'],
      resetPasswordOtpExpiry: json['resetPasswordOtpExpiry'],
      resetPasswordVerified: json['resetPasswordVerified'] ?? false,
      onBoarded: json['onBoarded'] ?? false,
      googleId: json['googleId'],
      githubId: json['githubId'],
      discord: json['discord'],
      role: json['role'] ?? 'USER',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}