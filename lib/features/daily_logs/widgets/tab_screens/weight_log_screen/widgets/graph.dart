import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/weight_log_screen/controller/weight_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/weight_log_screen/model/weight_log_model.dart';

class Graph extends StatefulWidget {
  const Graph({super.key});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  String _selectedValue = "this week";

  /// Build spots from weekly entries, mapping each entry's date to its
  /// day-of-week index (0=Sun … 6=Sat). Days without data are skipped
  /// so the line only connects logged days.
  List<FlSpot> _buildSpots(List<WeeklyWeightEntry> entries) {
    List<FlSpot> spots = [];
    for (final entry in entries) {
      try {
        final date = DateTime.parse(entry.date);
        final dayIndex = date.weekday % 7; // DateTime: Mon=1…Sun=7 → Sun=0
        final weight = double.tryParse(entry.weight);
        if (weight != null) {
          spots.add(FlSpot(dayIndex.toDouble(), weight));
        }
      } catch (_) {}
    }
    spots.sort((a, b) => a.x.compareTo(b.x));
    // Fill missing days with 0.1 so all 7 days have a point
    final existing = {for (final s in spots) s.x.toInt()};
    for (int i = 0; i < 7; i++) {
      if (!existing.contains(i)) {
        spots.add(FlSpot(i.toDouble(), 0.01));
      }
    }
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
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
          final entries = _selectedValue == "this week"
              ? (chartData?.thisWeek ?? [])
              : (chartData?.lastWeek ?? []);
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
                        value: _selectedValue,
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
                          setState(() {
                            _selectedValue = val!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 150,
                child: spots.isEmpty
                    ? Center(
                        child: Text(
                          'No data for ${_selectedValue}',
                          style: getTextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
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
                              dotData: const FlDotData(show: false),
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
