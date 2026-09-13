import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/empty_state_card.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/weight_log_screen/controller/weight_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/weight_log_screen/model/weight_log_model.dart';

class Graph extends StatelessWidget {
  const Graph({super.key});

  /// Build spots from weekly entries, mapping each entry's date to its
  /// day-of-week index (0=Sun … 6=Sat).
  List<FlSpot> _buildSpots(List<WeeklyWeightEntry> entries) {
    final Map<int, double> daySpots = {};
    for (final entry in entries) {
      try {
        final date = DateTime.parse(entry.date);
        final dayIndex = date.weekday % 7; // DateTime: Mon=1…Sun=7 → Sun=0
        final weight = double.tryParse(entry.weight);
        if (weight != null && weight > 0) {
          daySpots[dayIndex] = weight;
        }
      } catch (_) {}
    }
    final spots = daySpots.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  /// Partition entries accurately based on calendar week (Sunday–Saturday).
  List<WeeklyWeightEntry> _getEntriesForFilter(
    List<WeeklyWeightEntry> allEntries,
    String selectedValue,
  ) {
    final now = DateTime.now();
    // Sunday as start of week (matching Sunday=0 in the chart's dayLabels)
    final daysSinceSunday = now.weekday % 7;
    final startOfThisWeek =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: daysSinceSunday));
    final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));

    return allEntries.where((entry) {
      try {
        final date = DateTime.parse(entry.date);
        final entryDay = DateTime(date.year, date.month, date.day);
        if (selectedValue == "this week") {
          return (entryDay.isAtSameMomentAs(startOfThisWeek) ||
                  entryDay.isAfter(startOfThisWeek)) &&
              entryDay.isBefore(startOfThisWeek.add(const Duration(days: 7)));
        } else {
          return (entryDay.isAtSameMomentAs(startOfLastWeek) ||
                  entryDay.isAfter(startOfLastWeek)) &&
              entryDay.isBefore(startOfThisWeek);
        }
      } catch (_) {
        return false;
      }
    }).toList();
  }

  /// Compute nice axis bounds from the data.
  /// Returns (minY, maxY, rightTitleValues).
  (double, double, List<int>) _computeYAxis(List<FlSpot> spots) {
    return (0, 240, [0, 80, 160, 240]);
  }

  @override
  Widget build(BuildContext context) {
    final weightLogController = Get.find<WeightLogController>();

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        final List<String> dayLabels = [
          'Sun',
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
        ];

        return Obx(() {
          final chartData = weightLogController.weeklyChartData.value;
          final selectedValue = weightLogController.selectedChart.value;

          // Collect all known entries from chartData and historyList (converted to kg)
          final allEntries = <WeeklyWeightEntry>[];
          if (chartData != null) {
            allEntries.addAll(chartData.thisWeek);
            allEntries.addAll(chartData.lastWeek);
          }

          final existingDates = {for (final e in allEntries) e.date};
          for (final h in weightLogController.historyList) {
            final dateStr =
                h.loggedAt.toLocal().toIso8601String().split('T').first;
            if (!existingDates.contains(dateStr)) {
              final lbs = double.tryParse(h.weight);
              if (lbs != null && lbs > 0) {
                final kg = (lbs / 2.20462).toStringAsFixed(1);
                allEntries.add(WeeklyWeightEntry(date: dateStr, weight: kg));
                existingDates.add(dateStr);
              }
            }
          }

          final entries = _getEntriesForFilter(allEntries, selectedValue);
          final spots = _buildSpots(entries);
          final (minY, maxY, rightTitleValues) = _computeYAxis(spots);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Weight Chart (kg)',
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
                        value: selectedValue,
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
                            weightLogController.setChart(val);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 155,
                child: spots.isEmpty
                    ? EmptyStateCard(
                        icon: Icons.show_chart_rounded,
                        title: 'No weight data for $selectedValue',
                        subtitle:
                            'Log your weight below to view your weekly progress chart.',
                        height: 150,
                        padding: const EdgeInsets.all(12),
                      )
                    : LineChart(
                        LineChartData(
                          lineTouchData: const LineTouchData(enabled: false),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: 6,
                          minY: minY,
                          maxY: maxY,
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  if (rightTitleValues.contains(
                                    value.toInt(),
                                  )) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: getTextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index >= 0 && index < dayLabels.length) {
                                    return Text(
                                      dayLabels[index],
                                      style: getTextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              gradient: themeController
                                  .activeTheme
                                  .progressBarGradient,
                              barWidth: 4.5,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 5,
                                    color: themeController
                                        .activeTheme
                                        .accentGoldColor,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        });
      },
    );
  }
}
