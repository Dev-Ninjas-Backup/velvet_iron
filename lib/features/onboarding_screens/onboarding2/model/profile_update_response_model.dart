class ProfileUpdateResponseModel {
  final bool success;
  final String message;
  final ProfileUser? user;

  ProfileUpdateResponseModel({
    required this.success,
    required this.message,
    this.user,
  });

  factory ProfileUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: json['user'] != null ? ProfileUser.fromJson(json['user']) : null,
    );
  }
}

class ProfileUser {
  final String? id;
  final String? email;
  final String? username;
  final String? name;
  final String? avatar;
  final String? profilePhoto;
  final String? gender;
  final String? dateOfBirth;
  final bool? emailVerified;
  final String? role;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  ProfileUser({
    this.id,
    this.email,
    this.username,
    this.name,
    this.avatar,
    this.profilePhoto,
    this.gender,
    this.dateOfBirth,
    this.emailVerified,
    this.role,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      name: json['name'],
      avatar: json['avatar'],
      profilePhoto: json['profilePhoto'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      emailVerified: json['emailVerified'],
      role: json['role'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
