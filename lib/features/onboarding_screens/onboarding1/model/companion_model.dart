import 'package:flutter/material.dart';

class CompanionModel {
  final int? id;
  final String name;
  final String title;
  final String description;
  final String theme;
  final String imagePath;
  final String bgImage;
  final LinearGradient bgGradient;

  CompanionModel({
    required this.id,
    required this.name,
    required this.title,
    this.description = '',
    required this.theme,
    required this.imagePath,
    required this.bgImage,
    required this.bgGradient,
  });
}