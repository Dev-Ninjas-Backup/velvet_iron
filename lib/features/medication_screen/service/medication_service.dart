import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/features/medication_screen/model/medication_model.dart';

class MedicationService {
  Future<Medication> logMedication({
    required String name,
    required String type,
    required double doseMg,
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse(Urls.medication);
    debugPrint('Medication POST: $uri');

    try {
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
      });

      request.fields['name'] = name;
      request.fields['type'] = type;
      request.fields['doseMg'] = doseMg.toString();

      debugPrint('Medication Fields: name=$name, type=$type, doseMg=$doseMg');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint('Medication Response status: ${response.statusCode}');
      debugPrint('Medication Response body: $responseBody');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(responseBody) as Map<String, dynamic>;
        return Medication.fromJson(jsonData);
      } else {
        final errorData = jsonDecode(responseBody) as Map<String, dynamic>;
        throw MedicationException(
          errorData['message'] ??
              'Failed to log medication (${response.statusCode})',
        );
      }
    } on SocketException {
      throw MedicationException('No internet connection.');
    } on HttpException catch (e) {
      throw MedicationException('HTTP error: ${e.message}');
    } catch (e) {
      if (e is MedicationException) rethrow;
      throw MedicationException('Unexpected error: $e');
    }
  }

  // POST medication-schedule
  Future<Medication> scheduleMedication({
    required String name,
    required String type,
    required double doseMg,
    required String scheduleTime,
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse(Urls.medicationSchedule);
    debugPrint('[MedicationService] Schedule POST: $uri');

    try {
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
      });

      request.fields['name'] = name;
      request.fields['type'] = type;
      request.fields['doseMg'] = doseMg.toString();
      request.fields['scheduleTime'] = scheduleTime;

      debugPrint(
        '[MedicationService] Schedule Fields: name=$name, type=$type, doseMg=$doseMg, scheduleTime=$scheduleTime',
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint(
        '[MedicationService] Schedule Response status: ${response.statusCode}',
      );
      debugPrint('[MedicationService] Schedule Response body: $responseBody');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(responseBody) as Map<String, dynamic>;
        debugPrint('[MedicationService] Scheduled! id=${jsonData['id']}');
        return Medication.fromJson(jsonData);
      } else {
        final errorData = jsonDecode(responseBody) as Map<String, dynamic>;
        throw MedicationException(
          errorData['message'] ??
              'Failed to schedule medication (${response.statusCode})',
        );
      }
    } on SocketException {
      throw MedicationException('No internet connection.');
    } on HttpException catch (e) {
      throw MedicationException('HTTP error: ${e.message}');
    } catch (e) {
      if (e is MedicationException) rethrow;
      throw MedicationException('Unexpected error: $e');
    }
  }

  // PATCH medication-schedule/{id}/taken
  Future<Medication> markMedicationAsTaken({
    required String medicationId,
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse(Urls.updateMedicationHHistory(medicationId));
    debugPrint('[MedicationService] Mark taken PATCH: $uri');

    try {
      final response = await http.patch(
        uri,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        },
      );

      debugPrint(
        '[MedicationService] Mark taken Response status: ${response.statusCode}',
      );
      debugPrint(
        '[MedicationService] Mark taken Response body: ${response.body}',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('[MedicationService] Marked as taken! id=$medicationId');
        return Medication.fromJson(jsonData);
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw MedicationException(
          errorData['message'] ??
              'Failed to mark as taken (${response.statusCode})',
        );
      }
    } on SocketException {
      throw MedicationException('No internet connection.');
    } on HttpException catch (e) {
      throw MedicationException('HTTP error: ${e.message}');
    } catch (e) {
      if (e is MedicationException) rethrow;
      throw MedicationException('Unexpected error: $e');
    }
  }

  // GET medication-history

  Future<MedicationHistoryResponse> getMedicationHistory({
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse(Urls.medicationHistory);
    debugPrint('[MedicationService] History GET: $uri');

    try {
      final response = await http.get(
        uri,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        },
      );

      debugPrint(
        '[MedicationService] History Response status: ${response.statusCode}',
      );
      debugPrint('[MedicationService] History Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final result = MedicationHistoryResponse.fromJson(jsonData);
        debugPrint('[MedicationService] totalCount   : ${result.totalCount}');
        debugPrint('[MedicationService] pendingCount : ${result.pendingCount}');
        debugPrint(
          '[MedicationService] totalEarnedXp: ${result.totalEarnedXp}',
        );
        debugPrint('[MedicationService] logs count   : ${result.logs.length}');
        return result;
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw MedicationException(
          errorData['message'] ??
              'Failed to fetch history (${response.statusCode})',
        );
      }
    } on SocketException {
      throw MedicationException('No internet connection.');
    } on HttpException catch (e) {
      throw MedicationException('HTTP error: ${e.message}');
    } catch (e) {
      if (e is MedicationException) rethrow;
      throw MedicationException('Unexpected error: $e');
    }
  }
}

// History response model
class MedicationHistoryResponse {
  final int totalCount;
  final int pendingCount;
  final int totalEarnedXp;
  final Medication? nextSchedule;
  final List<Medication> logs;

  MedicationHistoryResponse({
    required this.totalCount,
    required this.pendingCount,
    required this.totalEarnedXp,
    this.nextSchedule,
    required this.logs,
  });

  factory MedicationHistoryResponse.fromJson(Map<String, dynamic> json) {
    return MedicationHistoryResponse(
      totalCount: json['totalCount'] ?? 0,
      pendingCount: json['pendingCount'] ?? 0,
      totalEarnedXp: json['totalEarnedXp'] ?? 0,
      nextSchedule: json['nextSchedule'] != null
          ? Medication.fromJson(json['nextSchedule'])
          : null,
      logs: (json['logs'] as List<dynamic>? ?? [])
          .map((e) => Medication.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MedicationException implements Exception {
  final String message;
  MedicationException(this.message);

  @override
  String toString() => message;
}
