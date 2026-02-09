import 'package:flutter/material.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class AppThemeModel {
  final String id;
  final String name;
  final LinearGradient backgroundGradient;
  final String backgroundImage;
  final Color cardBackgroundColor;
  final Color headerIconBackgroundColor;
  final LinearGradient progressBarGradient;
  final Color dropdownBackgroundColor;
  final Color borderColor;
  final Color accentGoldColor;
  final Color moodBorderColor;
  final Color todoSubtitleColor;
  final Color todoTimeColor;

  AppThemeModel({
    required this.id,
    required this.name,
    required this.backgroundGradient,
    required this.backgroundImage,
    required this.cardBackgroundColor,
    required this.headerIconBackgroundColor,
    required this.progressBarGradient,
    required this.dropdownBackgroundColor,
    required this.borderColor,
    required this.accentGoldColor,
    required this.moodBorderColor,
    required this.todoSubtitleColor,
    required this.todoTimeColor,
  });

  /// Default theme: Deep red/maroon (original)
  static AppThemeModel adventurerTheme = AppThemeModel(
    id: 'adventurer',
    name: 'Adventurer',
    backgroundGradient: const LinearGradient(
      colors: [Color(0xFF1E0000), Color(0xFF680B0B)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    backgroundImage: ImagePath.backgroundOne,
    cardBackgroundColor: const Color(0xFF5A1515).withValues(alpha: .5),
    headerIconBackgroundColor: const Color(0xCC521212),
    progressBarGradient: const LinearGradient(
      colors: [
        Color.fromARGB(104, 41, 41, 18), // dark red
        Color.fromARGB(255, 171, 117, 34), // gold
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
    dropdownBackgroundColor: const Color(0xFF3A0303),
    borderColor: const Color(0xFF6B1717),
    accentGoldColor: const Color(0xFFD6B36A),
    moodBorderColor: const Color(0xFF6B1717),
    todoSubtitleColor: const Color(0xFF950404),
    todoTimeColor: const Color(0xFF914C4C),
  );

  /// Theme 2: Blue theme
  static AppThemeModel mageTheme = AppThemeModel(
    id: 'mage',
    name: 'Mage',
    backgroundGradient: const LinearGradient(
      colors: [Color(0xFF001A47), Color(0xFF1C1E8F)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    backgroundImage: ImagePath.backgroundTwo,
    cardBackgroundColor: const Color(0xFF292DA9),
    headerIconBackgroundColor: const Color(0xCC0A1F47),
    progressBarGradient: const LinearGradient(
      colors: [Color(0xFF001A47), Color(0xFF4FA3D1)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
    dropdownBackgroundColor: const Color(0xFF001A47),
    borderColor: const Color(0xFF1C1E8F),
    accentGoldColor: const Color(0xFF5FB3E5),
    moodBorderColor: const Color(0xFF1C1E8F),
    todoSubtitleColor: const Color(0xFF292DA9),
    todoTimeColor: const Color(0xFF2A7AAD),
  );

  /// Theme 3: Green theme
  static AppThemeModel readerTheme = AppThemeModel(
    id: 'reader',
    name: 'Reader',
    backgroundGradient: const LinearGradient(
      colors: [Color(0xFF0E2D22), Color(0xFF105234)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    backgroundImage: ImagePath.backgroundThree,
    cardBackgroundColor: const Color(0xFF1A4D3F),
    headerIconBackgroundColor: const Color(0xCC0D3A2E),
    progressBarGradient: const LinearGradient(
      colors: [Color(0xFF0E2D22), Color(0xFF4ECC71)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
    dropdownBackgroundColor: const Color(0xFF0E2D22),
    borderColor: const Color(0xFF105234),
    accentGoldColor: const Color(0xFF7FE8B5),
    moodBorderColor: const Color(0xFF105234),
    todoSubtitleColor: const Color(0xFF0A5F28),
    todoTimeColor: const Color(0xFF2A8D52),
  );

  /// Theme 4: Purple theme
  static AppThemeModel gamerTheme = AppThemeModel(
    id: 'gamer',
    name: 'Gamer',
    backgroundGradient: const LinearGradient(
      colors: [Color(0xFF1C0036), Color(0xFF360B5E)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    backgroundImage: ImagePath.backgroundFour,
    cardBackgroundColor: const Color(0xFF2D0E4A),
    headerIconBackgroundColor: const Color(0xCC1C0036),
    progressBarGradient: const LinearGradient(
      colors: [Color(0xFF53E7D3), Color(0xFF9820FF)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
    dropdownBackgroundColor: const Color(0xFF1C0036),
    borderColor: const Color(0xFF360B5E),
    accentGoldColor: const Color(0xFFD8A5FF),
    moodBorderColor: const Color(0xFF360B5E),
    todoSubtitleColor: const Color(0xFF6B2A7E),
    todoTimeColor: const Color(0xFF8B5A9E),
  );

  /// Get all available themes
  static List<AppThemeModel> getAllThemes() {
    return [adventurerTheme, mageTheme, readerTheme, gamerTheme];
  }
}
