import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/features/update_password/model/update_password_model.dart';

class ChangePasswordService {
  Future<ChangePasswordModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse(Urls.changePassword);

    debugPrint('ChangePassword PUT $uri');
    debugPrint(
      '   currentPassword: ${currentPassword.replaceAll(RegExp(r'.'), '*')}',
    );
    debugPrint(
      '   newPassword    : ${newPassword.replaceAll(RegExp(r'.'), '*')}',
    );

    try {
      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      debugPrint('ChangePassword Status: ${response.statusCode}');
      debugPrint('ChangePassword Body  : ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      throw ChangePasswordException(
        'No internet connection. Please check your network.',
      );
    } on HttpException catch (e) {
      throw ChangePasswordException('HTTP error: ${e.message}');
    } catch (e) {
      throw ChangePasswordException('Unexpected error: $e');
    }
  }

  ChangePasswordModel _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ChangePasswordModel.fromJson(json);
    }

    String errorMessage = 'Failed to change password (${response.statusCode})';
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      errorMessage = body['message'] as String? ?? errorMessage;
    } catch (_) {}

    throw ChangePasswordException(
      errorMessage,
      statusCode: response.statusCode,
    );
  }
}

class ChangePasswordException implements Exception {
  final String message;
  final int? statusCode;

  const ChangePasswordException(this.message, {this.statusCode});

  @override
  String toString() => statusCode != null
      ? 'ChangePasswordException [$statusCode]: $message'
      : 'ChangePasswordException: $message';
}
