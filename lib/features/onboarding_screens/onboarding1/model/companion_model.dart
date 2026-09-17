import 'package:flutter/material.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class CompanionModel {
  final String id;
  final String name;
  final String title;
  final String description;
  final int unlockXp;
  final bool isActive;
  final bool isUnlocked;

  final String imagePath;
  final String bgImage;
  final LinearGradient bgGradient;
  final String theme;

  CompanionModel({
    required this.id,
    required this.name,
    required this.title,
    this.description = '',
    required this.unlockXp,
    required this.isActive,
    required this.isUnlocked,
    required this.imagePath,
    required this.bgImage,
    required this.bgGradient,
    this.theme = '',
  });

  factory CompanionModel.fromJson(
    Map<String, dynamic> json, {
    required String imagePath,
    required String bgImage,
    required LinearGradient bgGradient,
    String theme = '',
  }) {
    return CompanionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      description: json['quote'] ?? '',
      unlockXp: json['unlockXp'] ?? 0,
      isActive: (json['isActive'] == true || json['isAcitve'] == true),
      isUnlocked: json['isUnlocked'] ?? false,
      imagePath: imagePath,
      bgImage: bgImage,
      bgGradient: bgGradient,
      theme: theme,
    );
  }

  static String getImagePath(String name) {
    final lower = name.toLowerCase().trim();
    if (lower.contains('thyra') || lower.contains('kael')) {
      return ImagePath.thyra;
    } else if (lower.contains('leon') || lower.contains('bram')) {
      return ImagePath.generalLeon;
    } else if (lower.contains('visepheron') || lower.contains('pyraxis') || lower.contains('pyrax')) {
      return ImagePath.visepheron;
    } else if (lower.contains('riven')) {
      return ImagePath.riven;
    }
    return ImagePath.thyra;
  }

  static LinearGradient getGradient(String name) {
    return const LinearGradient(
      colors: [
        Color(0xFF310101),
        Color(0xFF550606),
        Color(0xFF550606),
        Color(0xFF310101),
        Color(0xFF550606),
        Color(0xFF310101),
      ],
    );
  }
}
