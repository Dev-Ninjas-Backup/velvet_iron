
class MacroGoalData {
  final String id;
  final String userId;
  final String? name;
  final int carbs;
  final int fat;
  final int protein;
  final int calories;
  final String createdAt;
  final String updatedAt;

  MacroGoalData({
    required this.id,
    required this.userId,
    this.name,
    required this.carbs,
    required this.fat,
    required this.protein,
    required this.calories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MacroGoalData.fromJson(Map<String, dynamic> json) {
    return MacroGoalData(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String?,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fat: (json['fat'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}

// POST macro-goal response 

class MacroGoalResponse {
  final int statusCode;
  final String message;
  final MacroGoalData data;

  MacroGoalResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory MacroGoalResponse.fromJson(Map<String, dynamic> json) {
    return MacroGoalResponse(
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      data: MacroGoalData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

// GET macro-goal response 
class MacroGoalListResponse {
  final int statusCode;
  final String message;
  final List<MacroGoalData> data;

  MacroGoalListResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory MacroGoalListResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List<dynamic>? ?? [];
    return MacroGoalListResponse(
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      data: rawList
          .map((e) => MacroGoalData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  MacroGoalData? get latest => data.isNotEmpty ? data.last : null;
}
