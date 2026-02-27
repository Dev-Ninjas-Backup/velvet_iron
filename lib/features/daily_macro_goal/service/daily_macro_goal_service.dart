import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/features/daily_macro_goal/model/daily_goal_model.dart';

class MacroGoalService {
  // get macro goals for current user

  Future<MacroGoalListResponse> getMacroGoals({
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse(Urls.macroGoal);
    debugPrint('MacroGoal GET $uri');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        },
      );

      debugPrint('MacroGoal GET Status: ${response.statusCode}');
      debugPrint('MacroGoal GET Body  : ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return MacroGoalListResponse.fromJson(json);
      }

      String errorMessage =
          'Failed to fetch macro goals (${response.statusCode})';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        errorMessage = body['message'] as String? ?? errorMessage;
      } catch (_) {}
      throw MacroGoalException(errorMessage, statusCode: response.statusCode);
    } on SocketException {
      throw MacroGoalException(
        'No internet connection. Please check your network.',
      );
    } on HttpException catch (e) {
      throw MacroGoalException('HTTP error: ${e.message}');
    } catch (e) {
      if (e is MacroGoalException) rethrow;
      throw MacroGoalException('Unexpected error: $e');
    }
  }

  // create new macro goal for current user

  Future<MacroGoalResponse> createMacroGoal({
    required int carbs,
    required int protein,
    required int fat,
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse(Urls.macroGoal);

    debugPrint('MacroGoal POST $uri');
    debugPrint('carbs  : $carbs g');
    debugPrint('protein: $protein g');
    debugPrint('fat    : $fat g');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'carbs': carbs, 'protein': protein, 'fat': fat}),
      );

      debugPrint('MacroGoal POST Status: ${response.statusCode}');
      debugPrint('MacroGoal POST Body  : ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return MacroGoalResponse.fromJson(json);
      }

      String errorMessage =
          'Failed to save macro goal (${response.statusCode})';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        errorMessage = body['message'] as String? ?? errorMessage;
      } catch (_) {}
      throw MacroGoalException(errorMessage, statusCode: response.statusCode);
    } on SocketException {
      throw MacroGoalException(
        'No internet connection. Please check your network.',
      );
    } on HttpException catch (e) {
      throw MacroGoalException('HTTP error: ${e.message}');
    } catch (e) {
      if (e is MacroGoalException) rethrow;
      throw MacroGoalException('Unexpected error: $e');
    }
  }
}

// Exception

class MacroGoalException implements Exception {
  final String message;
  final int? statusCode;

  const MacroGoalException(this.message, {this.statusCode});

  @override
  String toString() => statusCode != null
      ? 'MacroGoalException [$statusCode]: $message'
      : 'MacroGoalException: $message';
}
