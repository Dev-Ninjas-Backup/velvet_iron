import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/services/expedition_content_service.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/models/step_journey_model.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/service/step_journey_service.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/features/quests/controller/quest_controller.dart';

class StepJourneyController extends GetxController {
  final StepJourneyService _service = StepJourneyService();

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  final RxInt steps = 0.obs;
  final RxInt goal = 8000.obs;
  final RxString display = '0 / 8,000 steps'.obs;
  final RxDouble percentage = 0.0.obs;
  final RxBool isGoalReached = false.obs;
  final RxBool isCampSet = false.obs;
  final Rx<DateTime?> campSetAt = Rx<DateTime?>(null);
  final RxInt lifetimeSteps = 0.obs;
  final RxInt totalCampsites = 0.obs;
  final RxDouble journeyRatio = 0.0.obs;
  final RxString nextLandmarkText = ''.obs;
  final Rx<FantasyMapMetadata> fantasyMap = Rx<FantasyMapMetadata>(FantasyMapMetadata.empty());

  @override
  void onInit() {
    super.onInit();
    ExpeditionContentService().init();
    fetchTodaySteps();
  }

  Future<void> fetchTodaySteps({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;
      final res = await _service.getTodaySteps();

      steps.value = res.steps;
      goal.value = res.goal;
      display.value = res.display;
      percentage.value = res.percentage;
      isGoalReached.value = res.isGoalReached;
      isCampSet.value = res.isCampSet;
      campSetAt.value = res.campSetAt;
      lifetimeSteps.value = res.lifetimeSteps;
      totalCampsites.value = res.totalCampsites;

      await ExpeditionContentService().init();
      final landmarkStatus = ExpeditionContentService().getLandmarkStatus(res.lifetimeSteps);
      journeyRatio.value = ExpeditionContentService().getJourneyProgressRatio(res.lifetimeSteps);
      nextLandmarkText.value = '${landmarkStatus.nextMilestone.name} • ${landmarkStatus.stepsToNext.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} steps away';

      fantasyMap.value = FantasyMapMetadata(
        currentLandmark: landmarkStatus.currentMilestone?.name ?? 'The Starting Outpost',
        nextLandmark: nextLandmarkText.value,
        progressRatio: journeyRatio.value,
        unlockedMilestones: res.fantasyMap.unlockedMilestones,
        activeLore: landmarkStatus.currentMilestone?.lore ?? res.fantasyMap.activeLore,
        companionReaction: res.fantasyMap.companionReaction,
      );
    } catch (e) {
      debugPrint('[StepJourneyController] Error fetching steps: $e');
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  /// Add incremental steps (e.g. +1,000)
  Future<void> addSteps(int increment) async {
    if (isCampSet.value) {
      EasyLoading.showInfo('Camp has already been pitched for today. Today\'s steps are locked.');
      return;
    }

    if (isSubmitting.value) return;

    final prevSteps = steps.value;
    final prevDisplay = display.value;
    final prevPercentage = percentage.value;
    final newTotal = prevSteps + increment;

    // Anti-abuse realistic daily limit guard
    if (newTotal > 50000) {
      EasyLoading.showInfo('Daily walking limit reached (50,000 steps). Rest your legs, traveler!');
      return;
    }

    try {
      isSubmitting.value = true;

      // Optimistic update
      final newTotal = prevSteps + increment;
      steps.value = newTotal;
      percentage.value = goal.value > 0 ? (newTotal / goal.value) * 100 : 0.0;
      display.value = '${newTotal.toString()} / ${goal.value.toString()} steps';

      await _service.updateSteps(addSteps: increment);
      EasyLoading.showSuccess('+$increment Steps Journeyed!');

      await fetchTodaySteps(showLoading: false);

      if (Get.isRegistered<QuestController>()) {
        Get.find<QuestController>().fetchQuests();
      }
    } catch (e) {
      steps.value = prevSteps;
      display.value = prevDisplay;
      percentage.value = prevPercentage;
      EasyLoading.showError('Failed to update steps: ${e.toString()}');
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Set absolute step count
  Future<void> setAbsoluteSteps(int absoluteTotal) async {
    if (isCampSet.value) {
      EasyLoading.showInfo('Camp has already been pitched for today. Today\'s steps are locked.');
      return;
    }

    try {
      EasyLoading.show(status: 'Recording journey...');
      await _service.updateSteps(steps: absoluteTotal);
      EasyLoading.showSuccess('Steps updated!');
      await fetchTodaySteps(showLoading: false);

      if (Get.isRegistered<QuestController>()) {
        Get.find<QuestController>().fetchQuests();
      }
    } catch (e) {
      EasyLoading.showError('Failed to update steps: ${e.toString()}');
    }
  }

  /// Update daily step goal
  Future<void> updateGoal(int newGoal) async {
    try {
      EasyLoading.show(status: 'Updating goal...');
      await _service.updateStepGoal(newGoal);
      EasyLoading.showSuccess('Step goal updated!');
      await fetchTodaySteps(showLoading: false);
    } catch (e) {
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }

  /// Set Up Camp Ritual flow
  Future<void> confirmSetUpCamp(BuildContext context) async {
    if (isCampSet.value) {
      EasyLoading.showInfo('Camp is already pitched for tonight.');
      return;
    }

    final theme = Get.find<AppThemeController>().activeTheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: theme.dropdownBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.accentGoldColor, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  ImagePath.campTentFire,
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Text(
                  'Set Up Camp?',
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your journey for today will end here with ${steps.value} steps traveled. Once camp is established, today\'s journey cannot be changed.',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(
                          'Keep Walking',
                          style: getTextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE5A93C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text(
                          'Pitch Camp (+20 XP)',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed == true && context.mounted) {
      await _executeCampRitual(context);
    }
  }

  Future<void> _executeCampRitual(BuildContext context) async {
    try {
      EasyLoading.show(status: 'Pitching camp under the stars...');
      final res = await _service.setUpCamp();
      EasyLoading.dismiss();

      isCampSet.value = true;
      campSetAt.value = res.campSetAt ?? DateTime.now();
      lifetimeSteps.value = res.lifetimeSteps;
      totalCampsites.value = res.totalCampsites;

      await fetchTodaySteps(showLoading: false);

      if (context.mounted) {
        showCampDetails(context, stepsLocked: res.stepsLocked, earnedXp: res.earnedXp);
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  /// Show rich campsite celebration & resting companion modal
  Future<void> showCampDetails(BuildContext context, {int? stepsLocked, int? earnedXp}) async {
    String companionName = 'Riven';
    final savedCompanion = await SharedPreferencesHelper.getActiveCompanion();
    if (savedCompanion != null && savedCompanion['name'] != null && savedCompanion['name']!.isNotEmpty) {
      companionName = savedCompanion['name']!;
    } else if (Get.isRegistered<HomeController>()) {
      companionName = Get.find<HomeController>().companionName;
    }

    final restingAsset = ExpeditionContentService().getRestingPoseAsset(companionName);
    final campQuote = ExpeditionContentService().getRandomCampsiteQuote(companionName);
    final locked = stepsLocked ?? steps.value;
    final xp = earnedXp ?? 20;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1B2B).withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFD6B36A), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE5A93C).withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Campsite Scene Artwork
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      ImagePath.campsiteScene,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.nightlight_round, color: Color(0xFFE5A93C), size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Campfire Lit!',
                        style: getTextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE5A93C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$locked steps permanently recorded into your cumulative journey.',
                    textAlign: TextAlign.center,
                    style: getTextStyle(fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5A93C).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5A93C)),
                    ),
                    child: Text(
                      '+$xp XP Awarded',
                      style: const TextStyle(
                        color: Color(0xFFE5A93C),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Resting Companion Avatar & Campsite Quote
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFD6B36A).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFD6B36A).withValues(alpha: 0.6)),
                            color: Colors.black38,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.asset(
                              restingAsset,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                companionName,
                                style: const TextStyle(
                                  color: Color(0xFFD6B36A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '"$campQuote"',
                                style: getTextStyle(
                                  fontSize: 11,
                                  color: Colors.white70,
                                ).copyWith(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD6B36A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        'Rest for Tonight',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
