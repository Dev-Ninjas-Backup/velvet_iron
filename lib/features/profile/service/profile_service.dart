import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/features/profile/model/update_profile_model.dart';

class ProfileService {
  Future<DashboardProfileModel> getProfile({
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse(Urls.getProfile);
    debugPrint('Profile GET $uri');

    try {
      final response = await http.get(
        uri,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        },
      );

      debugPrint('Profile GET Status: ${response.statusCode}');
      debugPrint('Profile GET Body  : ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return DashboardProfileModel.fromJson(json);
      }

      String errorMessage = 'Failed to fetch profile (${response.statusCode})';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        errorMessage = body['message'] as String? ?? errorMessage;
      } catch (_) {}
      throw ProfileException(errorMessage, statusCode: response.statusCode);
    } on SocketException {
      throw ProfileException(
        'No internet connection. Please check your network.',
      );
    } on HttpException catch (e) {
      throw ProfileException('HTTP error: ${e.message}');
    } catch (e) {
      if (e is ProfileException) rethrow;
      throw ProfileException('Unexpected error: $e');
    }
  }

  //  Update rofile
  Future<UpdateProfileResponse> updateProfile({
    required String name,
    required String username,
    required String accessToken,
    required String refreshToken,
    String? gender,
    String? dateOfBirth,
    String? avatar,
    String? profilePhotoPath,
  }) async {
    final uri = Uri.parse(Urls.profile);

    debugPrint('Profile PATCH $uri');
    debugPrint('name         : $name');
    debugPrint('username     : $username');
    debugPrint('gender       : $gender');
    debugPrint('dateOfBirth  : $dateOfBirth');
    debugPrint('profilePhoto : ${profilePhotoPath ?? 'not changed'}');

    final request = http.MultipartRequest('PATCH', uri)
      ..headers.addAll({
        'accept': '*/*',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
      })
      ..fields['name'] = name
      ..fields['username'] = username
      ..fields['gender'] = gender ?? ''
      ..fields['dateOfBirth'] = dateOfBirth ?? ''
      ..fields['avatar'] = avatar ?? '';

    if (profilePhotoPath != null && profilePhotoPath.isNotEmpty) {
      final file = File(profilePhotoPath);
      if (await file.exists()) {
        final ext = profilePhotoPath.split('.').last.toLowerCase();
        final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
        request.files.add(
          await http.MultipartFile.fromPath('profilePhoto', profilePhotoPath),
        );
        debugPrint('Attaching image: $profilePhotoPath ($mimeType)');
      } else {
        debugPrint('Profile Image file not found: $profilePhotoPath');
      }
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Profile PATCH Status: ${response.statusCode}');
      debugPrint('Profile PATCH Body  : ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return UpdateProfileResponse.fromJson(json);
      }

      String errorMessage = 'Failed to update profile (${response.statusCode})';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        errorMessage = body['message'] as String? ?? errorMessage;
      } catch (_) {}
      throw ProfileException(errorMessage, statusCode: response.statusCode);
    } on SocketException {
      throw ProfileException(
        'No internet connection. Please check your network.',
      );
    } on HttpException catch (e) {
      throw ProfileException('HTTP error: ${e.message}');
    } catch (e) {
      if (e is ProfileException) rethrow;
      throw ProfileException('Unexpected error: $e');
    }
  }
}

//  Exception

class ProfileException implements Exception {
  final String message;
  final int? statusCode;

  const ProfileException(this.message, {this.statusCode});

  @override
  String toString() => statusCode != null
      ? 'ProfileException [$statusCode]: $message'
      : 'ProfileException: $message';
}
