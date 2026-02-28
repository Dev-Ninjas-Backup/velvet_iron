import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/model/meal_log_history_model.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/model/meal_log_model.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/model/meal_log_schidule_model.dart';

class MealLogService {
  static const String _baseUrl = 'https://velvet.api.softvence.app';

  static Future<MealLogModel?> logMeal({
    required String mealType,
    required String description,
    required String carbs,
    required String protein,
    required String fats,
  }) async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      debugLog('Access Token: $accessToken');
      debugLog('Refresh Token: $refreshToken');

      if (accessToken == null || refreshToken == null) {
        debugLog('Tokens not found in SharedPreferences');
        return null;
      }

      //  Build multipart request
      final uri = Uri.parse('$_baseUrl/meal-log');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
      });

      request.fields['mealType'] = mealType;
      request.fields['description'] = description;
      request.fields['carbs'] = carbs;
      request.fields['protein'] = protein;
      request.fields['fats'] = fats;

      debugLog('Request URL: ${uri.toString()}');
      debugLog('Request Fields: ${request.fields}');
      debugLog('Request Headers: ${request.headers}');

      //  Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugLog('Status Code: ${response.statusCode}');
      debugLog('Response Body: ${response.body}');

      //  Parse response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        debugLog('Meal Logged Successfully!');
        debugLog('Parsed JSON: $jsonData');

        final meal = MealLogModel.fromJson(jsonData);
        debugLog('MealLog ID: ${meal.id}');
        debugLog('Earned XP: ${meal.earnedXp}');
        debugLog('Calories: ${meal.calories}');
        debugLog('isTaken: ${meal.isTaken}');
        debugLog('LoggedAt: ${meal.loggedAt}');

        return meal;
      } else {
        debugLog('API Error: ${response.statusCode}');
        debugLog('Error Body: ${response.body}');
        return null;
      }
    } catch (e, stackTrace) {
      debugLog('Exception in logMeal: $e');
      debugLog('StackTrace: $stackTrace');
      return null;
    }
  }

  static void debugLog(String message) {
    // ignore: avoid_print
    print('[MealLogService] $message');
  }

  static Future<MealScheduleModel?> scheduleMeal({
    required String mealType,
    required String scheduledAt,
    required String carbs,
    required String protein,
    required String fats,
  }) async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      debugLog('Access Token: $accessToken');
      debugLog('Refresh Token: $refreshToken');

      if (accessToken == null || refreshToken == null) {
        debugLog('Tokens not found in SharedPreferences');
        return null;
      }

      final uri = Uri.parse('$_baseUrl/meal-schedule');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
      });

      request.fields['mealType'] = mealType;
      request.fields['scheduledAt'] = scheduledAt;
      request.fields['carbs'] = carbs;
      request.fields['protein'] = protein;
      request.fields['fats'] = fats;

      debugLog('Request URL: ${uri.toString()}');
      debugLog('Request Fields: ${request.fields}');
      debugLog('Request Headers: ${request.headers}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugLog('Status Code: ${response.statusCode}');
      debugLog('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        debugLog('Meal Scheduled Successfully!');
        debugLog('Parsed JSON: $jsonData');

        final schedule = MealScheduleModel.fromJson(jsonData);
        debugLog('Schedule ID : ${schedule.id}');
        debugLog('MealType    : ${schedule.mealType}');
        debugLog('ScheduledAt : ${schedule.scheduledAt}');
        debugLog('Calories    : ${schedule.calories}');
        debugLog('Earned XP   : ${schedule.earnedXp}');
        debugLog('isTaken     : ${schedule.isTaken}');

        return schedule;
      } else {
        debugLog('API Error: ${response.statusCode}');
        debugLog('Error Body: ${response.body}');
        return null;
      }
    } catch (e, stackTrace) {
      debugLog('Exception in scheduleMeal: $e');
      debugLog('StackTrace: $stackTrace');
      return null;
    }
  }

  //  GET /meal-log/history
  static Future<MealLogHistoryModel?> getHistory({
    int limit = 30,
    int offset = 0,
  }) async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      debugLog('getHistory Access Token: $accessToken');
      debugLog('getHistory Refresh Token: $refreshToken');

      if (accessToken == null || refreshToken == null) {
        debugLog('Tokens not found in SharedPreferences');
        return null;
      }

      final uri = Uri.parse(
        '$_baseUrl/meal-log/history?limit=$limit&offset=$offset',
      );

      final response = await http.get(
        uri,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        },
      );

      debugLog('getHistory Status Code: ${response.statusCode}');
      debugLog('getHistory Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        debugLog('History fetched successfully!');

        final history = MealLogHistoryModel.fromJson(jsonData);
        debugLog('Total logs     : ${history.totalCount}');
        debugLog('Total XP       : ${history.totalEarnedXp}');
        debugLog('Daily calories : ${history.dailyCalories}');
        debugLog('Consumed cal   : ${history.consumedCalories}');
        debugLog('weeklyPresent  : ${history.weeklyPresent}');

        return history;
      } else {
        debugLog('getHistory API Error: ${response.statusCode}');
        debugLog('getHistory Error Body: ${response.body}');
        return null;
      }
    } catch (e, stackTrace) {
      debugLog('Exception in getHistory: $e');
      debugLog('StackTrace: $stackTrace');
      return null;
    }
  }

  
}
