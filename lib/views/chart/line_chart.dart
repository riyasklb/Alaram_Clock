
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class LineChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 1),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 20),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 5),
              FlSpot(1, 25),
              FlSpot(2, 100),
              FlSpot(3, 75),
              FlSpot(4, 50),
              FlSpot(5, 30),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}