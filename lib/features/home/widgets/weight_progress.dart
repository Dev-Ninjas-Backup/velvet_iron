import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/app_theme/model/app_theme_model.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';

class WeightProgress extends StatefulWidget {
  final String title;
  const WeightProgress({super.key, required this.title});

  @override
  State<WeightProgress> createState() => _WeightProgressState();
}

class _WeightProgressState extends State<WeightProgress> {
  String _selectedValue = "All Activity";
  List<double>? _randomData;

  static const List<String> xpLabels = [
    '100xp',
    '80xp',
    '60xp',
    '40xp',
    '20xp',
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<AppThemeController>();
    final activeTheme =
        themeController.currentTheme.value ?? AppThemeModel.adventurerTheme;
    final controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Container(
              height: 26,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                border: Border.all(color: activeTheme.borderColor),
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
                  dropdownColor: activeTheme.dropdownBackgroundColor,
                  items:
                      ['this week', 'last week', 'this month', 'All Activity']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedValue = val!;
                      _randomData = List.generate(
                        7,
                        (index) => Random().nextDouble() * 100,
                      );
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = _randomData ?? controller.activity.value?.weeklyData;
            if (data == null) {
              return const Center(child: Text("No data"));
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: BarChart(
                    BarChartData(
                      minY: 0,
                      maxY: 100,
                      alignment: BarChartAlignment.spaceBetween,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              const days = [
                                'Sun',
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                              ];

                              if (value.toInt() > 6) {
                                return const SizedBox.shrink();
                              }

                              return FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  days[value.toInt()],
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
                      barGroups: data.asMap().entries.map((e) {
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
                  width: 30,
                  height: 114,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: xpLabels.map((xp) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: activeTheme.borderColor),
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
            );
          }),
        ),
      ],
    );
  }
}
