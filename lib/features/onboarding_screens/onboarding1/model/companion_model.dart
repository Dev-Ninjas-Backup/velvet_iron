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
      isActive: json['isAcitve'] ?? false,
      isUnlocked: json['isUnlocked'] ?? false,
      imagePath: imagePath,
      bgImage: bgImage,
      bgGradient: bgGradient,
      theme: theme,
    );
  }

  static String getImagePath(String name) {
    switch (name) {
      case 'Ser Kael Thornwatch':
        return ImagePath.serkael;
      case 'Riven Ashcroft':
        return ImagePath.riven;
      case 'Pyraxis':
        return ImagePath.pyrax;
      case 'Bram Ironledger':
        return ImagePath.bram;
      default:
        return ImagePath.serkael;
    }
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
