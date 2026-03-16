import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/medication_screen/controller/medication_controller.dart';
import 'package:velvet_iron/features/medication_screen/widgets/log_container.dart';
import 'package:velvet_iron/features/medication_screen/widgets/meal_tab_switcher_medication.dart';
import 'package:velvet_iron/features/medication_screen/widgets/medicine_consumption_card.dart'
    hide IconPath;
import 'package:velvet_iron/features/medication_screen/widgets/schedule_content_medication.dart';
import 'package:velvet_iron/features/medication_screen/widgets/token_content_medication.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  MedicationController get controller => Get.put(MedicationController());
  BottomNavController get bottomNavController =>
      Get.find<BottomNavController>();

  @override
  Widget build(BuildContext context) {
    final navController = bottomNavController;
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: themeController.activeTheme.backgroundGradient,
              ),
            ),
            Opacity(
              opacity: 0.2,
              child: Image.asset(
                themeController.activeTheme.backgroundImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        backgroundColor: themeController
                            .activeTheme
                            .todoSubtitleColor
                            .withValues(alpha: 0.0),
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
                                navController.changeTabIndex(1);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: themeController
                                      .activeTheme
                                      .todoSubtitleColor
                                      .withValues(alpha: .2),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "GLP-1 Medication",
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MedicineConsumptionCard(),
                    const SizedBox(height: 8),
                    Obx(() {
                      final h = controller.historyData.value;
                      final totalLogged = h?.totalCount ?? 0;
                      final totalXp = h?.totalEarnedXp ?? 0;
                      final nextDose = h?.nextSchedule;
                      final nextDoseValue = nextDose != null
                          ? "${nextDose.name} ${nextDose.doseMg.toInt()}mg"
                          : "No schedule";
                      final pendingCount = h?.pendingCount ?? 0;

                      return Row(
                        children: [
                          Expanded(
                            child: CustomLogContainer(
                              iconPath:
                                  themeController.activeTheme.id == 'adventurer'
                                  ? IconPath.injectionAdventure
                                  : themeController.activeTheme.id == 'mage'
                                  ? IconPath.injectionMage
                                  : themeController.activeTheme.id == 'gamer'
                                  ? IconPath.injectionGamer
                                  : IconPath.injectionReader,
                              title: "Dose Logged",
                              value: "$totalLogged",
                              rewardAmount: "$totalXp",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomLogContainer(
                              iconPath:
                                  themeController.activeTheme.id == 'adventurer'
                                  ? IconPath.quillpenAdenture
                                  : themeController.activeTheme.id == 'mage'
                                  ? IconPath.quillpenMage
                                  : themeController.activeTheme.id == 'gamer'
                                  ? IconPath.quillpenGamer
                                  : IconPath.quillpenReader,
                              title: "Next Dose",
                              value: nextDoseValue,
                              rewardAmount: "$pendingCount",
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 20),
                    Text(
                      "Add Dose (+10 XP)",
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: themeController.activeTheme.cardBackgroundColor
                            .withValues(alpha: .5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MealTabSwitcherMedication(
                        controller: controller,
                        tokenContent: TokenContentMedication(
                          controller: controller,
                        ),
                        scheduleContent: ScheduleContentMedication(
                          controller: controller,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
