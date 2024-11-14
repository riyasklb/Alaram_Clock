import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityLineChart extends StatelessWidget {
  final List<double> sleepData;
  final List<double> walkingData;
  final List<double> waterIntakeData;

  const ActivityLineChart({
    Key? key,
    required this.sleepData,
    required this.walkingData,
    required this.waterIntakeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If there’s no data, display a message instead of the chart
    if (sleepData.isEmpty || walkingData.isEmpty || waterIntakeData.isEmpty) {
      return Center(
        child: Text("No activity data available to display the chart."),
      );
    }

    List<FlSpot> sleepSpots = _generateSpots(sleepData);
    List<FlSpot> walkingSpots = _generateSpots(walkingData);
    List<FlSpot> waterIntakeSpots = _generateSpots(waterIntakeData);

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        height: 300.h,
        child: LineChart(
          LineChartData(
            minY: 1,
            maxY: 15,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  interval: 1,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (value >= 1 && value <= 15) {
                      return Text(value.toInt().toString());
                    }
                    return Container();
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.black),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: sleepSpots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(show: false),
              ),
              LineChartBarData(
                spots: walkingSpots,
                isCurved: true,
                color: Colors.green,
                barWidth: 3,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(show: false),
              ),
              LineChartBarData(
                spots: waterIntakeSpots,
                isCurved: true,
                color: Colors.teal,
                barWidth: 3,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(show: false),
              ),
            ],
            gridData: FlGridData(show: false),
          ),
        ),
      ),
    );
  }

  // Helper method to convert data into spots
  List<FlSpot> _generateSpots(List<double> data) {
    return List<FlSpot>.generate(
      data.length,
      (index) => FlSpot(index.toDouble(), data[index]),
    );
  }
}
