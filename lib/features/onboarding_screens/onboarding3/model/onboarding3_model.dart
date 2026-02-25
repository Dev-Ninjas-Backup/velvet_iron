class FitnessGoalResponseModel {
  final bool success;
  final String message;

  FitnessGoalResponseModel({required this.success, required this.message});

  factory FitnessGoalResponseModel.fromJson(Map<String, dynamic> json) {
    return FitnessGoalResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
