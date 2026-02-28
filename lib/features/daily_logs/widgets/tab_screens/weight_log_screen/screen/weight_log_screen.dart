import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/gradient_option_button.dart';
import 'package:velvet_iron/features/daily_logs/widgets/log_history_item.dart';
import 'package:velvet_iron/features/daily_logs/widgets/log_your_weight.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/weight_log_screen/controller/weight_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/weight_log_screen/widgets/graph.dart';
import 'package:velvet_iron/features/daily_logs/widgets/weight_status_card.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class WeightLog extends StatelessWidget {
  const WeightLog({
    super.key,
    required this.dailyLogController,
    required this.navController,
    required this.weightLogController,
  });
  final DailyLogController dailyLogController;
  final BottomNavController navController;
  final WeightLogController weightLogController;

  String _formatDate(DateTime dt) {
    return DateFormat("dd MMM, EEE - hh:mm a").format(dt.toLocal());
  }

  String _formatChange(String? changeType) {
    if (changeType == null || changeType.isEmpty) return '';
    if (changeType.startsWith('increase')) {
      final val = changeType.replaceAll('increase:', '').trim();
      return '$val lbs increased';
    } else if (changeType.startsWith('decrease')) {
      final val = changeType.replaceAll('decrease:', '').trim();
      return '$val lbs decreased';
    }
    return changeType;
  }

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
                      onTap: () {
                        navController.changeTabIndex(0);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: themeController.activeTheme.todoSubtitleColor
                              .withValues(alpha: 0.2),
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
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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

                          // Status Cards 
                          Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => WeightStatusCard(
                                    iconPath:
                                        themeController.activeTheme.id ==
                                            'adventurer'
                                        ? 'assets/icons/steelyard_adventure.png'
                                        : themeController.activeTheme.id ==
                                              'mage'
                                        ? 'assets/icons/steelyard_mage.png'
                                        : themeController.activeTheme.id ==
                                              'gamer'
                                        ? 'assets/icons/steelyard_gamer.png'
                                        : 'assets/icons/steelyard_reader.png',
                                    weightValue:
                                        "${weightLogController.currentWeight.value} lbs",
                                    label: "Current Weight",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Obx(
                                  () => WeightStatusCard(
                                    iconPath:
                                        themeController.activeTheme.id ==
                                            'adventurer'
                                        ? 'assets/icons/updown_adventure.png'
                                        : themeController.activeTheme.id ==
                                              'mage'
                                        ? 'assets/icons/updown_mage.png'
                                        : themeController.activeTheme.id ==
                                              'gamer'
                                        ? 'assets/icons/updown_gamer.png'
                                        : 'assets/icons/updown_reader.png',
                                    weightValue:
                                        "${weightLogController.totalChange.value} lbs",
                                    label: "Total Change",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Obx(
                                  () => WeightStatusCard(
                                    iconPath:
                                        themeController.activeTheme.id ==
                                            'adventurer'
                                        ? 'assets/icons/clock_adventure.png'
                                        : themeController.activeTheme.id ==
                                              'mage'
                                        ? 'assets/icons/clock_mage.png'
                                        : themeController.activeTheme.id ==
                                              'gamer'
                                        ? 'assets/icons/clock_gamer.png'
                                        : 'assets/icons/clock_reader.png',
                                    weightValue:
                                        weightLogController.entriesLogged.value,
                                    label: "Entries Logged",
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          const Graph(),
                          const SizedBox(height: 8),

                          // Log Your Weight

                          Text(
                            "Log Your Weight",
                            style: getTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          LogYourWeightCard(
                            weightController:
                                weightLogController.weightController,
                            noteController: weightLogController.noteController,
                            onPressed: () =>
                                weightLogController.submitWeightLog(),
                          ),
                          const SizedBox(height: 20),

                          //  Log History 
                          Text(
                            "Log History",
                            style: getTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(() {
                            if (weightLogController.historyList.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: Text(
                                    "No logs yet. Start logging your weight!",
                                    style: getTextStyle(
                                      fontSize: 14,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: weightLogController.historyList.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final item =
                                    weightLogController.historyList[index];
                                return LogHistoryItem(
                                  title: "${item.weight} lbs",
                                  xpText: "+${item.earnedXp} XP",
                                  iconPath: IconPath.whiteSteelyard,
                                  secondText: _formatChange(item.changeType),
                                  thirdText: item.note ?? '',
                                  dateTimeText: _formatDate(item.loggedAt),
                                );
                              },
                            );
                          }),
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
