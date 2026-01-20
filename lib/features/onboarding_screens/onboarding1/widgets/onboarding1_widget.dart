import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding1/controller/onboarding1_controller.dart';

class StepsTextWidget extends StatelessWidget {
  const StepsTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<OnboardingController1>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Steps 1 / 9',
            style: getTextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Image.asset(IconPath.trophy, width: 8, height: 14),
              SizedBox(width: 1.5),
              Text(
                '+10 XP',
                style: getTextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController1>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 6,
            child: Stack(
              children: [
                Container(color: Colors.white.withValues(alpha: 0.7)),
                FractionallySizedBox(
                  widthFactor: controller.progressValue,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFDE7BB),
                          Color(0xFF9E6D38),
                          Color(0xFFE9B86E),
                          Color(0xFFE5B46B),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            'Choose a theme companion',
            textAlign: TextAlign.center,
            style: getTextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'It is kind of your personal assistant who keep you mobilize everything. Still you can changes it later from settings.',
            textAlign: TextAlign.center,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }
}

class CompanionCard extends StatelessWidget {
  final CompanionModel companion;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onUnlock;
  final bool isUnlocked;

  const CompanionCard({
    super.key,
    required this.companion,
    required this.isSelected,
    required this.onTap,
    required this.onUnlock,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFDE7BB),
              Color(0xFF9E6D38),
              Color(0xFFE9B86E),
              Color(0xFFE5B46B),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          height: 168,
          decoration: BoxDecoration(
            gradient: companion.bgGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: _buildCardContent(),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSelectionIndicator(),
                const SizedBox(height: 8),
                Text(
                  companion.name,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  companion.title,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                const Spacer(),
                if (companion.isActive && companion.theme.isNotEmpty)
                  _buildActiveBadge()
                else if (!isUnlocked && companion.unlockXp != null)
                  _buildUnlockButton(),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(companion.bgImage, fit: BoxFit.cover),
              ),
              Center(
                child: Image.asset(
                  companion.imagePath,
                  width: 102,
                  height: 143,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionIndicator() {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color.fromARGB(179, 238, 221, 158),
          width: 2,
        ),
        color: isSelected ? const Color(0xFFF9F9F9) : Colors.transparent,
      ),
    );
  }

  Widget _buildActiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF410404),
        borderRadius: BorderRadius.circular(29),
      ),
      child: Text(
        companion.theme,
        style: getTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }

  Widget _buildUnlockButton() {
    return GestureDetector(
      onTap: onUnlock,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: companion.bgGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unlock ${companion.unlockXp} xp',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.lock_outline, size: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
