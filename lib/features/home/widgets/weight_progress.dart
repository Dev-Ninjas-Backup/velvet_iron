import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/features/home/controller/theme_controller.dart';
import 'package:velvet_iron/features/home/models/home_theme_model.dart';

class WeightProgress extends StatefulWidget {
  final String title;
  const WeightProgress({super.key, required this.title});

  @override
  State<WeightProgress> createState() => _WeightProgressState();
}

class _WeightProgressState extends State<WeightProgress> {
  String _selectedValue = "this week";

  static const List<String> xpLabels = [
    '100xp',
    '80xp',
    '60xp',
    '40xp',
    '20xp',
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final activeTheme =
        themeController.currentTheme.value ?? HomeThemeModel.adventurerTheme;

    final Random random = Random();
    final List<double> weeklyData = List.generate(
      7,
      (index) => 20 + random.nextDouble() * 80,
    );

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
                  items: ['this week', 'last week', 'this month']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
          height: 150,
          child: Row(
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
                    barGroups: weeklyData.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value,
                            width: 29,
                            borderRadius: BorderRadius.circular(6),
                            gradient: activeTheme.progressBarGradient,
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
          ),
        ),
      ],
    );
  }
}
