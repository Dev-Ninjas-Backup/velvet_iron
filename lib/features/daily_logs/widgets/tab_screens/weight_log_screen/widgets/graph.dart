import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/empty_state_card.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/weight_log_screen/controller/weight_log_controller.dart';

class Graph extends StatelessWidget {
  const Graph({super.key});

  static const List<String> availableTimeframes = [
    'Weekly',
    'Monthly',
    '3 Months',
    '6 Months',
    'Yearly',
    'All Time',
  ];

  /// Compute dynamic axis bounds based on user's actual recorded weights.
  /// Never defaults to 0-240; tightly bounds around recorded weights (e.g. 215-225).
  (double, double, List<int>) _computeYAxis(List<FlSpot> spots) {
    if (spots.isEmpty) {
      return (150.0, 250.0, [150, 175, 200, 225, 250]);
    }
    final weights = spots.map((s) => s.y).toList();
    final minW = weights.reduce(min);
    final maxW = weights.reduce(max);

    double minY;
    double maxY;

    if ((maxW - minW).abs() < 0.1) {
      // Single weight or all identical weights (e.g., 218 lbs)
      minY = (minW - 5).floorToDouble();
      maxY = (maxW + 5).ceilToDouble();
    } else {
      final range = maxW - minW;
      final padding = (range * 0.25).clamp(2.0, 15.0);
      minY = (minW - padding).floorToDouble();
      maxY = (maxW + padding).ceilToDouble();
    }

    if (minY < 0) minY = 0;
    if (maxY <= minY) maxY = minY + 10;

    // Build 4-5 evenly spaced ticks
    final span = (maxY - minY).toInt();
    final step = (span / 4).ceil().clamp(1, 100);
    final List<int> rightTitleValues = [];
    for (int v = minY.toInt(); v <= maxY.toInt(); v += step) {
      rightTitleValues.add(v);
    }
    if (!rightTitleValues.contains(maxY.toInt())) {
      rightTitleValues.add(maxY.toInt());
    }
    return (minY, maxY, rightTitleValues);
  }

