// widgets/about_training_widgets.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/about_training_codex/model/about_training_model.dart';

class AboutTrainingAppBar extends StatelessWidget {
  final double size;

  const AboutTrainingAppBar({this.size = 40, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          themeController.activeTheme.todoSubtitleColor,
                          themeController.activeTheme.todoSubtitleColor,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: size * 0.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'About Training Codex',
                    style: getTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

class IntroWidget extends StatelessWidget {
  const IntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Intro',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Velvet & Iron Training Codex is a progress-driven wellness experience designed for those who refuse to stay small. Instead of traditional tracking, the Codex transforms daily effort into momentum through XP, levels, and unlockable progression — turning consistency into a meaningful journey.',
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              height: 203,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(ImagePath.velvetbook, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '“Train as if you’ve just fallen through a portal and need to outrun a dragon.”',
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

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
                    'Jamie Friddle is the architect behind the Velvet & Iron vision, forging a space where growth isn\'t linear, it\'s earned. Through a Velvet & Iron Training Codex, Jamie invites others to mark the weight of their resolve, where dedication defines the Codex, and accountability is woven into every entry.',
                themeController: themeController,
              ),
              const SizedBox(height: 18),
              FounderCardWidget(
                name: 'Robert Fox',
                title: 'Marketing Coordinator',
                description:
                    'Developed in collaboration with Robert Fox, a highly vetted product designer with over two decades of experience. Fox partnered with Jamie to build the system architecture that transforms your aspirations into a metric-based progression journey.',
                themeController: themeController,
              ),
            ],
          ),
        );
      },
    );
  }
}

class ExpandableSectionWidget extends StatefulWidget {
  final String sectionTitle;
  final List<AboutTrainingModel> features;
  final bool isExpanded;
  final VoidCallback onToggle;

  const ExpandableSectionWidget({
    required this.sectionTitle,
    required this.features,
    required this.isExpanded,
    required this.onToggle,
    super.key,
  });

  @override
  State<ExpandableSectionWidget> createState() =>
      _ExpandableSectionWidgetState();
}

class _ExpandableSectionWidgetState extends State<ExpandableSectionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  final Set<int> _selectedIndices = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    if (widget.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ExpandableSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: widget.onToggle,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.sectionTitle,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: widget.features
                  .asMap()
                  .entries
                  .map(
                    (entry) => widget.sectionTitle == 'Why to be a partner?'
                        ? _buildPartnerFeatureItem(
                            entry.key,
                            entry.value.title,
                            entry.value.description,
                          )
                        : _buildFeatureItem(
                            entry.key,
                            entry.value.title,
                            entry.value.description,
                          ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(int index, String title, String description) {
    final isSelected = _selectedIndices.contains(index);
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedIndices.remove(index);
                    } else {
                      _selectedIndices.add(index);
                    }
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 2),
                  child: Image.asset(
                    isSelected ? IconPath.goldencircle : IconPath.whitecircle,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedIndices.remove(index);
                      } else {
                        _selectedIndices.add(index);
                      }
                    });
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$title ',
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? themeController.activeTheme.accentGoldColor
                                : Colors.white,
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

  Widget _buildPartnerFeatureItem(int index, String title, String description) {
    final isSelected = _selectedIndices.contains(index);
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedIndices.remove(index);
                    } else {
                      _selectedIndices.add(index);
                    }
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 2),
                  child: Image.asset(
                    isSelected ? IconPath.goldencircle : IconPath.whitecircle,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedIndices.remove(index);
                      } else {
                        _selectedIndices.add(index);
                      }
                    });
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$title ',
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? themeController.activeTheme.accentGoldColor
                                : Colors.white,
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

class ExpandableSectionsContainer extends StatefulWidget {
  final int selectedSection;
  final Function(int) onSectionChanged;
  final List<AboutTrainingModel> features;
  final List<AboutTrainingModel> partnerFeatures;

  const ExpandableSectionsContainer({
    required this.selectedSection,
    required this.onSectionChanged,
    required this.features,
    required this.partnerFeatures,
    super.key,
  });

  @override
  State<ExpandableSectionsContainer> createState() =>
      _ExpandableSectionsContainerState();
}

class _ExpandableSectionsContainerState
    extends State<ExpandableSectionsContainer> {
  final Set<int> _expandedSections = {0, 1};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpandableSectionWidget(
          sectionTitle: 'Why to use Velvet & Iron Training Codex?',
          features: widget.features,
          isExpanded: _expandedSections.contains(0),
          onToggle: () => setState(() {
            if (_expandedSections.contains(0)) {
              _expandedSections.remove(0);
            } else {
              _expandedSections.add(0);
            }
          }),
        ),
        const SizedBox(height: 8),
        ExpandableSectionWidget(
          sectionTitle: 'Why to be a partner?',
          features: widget.partnerFeatures,
          isExpanded: _expandedSections.contains(1),
          onToggle: () => setState(() {
            if (_expandedSections.contains(1)) {
              _expandedSections.remove(1);
            } else {
              _expandedSections.add(1);
            }
          }),
        ),
      ],
    );
  }
}

class IntroSectionWidget extends StatelessWidget {
  const IntroSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Intro',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'As a dedicated wellness enthusiast, progress is key. Exceeding personal records and fitness goals has become a way of life. Record workouts and track your training progression throughout the week while staying motivated via unlocking narrative content.',
            style: getTextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '"Forge on to see gains you don\'t give attention to return."',
            style: getTextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
