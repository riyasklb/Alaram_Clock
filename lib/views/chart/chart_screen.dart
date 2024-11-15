import 'dart:io';
import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/controllers/activity_controller.dart';
import 'package:alaram/views/chart/widgets/daily_activity_widget.dart';
import 'package:alaram/views/chart/widgets/line_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ActivityLineChartScreen extends StatefulWidget {
  @override
  State<ActivityLineChartScreen> createState() =>
      _ActivityLineChartScreenState();
}

class _ActivityLineChartScreenState extends State<ActivityLineChartScreen> {
  final ActivityController _activityController = Get.put(ActivityController());

  // Filter options
  final List<Map<String, dynamic>> _filterOptions = [
    {'label': 'All Time', 'days': 0},
    {'label': 'Last 7 Days', 'days': 7},
    {'label': 'Last 30 Days', 'days': 30},
    {'label': 'Last 90 Days', 'days': 90},
  ];

  @override
  void initState() {
    super.initState();
    _activityController.setFilter(0); // Default filter to "All Time"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: _sharePdf,
            child: Icon(Icons.print, color: kwhite),
          )
        ],
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
      body: Obx(() {
        return ListView(
          children: [
            _buildFilterDropdown(),
            Column(
              children: [
                _buildLineChart(),
                _buildActivityData(),
                DailyActivitiesWidget(activityController: _activityController),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Obx(() {
        return DropdownButton<Map<String, dynamic>>(
          value: _filterOptions.firstWhere(
              (option) => option['days'] == _activityController.currentFilterDays.value),
          onChanged: (selectedOption) {
            if (selectedOption != null) {
              _activityController.setFilter(selectedOption['days']);
            }
          },
          items: _filterOptions.map((option) {
            return DropdownMenuItem<Map<String, dynamic>>(
              value: option,
              child: Text(option['label']),
            );
          }).toList(),
        );
      }),
    );
  }


  Widget _buildLineChart() {
    if (_activityController.filteredActivityLogs.isEmpty) {
      return Center(
        child: Text("No activity data available to display the chart."),
      );
    }

    List<double> sleepData = _activityController.filteredActivityLogs
        .map((log) => log.sleepHours)
        .toList();
    List<double> walkingData = _activityController.filteredActivityLogs
        .map((log) => log.walkingHours)
        .toList();
    List<double> waterIntakeData = _activityController.filteredActivityLogs
        .map((log) => log.waterIntake)
        .toList();

    return ActivityLineChart(
      sleepData: sleepData,
      walkingData: walkingData,
      waterIntakeData: waterIntakeData,
    );
  }

  Widget _buildActivityData() {
    if (_activityController.filteredActivityLogs.isEmpty) {
      return Center(
        child: Text("No activity recorded for the selected period."),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildActivityRow(
            icon: Icons.nightlight_round,
            color: Colors.blue,
            label: 'Total Sleep',
            value: '${_activityController.totalSleep.toStringAsFixed(1)} hrs',
          ),
          _buildActivityRow(
            icon: Icons.directions_walk,
            color: Colors.green,
            label: 'Total Walking',
            value: '${_activityController.totalWalking.toStringAsFixed(1)} hrs',
          ),
          _buildActivityRow(
            icon: Icons.local_drink,
            color: Colors.teal,
            label: 'Total Water Intake',
            value: '${_activityController.totalWaterIntake.toStringAsFixed(1)} L',
          ),
        ],
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
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sharePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Activity Report', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 16),
              pw.Text('Total Sleep: ${_activityController.totalSleep.toStringAsFixed(1)} hrs'),
              pw.Text('Total Walking: ${_activityController.totalWalking.toStringAsFixed(1)} hrs'),
              pw.Text('Total Water Intake: ${_activityController.totalWaterIntake.toStringAsFixed(1)} L'),
              pw.SizedBox(height: 16),
              pw.Text('Detailed Activity Logs:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.ListView.builder(
                itemCount: _activityController.filteredActivityLogs.length,
                itemBuilder: (context, index) {
                  final log = _activityController.filteredActivityLogs[index];
                
                // Format the date properly (e.g., MM/dd/yyyy)
                String formattedDate = "${log.date.month}/${log.date.day}/${log.date.year}";

                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Text(
                    'Date: $formattedDate | Sleep: ${log.sleepHours} hrs | Walking: ${log.walkingHours} hrs | Water Intake: ${log.waterIntake} L',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                );
              },
            ),
            pw.SizedBox(height: 16),
            pw.Text('Daily Medicine', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.ListView.builder(
              itemCount: _activityController.dailyActivities.length,
              itemBuilder: (context, index) {
                final activity = _activityController.dailyActivities[index];

                // Format medicines list and meal values for display
                String medicinesStr = activity.medicines != null
                    ? activity.medicines!.map((medicine) => "${medicine.name} (${medicine.selectedTimes.join(', ')})").join('; ')
                    : 'No medicines';

                String mealValueStr = activity.mealValue != null
                    ? 'Morning: ${activity.mealValue!.morning ? "Taken" : "Not Taken"}, '
                      'Afternoon: ${activity.mealValue!.afternoon ? "Taken" : "Not Taken"}, '
                      'Night: ${activity.mealValue!.night ? "Taken" : "Not Taken"}'
                    : 'No meal value';

                // Format the date for each daily activity
                String activityDate = "${activity.date.month}/${activity.date.day}/${activity.date.year}";

                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Text(
                    'Date: $activityDate | Activity: ${activity.activityName} | Medicines: $medicinesStr | Meal Value: $mealValueStr | Frequency: ${activity.frequency}',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/activity_report.pdf");
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: 'Here is my activity report');
  }
}