  @override
  Widget build(BuildContext context) {
    final weightLogController = Get.find<WeightLogController>();

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        const List<String> dayLabels = [
          'Sun',
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
        ];

        return Obx(() {
          final rawSelection = weightLogController.selectedChart.value;
          final selectedValue = rawSelection == 'this week'
              ? 'Weekly'
              : (availableTimeframes.contains(rawSelection) ? rawSelection : 'Weekly');

          final isWeekly = selectedValue == 'Weekly';

          // 1. Gather all unique daily entries in lbs
          final Map<DateTime, double> uniqueEntriesByDay = {};

          // Prioritize historyList (authoritative logs directly entered by user in lbs)
          for (final h in weightLogController.historyList) {
            final localDt = h.loggedAt.toLocal();
            final dayKey = DateTime(localDt.year, localDt.month, localDt.day);
            final w = double.tryParse(h.weight);
            if (w != null && w > 0) {
              uniqueEntriesByDay[dayKey] = w;
            }
          }

          // Fallback to weeklyChartData if historyList lacks that day
          final chartData = weightLogController.weeklyChartData.value;
          if (chartData != null) {
            final chartItems = [...chartData.thisWeek, ...chartData.lastWeek];
            for (final c in chartItems) {
              final parsedDate = DateTime.tryParse(c.date);
              if (parsedDate != null) {
                final dayKey = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
                if (!uniqueEntriesByDay.containsKey(dayKey)) {
                  var w = double.tryParse(c.weight);
                  if (w != null && w > 0) {
                    // Safety check: if user's known entries are ~200 lbs and chartData sent ~98 (kg), convert to lbs
                    if (uniqueEntriesByDay.isNotEmpty) {
                      final avgLbs = uniqueEntriesByDay.values.reduce((a, b) => a + b) / uniqueEntriesByDay.length;
                      if (avgLbs > 140 && w < 110) {
                        w = w * 2.20462;
                      }
                    }
                    uniqueEntriesByDay[dayKey] = double.parse(w.toStringAsFixed(1));
                  }
                }
              }
            }
          }

          // 2. Filter entries by the selected timeframe
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          List<MapEntry<DateTime, double>> filteredEntries;

          if (isWeekly) {
            final daysSinceSunday = today.weekday % 7;
            final startOfWeek = today.subtract(Duration(days: daysSinceSunday));
            final endOfWeek = startOfWeek.add(const Duration(days: 7));
            filteredEntries = uniqueEntriesByDay.entries.where((e) {
              return !e.key.isBefore(startOfWeek) && e.key.isBefore(endOfWeek);
            }).toList();
          } else if (selectedValue == 'Monthly') {
            final startOfMonth = today.subtract(const Duration(days: 30));
            filteredEntries = uniqueEntriesByDay.entries
                .where((e) => !e.key.isBefore(startOfMonth))
                .toList();
          } else if (selectedValue == '3 Months') {
            final start3M = today.subtract(const Duration(days: 90));
            filteredEntries = uniqueEntriesByDay.entries
                .where((e) => !e.key.isBefore(start3M))
                .toList();
          } else if (selectedValue == '6 Months') {
            final start6M = today.subtract(const Duration(days: 180));
            filteredEntries = uniqueEntriesByDay.entries
                .where((e) => !e.key.isBefore(start6M))
                .toList();
          } else if (selectedValue == 'Yearly') {
            final startYear = today.subtract(const Duration(days: 365));
            filteredEntries = uniqueEntriesByDay.entries
                .where((e) => !e.key.isBefore(startYear))
                .toList();
          } else {
            // 'All Time'
            filteredEntries = uniqueEntriesByDay.entries.toList();
          }

          // Sort chronologically
          filteredEntries.sort((a, b) => a.key.compareTo(b.key));

          // 3. Build spots & X-axis mapping
          final List<FlSpot> spots = [];
          double minX = 0;
          double maxX = 6;

          if (isWeekly) {
            final Map<int, double> weekDaySpots = {};
            for (final e in filteredEntries) {
              final dayIndex = e.key.weekday % 7; // Sunday=0, Monday=1...
              weekDaySpots[dayIndex] = e.value;
            }
            for (final e in weekDaySpots.entries) {
              spots.add(FlSpot(e.key.toDouble(), e.value));
            }
            spots.sort((a, b) => a.x.compareTo(b.x));
            minX = 0;
            maxX = 6;
          } else {
            if (filteredEntries.isNotEmpty) {
              for (int i = 0; i < filteredEntries.length; i++) {
                spots.add(FlSpot(i.toDouble(), filteredEntries[i].value));
              }
              minX = 0;
              maxX = max(1.0, (filteredEntries.length - 1).toDouble());
            }
          }

          final (minY, maxY, rightTitleValues) = _computeYAxis(spots);

          // Calculate bottom title step for non-weekly timeframes
          final int xStep = filteredEntries.length <= 5
              ? 1
              : ((filteredEntries.length - 1) / 4).ceil().clamp(1, 100);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Weight Chart (lbs)',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(
                        color: themeController.activeTheme.borderColor,
                      ),
                      color: themeController.activeTheme.cardBackgroundColor.withValues(alpha: 0.4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValue,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Colors.white,
                        ),
                        style: getTextStyle(fontSize: 10.5, color: Colors.white),
                        dropdownColor:
                            themeController.activeTheme.dropdownBackgroundColor,
                        items: availableTimeframes
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
                height: 165,
                child: spots.isEmpty
                    ? EmptyStateCard(
                        icon: Icons.show_chart_rounded,
                        title: 'No weight data for $selectedValue',
                        subtitle:
                            'Log your weight below to view your progress chart.',
                        height: 155,
                        padding: const EdgeInsets.all(12),
                      )
                    : LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (_) =>
                                  themeController.activeTheme.popupBackgroundColor ??
                                  const Color(0xFF1E142B),
                              
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  final valStr = spot.y.toStringAsFixed(1);
                                  String dateLabel = '';
                                  if (isWeekly) {
                                    final idx = spot.x.toInt();
                                    if (idx >= 0 && idx < dayLabels.length) {
                                      dateLabel = dayLabels[idx];
                                    }
                                  } else {
                                    final idx = spot.x.toInt();
                                    if (idx >= 0 && idx < filteredEntries.length) {
                                      dateLabel = DateFormat('MMM d').format(filteredEntries[idx].key);
                                    }
                                  }
                                  return LineTooltipItem(
                                    '$valStr lbs${dateLabel.isNotEmpty ? ' • $dateLabel' : ''}',
                                    getTextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 1,
                            checkToShowHorizontalLine: (value) =>
                                rightTitleValues.contains(value.toInt()),
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.white.withValues(alpha: 0.08),
                              strokeWidth: 1,
                              dashArray: [4, 4],
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: minX,
                          maxX: maxX,
                          minY: minY,
                          maxY: maxY,
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 44,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  if (rightTitleValues.contains(value.toInt())) {
                                    return Text(
                                      '${value.toInt()} lbs',
                                      style: getTextStyle(
                                        color: Colors.white70,
                                        fontSize: 9.5,
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
                                reservedSize: 26,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (isWeekly) {
                                    if (index >= 0 && index < dayLabels.length) {
                                      return Text(
                                        dayLabels[index],
                                        style: getTextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      );
                                    }
                                  } else {
                                    if (index >= 0 &&
                                        index < filteredEntries.length &&
                                        (index % xStep == 0 || index == filteredEntries.length - 1)) {
                                      final date = filteredEntries[index].key;
                                      final format = (selectedValue == 'Yearly' || selectedValue == 'All Time')
                                          ? 'MMM yy'
                                          : 'MM/dd';
                                      return Text(
                                        DateFormat(format).format(date),
                                        style: getTextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                        ),
                                      );
                                    }
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
                              curveSmoothness: 0.25,
                              gradient: themeController
                                  .activeTheme
                                  .progressBarGradient,
                              barWidth: 4.0,
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
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    themeController.activeTheme.accentGoldColor.withValues(alpha: 0.18),
                                    themeController.activeTheme.accentGoldColor.withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
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
