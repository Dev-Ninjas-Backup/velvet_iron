import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/features/home/models/home_screen_model.dart';

class WeeklyActivityProgress extends StatelessWidget {
  final String title;
  WeeklyActivityProgress({super.key, required this.title});

  final RxString _selectedValue = 'this week'.obs;

  static const List<String> xpLabels = [
    '100xp',
    '80xp',
    '60xp',
    '40xp',
    '20xp',
  ];

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : null;

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Obx(() {
          // Reactively observe chart data and current chart filter
          final List<double> weeklyData = homeController?.chartData ?? List.filled(7, 0.0);
          final List<XPDayData> chartDays = homeController?.currentChartDays ?? [];

          // Compute dynamic maximum Y bound (minimum 100 XP, rounded to nearest 20)
          final maxVal = weeklyData.isNotEmpty
              ? weeklyData.reduce((a, b) => a > b ? a : b)
              : 0.0;
          final double chartMaxY = maxVal > 100
              ? ((maxVal / 20).ceil() * 20).toDouble()
              : 100.0;

          // Compute dynamic 5-level Y-axis labels
          final step = chartMaxY / 5;
          final dynamicXpLabels = [
            '${chartMaxY.toInt()}xp',
            '${(chartMaxY - step).toInt()}xp',
            '${(chartMaxY - step * 2).toInt()}xp',
            '${(chartMaxY - step * 3).toInt()}xp',
            '${(chartMaxY - step * 4).toInt()}xp',
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 26,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(
                        color: themeController.activeTheme.borderColor,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedValue.value,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Colors.white,
                        ),
                        style: getTextStyle(fontSize: 10, color: Colors.white),
                        dropdownColor:
                            themeController.activeTheme.dropdownBackgroundColor,
                        items: ['this week', 'last week']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            _selectedValue.value = val;
                            if (val == 'last week') {
                              homeController?.selectChartFilter('lastWeek');
                            } else {
                              homeController?.selectChartFilter('currentWeek');
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          minY: 0,
                          maxY: chartMaxY,
                          alignment: BarChartAlignment.spaceBetween,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                String dayName = 'Day';
                                if (groupIndex < chartDays.length &&
                                    chartDays[groupIndex].day.isNotEmpty) {
                                  dayName = chartDays[groupIndex].day;
                                }
                                return BarTooltipItem(
                                  '$dayName\n${rod.toY.toInt()} XP',
                                  getTextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  if (idx < 0 || idx >= weeklyData.length) {
                                    return const SizedBox.shrink();
                                  }

                                  String dayLabel = '';
                                  if (idx < chartDays.length) {
                                    final serverDay = chartDays[idx].day.trim();
                                    if (serverDay.isNotEmpty) {
                                      dayLabel = serverDay.length > 3
                                          ? serverDay.substring(0, 3)
                                          : serverDay;
                                    }
                                  }

                                  if (dayLabel.isEmpty) {
                                    const fallbackDays = [
                                      'Sun',
                                      'Mon',
                                      'Tue',
                                      'Wed',
                                      'Thu',
                                      'Fri',
                                      'Sat',
                                    ];
                                    dayLabel = idx < fallbackDays.length
                                        ? fallbackDays[idx]
                                        : '';
                                  }

                                  return FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      dayLabel,
                                      style: getTextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: weeklyData.asMap().entries.map((e) {
                            return BarChartGroupData(
                              x: e.key,
                              barRods: [
                                BarChartRodData(
                                  toY: e.value,
                                  width: 29,
                                  borderRadius: BorderRadius.circular(6),
                                  color: themeController.activeTheme.graphColor
                                      .withValues(alpha: 0.60),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),
                    SizedBox(
                      width: 38,
                      height: 114,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: dynamicXpLabels.map((xp) {
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: themeController.activeTheme.borderColor,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                xp,
                                style: getTextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
