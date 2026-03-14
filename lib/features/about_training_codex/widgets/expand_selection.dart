import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/about_training_codex/model/about_training_model.dart';

class ExpandableSectionWidget extends StatelessWidget {
  final String sectionTitle;
  final List<AboutTrainingModel> features;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Set<int> selectedIndices;
  final Function(int) onFeatureToggle;

  const ExpandableSectionWidget({
    required this.sectionTitle,
    required this.features,
    required this.isExpanded,
    required this.onToggle,
    required this.selectedIndices,
    required this.onFeatureToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                sectionTitle,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: features
                        .asMap()
                        .entries
                        .map(
                          (entry) => _FeatureItem(
                            index: entry.key,
                            title: entry.value.title,
                            description: entry.value.description,
                            isSelected: selectedIndices.contains(entry.key),
                            onTap: () => onFeatureToggle(entry.key),
                          ),
                        )
                        .toList(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final int index;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _FeatureItem({
    required this.index,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(top: 2),
                child: Image.asset(
                  themeController.activeTheme.id == 'adventurer'
                      ? IconPath.doticonAdventure
                      : themeController.activeTheme.id == 'mage'
                      ? IconPath.doticonMage
                      : themeController.activeTheme.id == 'gamer'
                      ? IconPath.doticonGamer
                      : IconPath.doticonReader,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$title ',
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: themeController.activeTheme.textColor,
                          ),
                        ),
                        if (description.isNotEmpty)
                          TextSpan(
                            text: description,
                            style: getTextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Expandable Sections Container

class ExpandableSectionsContainer extends StatelessWidget {
  final int selectedSection;
  final Function(int) onSectionChanged;
  final List<AboutTrainingModel> features;
  final List<AboutTrainingModel> partnerFeatures;
  final Set<int> expandedSections;
  final Function(int) onSectionToggle;
  final Map<int, Set<int>> selectedFeatureIndices;
  final Function(int sectionIndex, int featureIndex) onFeatureToggle;

  const ExpandableSectionsContainer({
    required this.selectedSection,
    required this.onSectionChanged,
    required this.features,
    required this.partnerFeatures,
    required this.expandedSections,
    required this.onSectionToggle,
    required this.selectedFeatureIndices,
    required this.onFeatureToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpandableSectionWidget(
          sectionTitle: 'Why to use Velvet & Iron Training Codex?',
          features: features,
          isExpanded: expandedSections.contains(0),
          onToggle: () => onSectionToggle(0),
          selectedIndices: selectedFeatureIndices[0] ?? {},
          onFeatureToggle: (featureIndex) => onFeatureToggle(0, featureIndex),
        ),
        const SizedBox(height: 8),
        ExpandableSectionWidget(
          sectionTitle: 'Why to be a partner?',
          features: partnerFeatures,
          isExpanded: expandedSections.contains(1),
          onToggle: () => onSectionToggle(1),
          selectedIndices: selectedFeatureIndices[1] ?? {},
          onFeatureToggle: (featureIndex) => onFeatureToggle(1, featureIndex),
        ),
      ],
    );
  }
}
