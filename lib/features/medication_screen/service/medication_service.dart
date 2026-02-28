import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/features/medication_screen/model/medication_model.dart';

class MedicationService {
  // Log medication
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

      // Add headers
      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
      });

      // Add form fields
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
          errorData['message'] ?? 'Failed to log medication (${response.statusCode})',
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

class MedicationException implements Exception {
  final String message;
  MedicationException(this.message);

  @override
  String toString() => message;
}
