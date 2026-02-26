

class DashboardProfileModel {
  final String id;
  final String name;        
  final String userName;    
  final String profilePhoto; 

  DashboardProfileModel({
    required this.id,
    required this.name,
    required this.userName,
    required this.profilePhoto,
  });

  factory DashboardProfileModel.fromJson(Map<String, dynamic> json) {
    // name lives inside user.name
    final userMap = json['user'] as Map<String, dynamic>?;
    final name = userMap?['name'] as String? ?? '';

    return DashboardProfileModel(
      id: json['id'] as String? ?? '',
      name: name,
      userName: json['userName'] as String? ?? '',      
      profilePhoto: json['profilePhoto'] as String? ?? '',
    );
  }
}



class UpdatedUserModel {
  final String id;
  final String email;
  final String username;
  final String name;
  final String avatar;
  final String profilePhoto;
  final String gender;
  final String? dateOfBirth;

  UpdatedUserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.avatar,
    required this.profilePhoto,
    required this.gender,
    this.dateOfBirth,
  });

  factory UpdatedUserModel.fromJson(Map<String, dynamic> json) {
    return UpdatedUserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      profilePhoto: json['profilePhoto'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String?,
    );
  }
}

class UpdateProfileResponse {
  final bool success;
  final String message;
  final UpdatedUserModel user;

  UpdateProfileResponse({
    required this.success,
    required this.message,
    required this.user,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      user: UpdatedUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}