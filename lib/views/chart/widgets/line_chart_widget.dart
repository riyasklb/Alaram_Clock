import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityLineChart extends StatelessWidget {
  final List<double> sleepData;
  final List<double> walkingData;
  final List<double> waterIntakeData;
  final List<DateTime> dates;

  const ActivityLineChart({
    Key? key,
    required this.sleepData,
    required this.walkingData,
    required this.waterIntakeData,
    required this.dates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sleepData.isEmpty || walkingData.isEmpty || waterIntakeData.isEmpty || dates.isEmpty) {
      return Center(child: Text("No activity data available to display the chart."));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(16.w),
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
            Text(
              'Activity Overview',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendIndicator(Colors.blue, 'Sleep (hours)'),
                _buildLegendIndicator(Colors.green, 'Walking (hours)'),
                _buildLegendIndicator(Colors.indigo, 'Water (liters)'),
              ],
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 300.h,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 10,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < dates.length) {
                            return Text(_formatDate(dates[index]), style: TextStyle(fontSize: 10.sp));
                          }
                          return Container();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          if (value >= 0 && value <= 10) {
                            return Text(value.toInt().toString());
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.black)),
                  lineBarsData: [
                    _buildLineChartBarData(_generateSpots(sleepData), Colors.blue),
                    _buildLineChartBarData(_generateSpots(walkingData), Colors.green),
                    _buildLineChartBarData(_generateSpots(waterIntakeData), Colors.indigo),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendIndicator(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }

  List<FlSpot> _generateSpots(List<double> data) {
    return List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index]));
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}";
  }

  LineChartBarData _buildLineChartBarData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      belowBarData: BarAreaData(show: false),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
          radius: 3,
          color: color,
          strokeWidth: 1.5,
          strokeColor: Colors.white,
        ),
      ),
    );
  }
}
