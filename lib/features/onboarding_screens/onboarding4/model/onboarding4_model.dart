class GenderUpdateResponseModel {
  final bool success;
  final String message;

  GenderUpdateResponseModel({required this.success, required this.message});

  factory GenderUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return GenderUpdateResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
