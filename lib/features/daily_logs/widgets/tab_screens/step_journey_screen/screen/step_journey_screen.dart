import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/daily_log_tab_bar.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/controller/step_journey_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/widgets/fantasy_map_widget.dart';

class StepJourneyScreen extends StatelessWidget {
  final DailyLogController dailyLogController;
  final BottomNavController navController;

  const StepJourneyScreen({
    super.key,
    required this.dailyLogController,
    required this.navController,
  });

  void _showGoalModal(BuildContext context, StepJourneyController controller) {
    final theme = Get.find<AppThemeController>().activeTheme;
    final textController = TextEditingController(text: controller.goal.value.toString());

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: theme.dropdownBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: theme.borderColor, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step Journey Goal',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Set your daily walking milestone target (e.g. 8,000 or 10,000 steps).',
                style: getTextStyle(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Daily Step Goal',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: theme.cardBackgroundColor.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.accentGoldColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Save Target Goal',
                onPressed: () {
                  final val = int.tryParse(textController.text.trim());
                  if (val != null && val > 0) {
                    controller.updateGoal(val);
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomLogModal(BuildContext context, StepJourneyController controller) {
    final theme = Get.find<AppThemeController>().activeTheme;
    final textController = TextEditingController();
    var isIncremental = true.obs;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: theme.dropdownBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: theme.borderColor, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Record Steps Journeyed',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => isIncremental.value = true,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isIncremental.value
                                ? theme.accentGoldColor
                                : theme.cardBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isIncremental.value
                                  ? theme.accentGoldColor
                                  : theme.borderColor,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Add to Today',
                              style: TextStyle(
                                color: isIncremental.value ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => isIncremental.value = false,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !isIncremental.value
                                ? theme.accentGoldColor
                                : theme.cardBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: !isIncremental.value
                                  ? theme.accentGoldColor
                                  : theme.borderColor,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Set Today\'s Total',
                              style: TextStyle(
                                color: !isIncremental.value ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'e.g. 3500',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: theme.cardBackgroundColor.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.accentGoldColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Log Step Journey',
                onPressed: () {
                  final val = int.tryParse(textController.text.trim());
                  if (val != null && val > 0) {
                    if (isIncremental.value) {
                      controller.addSteps(val);
                    } else {
                      controller.setAbsoluteSteps(val);
                    }
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StepJourneyController());

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        final theme = themeController.activeTheme;

        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                floating: true,
                snap: true,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: Row(
                  children: [
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Get.back();
                        } else {
                          navController.changeTabIndex(0);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.todoSubtitleColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Daily Logs",
                      style: getTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 5-Tab Bar
                DailyLogTabBar(controller: dailyLogController),
                const SizedBox(height: 16),

                // Fantasy Adventure Map Hero
                Obx(
                  () => FantasyMapWidget(
                    metadata: controller.fantasyMap.value,
                    isCampSet: controller.isCampSet.value,
                    currentSteps: controller.steps.value,
                    goal: controller.goal.value,
                  ),
                ),
                const SizedBox(height: 14),

                // Step Status & Goal Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: theme.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.borderColor),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFE5A93C).withValues(alpha: 0.15),
                            ),
                            child: const Icon(
                              Icons.directions_walk_rounded,
                              color: Color(0xFFE5A93C),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Daily Expedition',
                                  style: getTextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Obx(
                                  () => Text(
                                    controller.display.value,
                                    style: getTextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: controller.isGoalReached.value
                                    ? const Color(0xFFE5A93C).withValues(alpha: 0.2)
                                    : Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: controller.isGoalReached.value
                                      ? const Color(0xFFE5A93C)
                                      : Colors.white24,
                                ),
                              ),
                              child: Text(
                                '${controller.percentage.value.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  color: controller.isGoalReached.value
                                      ? const Color(0xFFE5A93C)
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.settings_outlined, color: Colors.white70),
                            onPressed: () => _showGoalModal(context, controller),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Colors.white12, height: 1),
                      const SizedBox(height: 12),
                      // Cumulative Expedition Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Cumulative Journey Steps',
                                style: getTextStyle(fontSize: 11, color: Colors.white60),
                              ),
                              const SizedBox(height: 2),
                              Obx(
                                () => Text(
                                  '${controller.lifetimeSteps.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} steps',
                                  style: getTextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 24, color: Colors.white12),
                          Column(
                            children: [
                              Text(
                                'Campsites Pitched',
                                style: getTextStyle(fontSize: 11, color: Colors.white60),
                              ),
                              const SizedBox(height: 2),
                              Obx(
                                () => Text(
                                  '${controller.totalCampsites.value} nights',
                                  style: getTextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFD6B36A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Grand Journey Progress Bar (1,000,000 Steps Season Finish Line)
                      Obx(() {
                        const int grandJourneyGoal = 1000000;
                        final currentLifetime = controller.lifetimeSteps.value;
                        final ratio = (currentLifetime / grandJourneyGoal).clamp(0.0, 1.0);
                        final percentStr = (ratio * 100).toStringAsFixed(2);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Grand Journey: The Long March',
                                  style: getTextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFD6B36A),
                                  ),
                                ),
                                Text(
                                  '$percentStr%',
                                  style: getTextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFD6B36A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: ratio,
                                minHeight: 6,
                                backgroundColor: Colors.white12,
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD6B36A)),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${currentLifetime.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} / 1,000,000 steps to The World\'s Edge',
                              style: getTextStyle(fontSize: 10, color: Colors.white54),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Camp Status Banner (if camp is already set) - Navy & Antique Gold
                Obx(() {
                  if (!controller.isCampSet.value) return const SizedBox.shrink();
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => controller.showCampDetails(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F1B2B).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFD6B36A).withValues(alpha: 0.7)),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              ImagePath.campTentFire,
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Camp Pitched for the Night',
                                        style: getTextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFD6B36A),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'View Camp',
                                            style: getTextStyle(
                                              fontSize: 10,
                                              color: const Color(0xFFD6B36A),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          const Icon(Icons.arrow_forward_ios, size: 10, color: Color(0xFFD6B36A)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Today\'s journey is locked. Rest well traveler; a new path opens at sunrise.',
                                    style: getTextStyle(
                                      fontSize: 11,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // Quick Step Logging
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Log Walking Distance',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: controller.isCampSet.value
                          ? null
                          : () => _showCustomLogModal(context, controller),
                      icon: Icon(
                        Icons.add,
                        size: 16,
                        color: controller.isCampSet.value ? Colors.white38 : const Color(0xFFE5A93C),
                      ),
                      label: Text(
                        'Custom',
                        style: getTextStyle(
                          fontSize: 13,
                          color: controller.isCampSet.value ? Colors.white38 : const Color(0xFFE5A93C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Quick Add Increment Buttons
                Row(
                  children: [1000, 2500, 5000].map((inc) {
                    final label = '+${inc.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Obx(
                          () => GestureDetector(
                            onTap: controller.isCampSet.value ? null : () => controller.addSteps(inc),
                            child: Opacity(
                              opacity: controller.isCampSet.value ? 0.4 : 1.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF8B5A2B),
                                      Color(0xFF5C381E),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFD6B36A).withValues(alpha: 0.6),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Evening Ritual: Set Up Camp Button
                Obx(() {
                  final isCamp = controller.isCampSet.value;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: isCamp
                          ? Border.all(color: const Color(0xFFD6B36A).withValues(alpha: 0.5), width: 1.5)
                          : null,
                      gradient: isCamp
                          ? LinearGradient(
                              colors: [
                                const Color(0xFF0F1B2B).withValues(alpha: 0.85),
                                const Color(0xFF16253B).withValues(alpha: 0.85),
                              ],
                            )
                          : const LinearGradient(
                              colors: [
                                Color(0xFFD4AF37),
                                Color(0xFFB8860B),
                                Color(0xFF8B6508),
                              ],
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: isCamp
                              ? Colors.black26
                              : const Color(0xFFD4AF37).withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isCamp
                            ? () => controller.showCampDetails(context)
                            : () => controller.confirmSetUpCamp(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImagePath.campTentFire,
                                width: 28,
                                height: 28,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                isCamp ? 'Camp Pitched • Rest Until Dawn' : 'Set Up Camp (+20 XP)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isCamp ? const Color(0xFFD6B36A) : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Pitching camp ends today\'s expedition, secures cumulative progress, and earns +20 XP.',
                    textAlign: TextAlign.center,
                    style: getTextStyle(fontSize: 11, color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
