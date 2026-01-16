import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class Graph extends StatelessWidget {
  const Graph({super.key});

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    final List<FlSpot> spots = List.generate(7, (index) {
      return FlSpot(index.toDouble(), 100 + random.nextDouble() * 100);
    });

    final List<String> dayLabels = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];
    final List<int> rightTitleValues = [100, 130, 160, 200];

    return SizedBox(
      width: double.infinity, // Use full available width
      height: 150,
      child: LineChart(
        LineChartData(
          lineTouchData: const LineTouchData(enabled: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 90, // Adjusted to give space below 100
          maxY: 210, // Adjusted to give space above 200
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 10, // Check every 10
                getTitlesWidget: (value, meta) {
                  if (rightTitleValues.contains(value.toInt())) {
                    return Text(
                      value.toInt().toString(),
                      style: getTextStyle(color: Colors.white, fontSize: 10),
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
                      style: getTextStyle(color: Colors.white, fontSize: 10),
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
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF9E6D38),
                  Color(0xFFE5B46B),
                  Color(0xFFE9B86E),
                  Color(0xFFFDE7BB),
                ],
              ),
              barWidth: 4.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
