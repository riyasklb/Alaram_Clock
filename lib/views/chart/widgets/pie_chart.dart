import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityPieChart extends StatelessWidget {
  final double sleepTotal;
  final double walkingTotal;
  final double waterIntakeTotal;

  const ActivityPieChart({
    Key? key,
    required this.sleepTotal,
    required this.walkingTotal,
    required this.waterIntakeTotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sleepTotal == 0 && walkingTotal == 0 && waterIntakeTotal == 0) {
      return Center(
        child: Text("No activity data available to display the chart."),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        height: 300.h,
        child: PieChart(
          PieChartData(
            sections: [
              _buildPieChartSection(
                value: sleepTotal,
                color: Colors.blue,
                title: 'Sleep',
              ),
              _buildPieChartSection(
                value: walkingTotal,
                color: Colors.green,
                title: 'Walking',
              ),
              _buildPieChartSection(
                value: waterIntakeTotal,
                color: Colors.indigo,
                title: 'Water Intake',
              ),
            ],
            borderData: FlBorderData(show: false),
            sectionsSpace: 0, // Remove space between sections
            centerSpaceRadius: 30, // Optional: space in the center
          ),
        ),
      ),
    );
  }

  /// Builds each section for the pie chart
  PieChartSectionData _buildPieChartSection({
    required double value,
    required Color color,
    required String title,
  }) {
    return PieChartSectionData(
      value: value,
      color: color,
      title: '$title\n${value.toStringAsFixed(1)}', // Display the value and title
      titleStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      radius: 100, // Size of the pie chart
      showTitle: true,
    );
  }
}
