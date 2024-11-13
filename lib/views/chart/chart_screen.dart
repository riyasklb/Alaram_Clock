import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/model/daily_activity_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:alaram/tools/model/activity_log.dart';
import 'package:intl/intl.dart';

class ActivityLineChartScreen extends StatefulWidget {
  @override
  _ActivityLineChartScreenState createState() =>
      _ActivityLineChartScreenState();
}

class _ActivityLineChartScreenState extends State<ActivityLineChartScreen> {
  List<ActivityLog> _activityLogs = [];
  List<DailyActivityModel> _dailyActivities = []; // Add DailyActivityModel list

  @override
  void initState() {
    super.initState();
    _loadActivityLogs();
  }

  Future<void> _loadActivityLogs() async {
    var activityBox = await Hive.openBox<ActivityLog>('activityLogs');
    var dailyActivityBox =
        await Hive.openBox<DailyActivityModel>('dailyActivities');

    setState(() {
      _activityLogs = activityBox.values.toList();
      _dailyActivities = dailyActivityBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Activity Line Chart',
          style: GoogleFonts.lato(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: kblue,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              _buildLineChart(),
              _buildActivityData(),
              _buildDailyActivities(), // Display the DailyActivityModel data
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    if (_activityLogs.isEmpty) {
      return Center(
        child: Text("No activity data available to display the chart."),
      );
    }

    List<FlSpot> sleepSpots = [];
    List<FlSpot> walkingSpots = [];
    List<FlSpot> waterIntakeSpots = [];

    for (int i = 0; i < _activityLogs.length; i++) {
      sleepSpots.add(FlSpot(i.toDouble(), _activityLogs[i].sleepHours));
      walkingSpots.add(FlSpot(i.toDouble(), _activityLogs[i].walkingHours));
      waterIntakeSpots.add(FlSpot(i.toDouble(), _activityLogs[i].waterIntake));
    }

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
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
                show: true, border: Border.all(color: Colors.black)),
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

  Widget _buildActivityData() {
    double totalSleep = 0;
    double totalWalking = 0;
    double totalWaterIntake = 0;

    for (var log in _activityLogs) {
      totalSleep += log.sleepHours;
      totalWalking += log.walkingHours;
      totalWaterIntake += log.waterIntake;
    }

    if (_activityLogs.isEmpty) {
      return Center(child: Text("No activity recorded for the previous days."));
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildActivityRow(
            icon: Icons.nightlight_round,
            color: Colors.blue,
            label: 'Total Sleep',
            value: '${totalSleep.toStringAsFixed(1)} hrs',
          ),
          _buildActivityRow(
            icon: Icons.directions_walk,
            color: Colors.green,
            label: 'Total Walking',
            value: '${totalWalking.toStringAsFixed(1)} hrs',
          ),
          _buildActivityRow(
            icon: Icons.local_drink,
            color: Colors.teal,
            label: 'Total Water Intake',
            value: '${totalWaterIntake.toStringAsFixed(1)} L',
          ),
        ],
      ),
    );
  }

  Widget _buildDailyActivities() {
    if (_dailyActivities.isEmpty) {
      return Center(child: Text("No daily activities recorded."));
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: _dailyActivities.map((activity) {
          DateTime date = DateTime.parse(activity.date.toString());
          String formattedDate = DateFormat('MMMM d, yyyy').format(date);

          // Find the matching ActivityLog entry by date
          ActivityLog? matchingLog = _activityLogs.firstWhere(
            (log) =>
                log.date.year == date.year &&
                log.date.month == date.month &&
                log.date.day == date.day,
            orElse: () => ActivityLog(
                date: date, sleepHours: 0, walkingHours: 0, waterIntake: 0),
          );

          return Card(
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'Task Date: $formattedDate',
                      style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Frequency
                  Text(
                    "Frequency: ${activity.frequency}",
                    style: GoogleFonts.roboto(fontSize: 14.sp),
                  ),

                  // Display sleep, walking, and water intake from matching ActivityLog
                  SizedBox(height: 8.h),
                  _buildActivityRow(
                    icon: Icons.nightlight_round,
                    color: Colors.blue,
                    label: 'Sleep',
                    value: '${matchingLog.sleepHours.toStringAsFixed(1)} hrs',
                  ),
                  _buildActivityRow(
                    icon: Icons.directions_walk,
                    color: Colors.green,
                    label: 'Walking',
                    value: '${matchingLog.walkingHours.toStringAsFixed(1)} hrs',
                  ),
                  _buildActivityRow(
                    icon: Icons.local_drink,
                    color: Colors.teal,
                    label: 'Water Intake',
                    value: '${matchingLog.waterIntake.toStringAsFixed(1)} L',
                  ),

                  // Medicines Section
                  if (activity.medicines != null &&
                      activity.medicines!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        Text("Medicines:",
                            style: GoogleFonts.roboto(
                                fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        ...activity.medicines!.map((medicine) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "  • ${medicine.name}",
                                    style: GoogleFonts.roboto(fontSize: 14.sp),
                                  ),
                                  Text(
                                    "    - Frequency: ${medicine.frequency}",
                                    style: GoogleFonts.roboto(fontSize: 14.sp),
                                  ),
                                  Text(
                                    "    - Times: ${medicine.selectedTimes.join(", ")}",
                                    style: GoogleFonts.roboto(fontSize: 14.sp),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "  Completion Status: ${medicine.taskCompletionStatus.values.every((status) => status) ? "Taken Properly" : "Not Taken"}",
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: medicine
                                                  .taskCompletionStatus.values
                                                  .every((status) => status)
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                      Icon(
                                        medicine.taskCompletionStatus.values
                                                .every((status) => status)
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: medicine
                                                .taskCompletionStatus.values
                                                .every((status) => status)
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ],
                                  ),

                                  if (medicine.taskCompletionStatus.values
                                      .any((status) => !status))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Skipped Times:",
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          ...medicine
                                              .taskCompletionStatus.entries
                                              .where((entry) => !entry
                                                  .value) // Filter for skipped times
                                              .map((entry) => Text(
                                                    "• ${entry.key}", // Display each skipped time
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      color: Colors.red[700],
                                                    ),
                                                  ))
                                              .toList(),
                                        ],
                                      ),
                                    ),

                                  // Meal Section
                                  if (activity.mealValue != null)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8.h),
                                        Text("Meal Times:",
                                            style: GoogleFonts.roboto(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          children: [
                                            Icon(
                                              activity.mealValue!.morning
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: activity.mealValue!.morning
                                                  ? Colors.green
                                                  : Colors.red,
                                              size: 16.sp,
                                            ),
                                            SizedBox(width: 8.w),
                                            Text("Morning",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 14.sp)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              activity.mealValue!.afternoon
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color:
                                                  activity.mealValue!.afternoon
                                                      ? Colors.green
                                                      : Colors.red,
                                              size: 16.sp,
                                            ),
                                            SizedBox(width: 8.w),
                                            Text("Afternoon",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 14.sp)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              activity.mealValue!.night
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: activity.mealValue!.night
                                                  ? Colors.green
                                                  : Colors.red,
                                              size: 16.sp,
                                            ),
                                            SizedBox(width: 8.w),
                                            Text("Night",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 14.sp)),
                                          ],
                                        ),
                                        kheight10,
                                        Row(
                                          children: [
                                            Icon(
                                              activity.mealValue!.morning &&
                                                      activity.mealValue!
                                                          .afternoon &&
                                                      activity.mealValue!.night
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: activity
                                                          .mealValue!.morning &&
                                                      activity.mealValue!
                                                          .afternoon &&
                                                      activity.mealValue!.night
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                            SizedBox(width: 8),
                                            kheight10,
                                            Text(
                                              "Food taken properly",
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: activity.mealValue!
                                                            .morning &&
                                                        activity.mealValue!
                                                            .afternoon &&
                                                        activity
                                                            .mealValue!.night
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            )),
                      ],
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActivityRow({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: 8.w),
              Text(
                label,
                style: GoogleFonts.roboto(fontSize: 14.sp),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
                fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
