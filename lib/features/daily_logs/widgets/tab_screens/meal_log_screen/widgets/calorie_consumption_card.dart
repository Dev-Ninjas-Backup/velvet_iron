import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class IconPath {
  static const String goldencircle = 'assets/icons/goldencircle.png';
  static const String whitecircle = 'assets/icons/whitecircle.png';
}

class CalorieConsumptionCard extends StatefulWidget {
  const CalorieConsumptionCard({super.key});

  @override
  State<CalorieConsumptionCard> createState() => _CalorieConsumptionCardState();
}

class _CalorieConsumptionCardState extends State<CalorieConsumptionCard> {
  List<bool> activeDays = [true, true, true, true, false, false, false];
  String selectedPeriod = "this week";
  bool isLoading = true;

  final List<String> weekDays = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: themeController.activeTheme.cardBackgroundColor.withValues(
              alpha: .4,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Calories Consumption",
                    style: getTextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const Spacer(),
                  Container(
                    height: 22,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: themeController.activeTheme.todoSubtitleColor
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: themeController.activeTheme.borderColor,
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPeriod,
                        isDense: true,
                        dropdownColor: themeController
                            .activeTheme
                            .todoSubtitleColor
                            .withValues(alpha: 0.3),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 14,
                          color: Colors.white,
                        ),
                        items: ["this day", "this week", "this month"].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: getTextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => selectedPeriod = newValue);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(weekDays.length, (index) {
                  final bool isActive = activeDays[index];
                  String dotIcon = isActive
                      ? (themeController.activeTheme.id == 'adventurer'
                            ? 'assets/icons/doticon_adventure.png'
                            : themeController.activeTheme.id == 'mage'
                            ? 'assets/icons/doticon_mage.png'
                            : themeController.activeTheme.id == 'gamer'
                            ? 'assets/icons/doticon_gamer.png'
                            : 'assets/icons/doticon_reader.png')
                      : IconPath.whitecircle;

                  return Container(
                    width: 43,
                    height: 60,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: themeController.activeTheme.todoSubtitleColor
                          .withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                // gradient: themeController
                                //     .activeTheme
                                //     .progressBarGradient,
                              ),
                            ),
                            Image.asset(dotIcon, width: 18, height: 18),
                          ],
                        ),
                        Text(
                          weekDays[index],
                          style: getTextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Calories",
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "590/796 kcal",
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 6,
                    decoration: BoxDecoration(
                      color: themeController.activeTheme.textfieldColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: constraints.maxWidth * 0.6,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient:
                              themeController.activeTheme.progressBarGradient,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
