import 'package:alaram/tools/constans/color.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart package
import 'package:alaram/tools/model/activity_log.dart';

class ActivityPieChartScreen extends StatefulWidget {
  @override
  _ActivityPieChartScreenState createState() => _ActivityPieChartScreenState();
}

class _ActivityPieChartScreenState extends State<ActivityPieChartScreen> {
  List<ActivityLog> _activityLogs = [];

  @override
  void initState() {
    super.initState();
    _loadActivityLogs();
  }

  Future<void> _loadActivityLogs() async {
    var box = await Hive.openBox<ActivityLog>(sleepactivitys);
    setState(() {
      _activityLogs = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Activity Pie Chart',
          style: GoogleFonts.lato(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: kblue,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildPieChart(),
          _buildActivityData(),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    // Calculate total activity data for all previous days combined
    double totalSleep = 0;
    double totalWalking = 0;
    double totalWaterIntake = 0;

    for (var log in _activityLogs) {
      totalSleep += log.sleepHours;
      totalWalking += log.walkingHours;
      totalWaterIntake += log.waterIntake;
    }

    final total = totalSleep + totalWalking + totalWaterIntake;

    // Avoid division by zero
    if (total == 0) {
      return Center(child: Text("No activity recorded for the previous days."));
    }

    final sleepPercentage = (totalSleep / total) * 100;
    final walkingPercentage = (totalWalking / total) * 100;
    final waterPercentage = (totalWaterIntake / total) * 100;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        height: 250.h, // Specify a fixed height
        child: PieChart(
          PieChartData(
            sectionsSpace: 0, // Space between sections
            centerSpaceRadius: 40, // Radius of the center space
            sections: [
              if (sleepPercentage > 0) PieChartSectionData(
                value: sleepPercentage,
                color: Colors.blue,
                title: '${sleepPercentage.toStringAsFixed(1)}%',
                radius: 60,
                titleStyle: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (walkingPercentage > 0) PieChartSectionData(
                value: walkingPercentage,
                color: Colors.green,
                title: '${walkingPercentage.toStringAsFixed(1)}%',
                radius: 60,
                titleStyle: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (waterPercentage > 0) PieChartSectionData(
                value: waterPercentage,
                color: Colors.teal,
                title: '${waterPercentage.toStringAsFixed(1)}%',
                radius: 60,
                titleStyle: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityData() {
    // Calculate total activity data for all previous days combined
    double totalSleep = 0;
    double totalWalking = 0;
    double totalWaterIntake = 0;

    for (var log in _activityLogs) {
      totalSleep += log.sleepHours;
      totalWalking += log.walkingHours;
      totalWaterIntake += log.waterIntake;
    }

    final total = totalSleep + totalWalking + totalWaterIntake;

    // Avoid division by zero
    if (total == 0) {
      return Center(child: Text("No activity recorded for the previous days."));
    }

    final sleepPercentage = (totalSleep / total) * 100;
    final walkingPercentage = (totalWalking / total) * 100;
    final waterPercentage = (totalWaterIntake / total) * 100;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildActivityRow(
            icon: Icons.nightlight_round,
            color: Colors.blue,
            label: 'Sleep',
            value: '${sleepPercentage.toStringAsFixed(1)}%',
          ),
          _buildActivityRow(
            icon: Icons.directions_walk,
            color: Colors.green,
            label: 'Walking',
            value: '${walkingPercentage.toStringAsFixed(1)}%',
          ),
          _buildActivityRow(
            icon: Icons.local_drink,
            color: Colors.teal,
            label: 'Water Intake',
            value: '${waterPercentage.toStringAsFixed(1)}%',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow({required IconData icon, required Color color, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 30.sp),
        SizedBox(width: 12.w),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            color: color,
          ),
        ),
      ],
    );
  }
}
