import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/weight_log_screen/widgets/drop_down.dart';

class WeightProgress extends StatelessWidget {
  const WeightProgress({super.key});

  static const List<String> xpLabels = [
    '100xp',
    '80xp',
    '60xp',
    '40xp',
    '20xp',
  ];

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    final List<double> weeklyData = List.generate(
      7,
      (index) => 20 + random.nextDouble() * 80,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropDown(text: 'Weekly Activity'),
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
                            gradient: const LinearGradient(
                              colors: [Color(0xFF683E23), Color(0xFFE9B86E)],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
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
                        border: Border.all(
                          color: AppColors.textFieldBorderColor,
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
  }
}
