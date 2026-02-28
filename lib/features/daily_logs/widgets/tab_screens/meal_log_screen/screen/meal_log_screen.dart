import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/gradient_option_button.dart';
import 'package:velvet_iron/features/daily_logs/widgets/meal_tab_switcher.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/controller/meal_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/widgets/calorie_consumption_card.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/widgets/nutrition_loading_card.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/widgets/schedule_content.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/widgets/token_content.dart';

class MealLog extends StatelessWidget {
  const MealLog({
    super.key,
    required this.dailyLogController,
    required this.mealLogController,
  });

  final DailyLogController dailyLogController;
  final MealLogController mealLogController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
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
                      onTap: () => Get.back(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: themeController.activeTheme.todoSubtitleColor
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
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Obx(
                                () => CustomGradientOptionButton(
                                  text: "Weight Log",
                                  isSelected:
                                      dailyLogController.selectedTab.value == 0,
                                  onPressed: () => dailyLogController.setTab(0),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Obx(
                                () => CustomGradientOptionButton(
                                  text: "Mood Log",
                                  isSelected:
                                      dailyLogController.selectedTab.value == 1,
                                  onPressed: () => dailyLogController.setTab(1),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Obx(
                                () => CustomGradientOptionButton(
                                  text: "Meal Log",
                                  isSelected:
                                      dailyLogController.selectedTab.value == 2,
                                  onPressed: () => dailyLogController.setTab(2),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const CalorieConsumptionCard(),
                          const SizedBox(height: 15),

                          // ✅ CHANGE: hardcoded → real API data from controller
                          Obx(() {
                            final h = mealLogController.history.value;
                            final consumedCarb = h?.consumedCarb ?? 0;
                            final targetCarb = h?.macroNeed.carb ?? 0;
                            final consumedProtein = h?.consumedProtein ?? 0;
                            final targetProtein = h?.macroNeed.protein ?? 0;
                            final consumedFat = h?.consumedFat ?? 0;
                            final targetFat = h?.macroNeed.fat ?? 0;

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: NutritionLoadingCard(
                                      amount:
                                          "${consumedCarb.toInt()}/${targetCarb.toInt()} g",
                                      label: "Carbs",
                                      progress: targetCarb > 0
                                          ? (consumedCarb / targetCarb).clamp(
                                              0.0,
                                              1.0,
                                            )
                                          : 0.0,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    width: 100,
                                    child: NutritionLoadingCard(
                                      amount:
                                          "${consumedProtein.toInt()}/${targetProtein.toInt()} g",
                                      label: "Protein",
                                      progress: targetProtein > 0
                                          ? (consumedProtein / targetProtein)
                                                .clamp(0.0, 1.0)
                                          : 0.0,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    width: 100,
                                    child: NutritionLoadingCard(
                                      amount:
                                          "${consumedFat.toInt()}/${targetFat.toInt()} g",
                                      label: "Fats",
                                      progress: targetFat > 0
                                          ? (consumedFat / targetFat).clamp(
                                              0.0,
                                              1.0,
                                            )
                                          : 0.0,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          Text(
                            "Log a Meal",
                            style: getTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: themeController
                                  .activeTheme
                                  .cardBackgroundColor
                                  .withValues(alpha: .4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MealTabSwitcher(
                              controller: mealLogController,
                              tokenContent: TokenContent(
                                controller: mealLogController,
                              ),
                              scheduleContent: ScheduleContent(
                                controller: mealLogController,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
