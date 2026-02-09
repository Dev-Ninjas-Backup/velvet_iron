import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/widgets/calorie_consumption_card.dart'
    hide IconPath;
import 'package:velvet_iron/features/medication_screen/controller/medication_controller.dart';
import 'package:velvet_iron/features/medication_screen/widgets/log_container.dart';
import 'package:velvet_iron/features/medication_screen/widgets/meal_tab_switcher_medication.dart';
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
                            .withValues(alpha: .5),
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
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: themeController
                                      .activeTheme
                                      .todoSubtitleColor,
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
                    CalorieConsumptionCard(),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomLogContainer(
                            iconPath: IconPath.injection,
                            title: "Dose Logged",
                            value: "50",
                            rewardAmount: "150",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomLogContainer(
                            iconPath: IconPath.quillpen,
                            title: "Next Dose",
                            value: "50",
                            rewardAmount: "150",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Log GLP-1 Dose",
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: themeController.activeTheme.cardBackgroundColor
                            .withValues(alpha: .7),
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
