class FitnessGoalResponseModel {
  final String id;
  final String userId;
  final String fitnessGoal;
  final bool onBoardingCompleted;
  final int level;
  final String message;

  FitnessGoalResponseModel({
    required this.id,
    required this.userId,
    required this.fitnessGoal,
    required this.onBoardingCompleted,
    required this.level,
    this.message = '',
  });

  factory FitnessGoalResponseModel.fromJson(Map<String, dynamic> json) {
    return FitnessGoalResponseModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      fitnessGoal: json['fitnessGoal'] ?? '',
      onBoardingCompleted: json['onBoardingCompleted'] ?? false,
      level: json['level'] ?? 1,
      message: json['message'] ?? '',
    );
  }
}
