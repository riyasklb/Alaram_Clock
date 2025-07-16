import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:alaram/tools/model/profile_model.dart';


class SingleMetricLineChart extends StatelessWidget {
  final List<double> data;
  final List<DateTime> dates;
  final Color color;
  final String label;

  const SingleMetricLineChart({
    Key? key,
    required this.data,
    required this.dates,
    required this.color,
    required this.label,
  }) : super(key: key);

  IconData get _icon {
    switch (label.toLowerCase()) {
      case 'sleep':
        return Icons.nightlight_round;
      case 'walking':
        return Icons.directions_walk;
      case 'water intake':
      case 'water':
        return Icons.local_drink;
      default:
        return Icons.show_chart;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty || dates.isEmpty) {
      return Center(child: Text("No $label data available to display the chart."));
    }
    final min = data.reduce((a, b) => a < b ? a : b);
    final max = data.reduce((a, b) => a > b ? a : b);
    final avg = data.reduce((a, b) => a + b) / data.length;

    // Get user goal from ProfileModel
    final profileBox = Hive.box<ProfileModel>('profileBox');
    final profile = profileBox.get('userProfile');
    double? goal;
    String goalLabel = '';
    Color goalColor = Colors.redAccent;
    if (label.toLowerCase().contains('sleep')) {
      goal = profile?.sleepGoal;
      goalLabel = 'Goal: ${goal?.toStringAsFixed(1) ?? 'Not set'} hrs';
      goalColor = Colors.deepPurpleAccent;
    } else if (label.toLowerCase().contains('walking')) {
      goal = profile?.walkingGoal;
      goalLabel = 'Goal: ${goal?.toStringAsFixed(1) ?? 'Not set'} hrs';
      goalColor = Colors.green;
    } else if (label.toLowerCase().contains('water')) {
      goal = profile?.waterIntakeGoal;
      goalLabel = 'Goal: ${goal?.toStringAsFixed(1) ?? 'Not set'} L';
      goalColor = Colors.blueAccent;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
              child: Row(
                children: [
                  Icon(_icon, color: Colors.white, size: 32.sp),
                  SizedBox(width: 12.w),
                  Text(
                    '$label Overview',
                    style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            // Stats
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statBox('Min', min, color),
                  _statBox('Max', max, color),
                  _statBox('Avg', avg, color),
                ],
              ),
            ),
            if (goal != null && goal > 0)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                child: Row(
                  children: [
                    Icon(Icons.flag, color: goalColor, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(goalLabel, style: TextStyle(color: goalColor, fontWeight: FontWeight.w600, fontSize: 15.sp)),
                  ],
                ),
              ),
            if (goal == null || goal <= 0)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                child: Text('No goal set for this metric.', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
              ),
            SizedBox(height: 10.h),
            // Chart
            SizedBox(
              height: 320.h,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: (data.isNotEmpty) ? (max + 2).clamp(5, 24) : 10,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        axisNameWidget: Padding(
                          padding: EdgeInsets.only(top: 18.h),
                          child: Text('Date', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                        ),
                        axisNameSize: 32,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < dates.length) {
                              return Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Text(_formatDate(dates[index]), style: TextStyle(fontSize: 11.sp)),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Text(_yAxisLabel(), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                        ),
                        axisNameSize: 32,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: ((max / 5).ceil()).toDouble().clamp(1, 5),
                          getTitlesWidget: (value, meta) {
                            if (value >= 0 && value <= 24) {
                              return Text(value.toInt().toString(), style: TextStyle(fontSize: 11.sp));
                            }
                            return Container();
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: Colors.black),
                        bottom: BorderSide(color: Colors.black),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      horizontalInterval: ((max / 5).ceil()).toDouble().clamp(1, 5),
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.3),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index])),
                        isCurved: true,
                        color: color,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [color.withOpacity(0.3), color.withOpacity(0.05)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                            radius: 4,
                            color: color,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                        ),
                      ),
                      if (goal != null && goal > 0)
                        LineChartBarData(
                          spots: [
                            FlSpot(0, goal),
                            FlSpot((data.length - 1).toDouble(), goal),
                          ],
                          isCurved: false,
                          color: goalColor,
                          barWidth: 2,
                          dashArray: [8, 6],
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (spots) => spots.map((spot) {
                          int idx = spot.x.toInt();
                          return LineTooltipItem(
                            '${_formatDate(dates[idx])}\n${data[idx].toStringAsFixed(2)}',
                            TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String title, double value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 13.sp, color: color, fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          Text(value.toStringAsFixed(2), style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}";
  }

  String _yAxisLabel() {
    if (label.toLowerCase().contains('sleep') || label.toLowerCase().contains('walking')) {
      return 'Hours';
    } else if (label.toLowerCase().contains('water')) {
      return 'Liters';
    }
    return 'Value';
  }
}
