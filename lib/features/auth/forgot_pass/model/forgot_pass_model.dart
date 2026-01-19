class ForgotPassModel {
  final String email;

  ForgotPassModel({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }

  factory ForgotPassModel.fromJson(Map<String, dynamic> json) {
    return ForgotPassModel(email: json['email'] ?? '');
  }
}
