class SetPasswordModel {
  final String password;

  SetPasswordModel({required this.password});

  Map<String, dynamic> toJson() => {'password': password};

  factory SetPasswordModel.fromJson(Map<String, dynamic> json) {
    return SetPasswordModel(password: json['password'] ?? '');
  }
}
