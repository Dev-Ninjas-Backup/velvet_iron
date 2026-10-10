import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/app_timezone_helper.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/model/meal_log_history_model.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/model/meal_log_model.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/model/meal_log_schidule_model.dart';

class MealLogService {
  static Future<MealLogModel?> logMeal({
    required String mealType,
    required String description,
    required String carbs,
    required String protein,
    required String fats,
    int? calories,
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

      final timezone = await AppTimezoneHelper.getTimezoneName();

      // Parse macros as integers as required by backend schema
      final cInt = (double.tryParse(carbs) ?? 0).round();
      final pInt = (double.tryParse(protein) ?? 0).round();
      final fInt = (double.tryParse(fats) ?? 0).round();

      // 1. Build multipart request (matching Swagger schema: mealType, description, carbs, protein, fats)
      final uri = Uri.parse(Urls.mealLog);
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
        'x-timezone': timezone,
      });

      request.fields['mealType'] = mealType.toUpperCase();
      request.fields['description'] = description;
      request.fields['carbs'] = cInt.toString();
      request.fields['protein'] = pInt.toString();
      request.fields['fats'] = fInt.toString();
      // Only include calories if non-null and backend allows; otherwise let backend auto-calculate
      if (calories != null && calories > 0) {
        request.fields['calories'] = calories.toString();
      }

      debugLog('Request URL: ${uri.toString()}');
      debugLog('Request Fields: ${request.fields}');

      // Send multipart request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugLog('Status Code: ${response.statusCode}');
      debugLog('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        debugLog('Meal Logged Successfully via Multipart!');
        return MealLogModel.fromJson(jsonData);
      }

      // If rejected because of calories or format, retry multipart strictly without calories
      if (calories != null && calories > 0) {
        debugLog('Retrying multipart without calories field...');
        final retryReq = http.MultipartRequest('POST', uri);
        retryReq.headers.addAll({
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        });
        retryReq.fields['mealType'] = mealType.toUpperCase();
        retryReq.fields['description'] = description;
        retryReq.fields['carbs'] = cInt.toString();
        retryReq.fields['protein'] = pInt.toString();
        retryReq.fields['fats'] = fInt.toString();

        final retryStream = await retryReq.send();
        final retryRes = await http.Response.fromStream(retryStream);
        if (retryRes.statusCode == 200 || retryRes.statusCode == 201) {
          final Map<String, dynamic> jsonData = jsonDecode(retryRes.body);
          debugLog('Meal Logged Successfully without calories!');
          return MealLogModel.fromJson(jsonData);
        }
      }

      // 2. Fallback: try application/json POST
      debugLog('Attempting fallback application/json POST...');
      final jsonPayload = {
        'mealType': mealType.toUpperCase(),
        'description': description,
        'carbs': cInt,
        'protein': pInt,
        'fats': fInt,
      };

      final jsonResponse = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        },
        body: jsonEncode(jsonPayload),
      );

      debugLog('JSON fallback Status Code: ${jsonResponse.statusCode}');
      debugLog('JSON fallback Response Body: ${jsonResponse.body}');

      if (jsonResponse.statusCode == 200 || jsonResponse.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(jsonResponse.body);
        debugLog('Meal Logged Successfully via JSON fallback!');
        return MealLogModel.fromJson(jsonData);
      }

      debugLog('All meal log attempts failed: ${response.statusCode} / ${jsonResponse.statusCode}');
      return null;
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

      final timezone = await AppTimezoneHelper.getTimezoneName();
      final uri = Uri.parse(Urls.mealSchedule);
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
        'x-timezone': timezone,
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
  static Future<MealLogHistoryModel?> getMealLogHistory({
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

      final timezone = await AppTimezoneHelper.getTimezoneName();
      final uri = Uri.parse(Urls.mealLogHistory(limit, offset));

      final response = await http.get(
        uri,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'x-timezone': timezone,
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

  // PATCH /meal-schedule/{id}/taken?isTaken=true
  static Future<bool> markMealAsTaken(String mealScheduleId) async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      debugLog('markMealAsTaken Access Token: $accessToken');
      debugLog('markMealAsTaken Refresh Token: $refreshToken');

      if (accessToken == null || refreshToken == null) {
        debugLog('Tokens not found in SharedPreferences');
        return false;
      }

      final uri = Uri.parse(Urls.markMealAsTaken(mealScheduleId));

      debugLog('Request URL: ${uri.toString()}');

      final response = await http.patch(
        uri,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        },
      );

      debugLog('markMealAsTaken Status Code: ${response.statusCode}');
      debugLog('markMealAsTaken Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugLog('Meal marked as taken successfully!');
        return true;
      } else {
        debugLog('markMealAsTaken API Error: ${response.statusCode}');
        debugLog('markMealAsTaken Error Body: ${response.body}');
        return false;
      }
    } catch (e, stackTrace) {
      debugLog('Exception in markMealAsTaken: $e');
      debugLog('StackTrace: $stackTrace');
      return false;
    }
  }

  /// Update an existing meal log (PATCH /meal-log/:id with optional calories override)
  Future<bool> updateMealLog({
    required String mealLogId,
    required String mealType,
    required String carbs,
    required String protein,
    required String fats,
    int? calories,
  }) async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        debugLog('Tokens not found in SharedPreferences');
        return false;
      }

      final uri = Uri.parse(Urls.updateMealLog(mealLogId));
      final Map<String, dynamic> body = {
        'mealType': mealType,
        'carbs': double.tryParse(carbs) ?? 0,
        'protein': double.tryParse(protein) ?? 0,
        'fats': double.tryParse(fats) ?? 0,
      };
      if (calories != null && calories > 0) {
        body['calories'] = calories;
      }

      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        },
        body: jsonEncode(body),
      );

      debugLog('updateMealLog Status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 400 && response.body.contains('calories') && calories != null) {
        // Fallback retry without calories field
        body.remove('calories');
        final retryResponse = await http.patch(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'x-refresh-token': refreshToken,
          },
          body: jsonEncode(body),
        );
        return retryResponse.statusCode == 200 || retryResponse.statusCode == 201;
      }
      return false;
    } catch (e) {
      debugLog('Exception in updateMealLog: $e');
      return false;
    }
  }
}
