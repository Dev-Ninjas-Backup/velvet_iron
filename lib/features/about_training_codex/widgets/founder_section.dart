import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class FounderCardWidget extends StatelessWidget {
  final String name;
  final String title;
  final String description;
  final AppThemeController themeController;

  const FounderCardWidget({
    required this.name,
    required this.title,
    required this.description,
    required this.themeController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 60,
          decoration: BoxDecoration(
            gradient: themeController.activeTheme.progressBarGradient,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: getTextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Founder Info Widget

class FounderInfoWidget extends StatelessWidget {
  const FounderInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              FounderCardWidget(
                name: 'Jamie Friddle',
                title: 'Founder & Creator, Velvet & Iron Training Codex',
                description:
                    'Jamie Friddle is the architect behind the Velvet & Iron realm. Her vision is rooted in resilience, discipline, and imagination - shaped by real-life experience and the belief that strength is forged through consistent action. Velvet & Iron was created as a living world where growth feels purposeful and progress becomes personal.',
                themeController: themeController,
              ),
              const SizedBox(height: 18),
              FounderCardWidget(
                name: 'Robert Fox',
                title: 'Marketing Coordinator',
                description:
                    'Developed in collaboration with Robert Fox, combining product strategy, UX design, and technical execution to deliver a focused, scalable, and user-first experience.',
                themeController: themeController,
              ),
            ],
          ),
        );
      },
    );
  }
}
