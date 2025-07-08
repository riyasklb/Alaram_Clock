// Updated ActivityLineChartScreen with more colorful UI
import 'dart:io';

import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/cutomwidget/cutom_home_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alaram/tools/controllers/activity_controller.dart';
import 'package:alaram/views/chart/widgets/daily_activity_widget.dart';
import 'package:alaram/views/chart/widgets/line_chart_widget.dart';

import 'package:pdf/widgets.dart' as pw;

import 'package:path_provider/path_provider.dart';

class ActivityLineChartScreen extends StatefulWidget {
  @override
  State<ActivityLineChartScreen> createState() =>
      _ActivityLineChartScreenState();
}

class _ActivityLineChartScreenState extends State<ActivityLineChartScreen> {
  final ActivityController _activityController = Get.put(ActivityController());

  @override
  void initState() {
    super.initState();
    _activityController.setFilter(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kwhite,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.print, color: Colors.white),
              onPressed: _sharePdf,
            )
          ],
          title: Text(
            'Activity Chart',
            style: GoogleFonts.lato(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Obx(() {
          return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.lightBlue.shade100,
                    Colors.blue.shade100,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView(
                children: [
                  _buildFilterDropdown(),
                  _buildChart(),
                  _buildActivityData(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15.h,),
                      ),
                      icon: Icon(Icons.list, color: Colors.white),
                      label: Text(
                        'Show All Logs',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                      onPressed: () {
                        Get.to(() => DailyActivitiesWidget());
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: CustomHomeButton(),
                  )
                ],
              ));
        }));
  }

  Widget _buildFilterDropdown() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        value: 'All Time',
        onChanged: (value) {},
        items: ['All Time', 'Last 7 Days', 'Last 30 Days', 'Last 90 Days']
            .map((label) => DropdownMenuItem(value: label, child: Text(label)))
            .toList(),
      ),
    );
  }

  Widget _buildChart() {
    if (_activityController.filteredActivityLogs.isEmpty) {
      return Center(
        child: Text(
          'No activity data available.',
          style: GoogleFonts.poppins(fontSize: 16.sp),
        ),
      );
    }

    List<String> dateStrings = ['2024-02-10', '2024-02-11', '2024-02-12'];
    List<DateTime> dates =
        dateStrings.map((date) => DateTime.parse(date)).toList();
    List<double> sleepData = [7, 8, 6.5];
    List<double> walkingData = [2, 3, 1.5];
    List<double> waterIntakeData = [2, 2.5, 3];

    return ActivityLineChart(
      sleepData: sleepData,
      walkingData: walkingData,
      waterIntakeData: waterIntakeData,
      dates: dates,
    );
  }

  Widget _buildActivityData() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          _buildActivityRow(
              'Total Sleep', '22 hrs', Colors.blue, 'assets/logo/sleeping.png'),
          SizedBox(height: 12.h),
          _buildActivityRow('Total Walking', '7 hrs', Colors.green,
              'assets/logo/treadmill.png'),
          SizedBox(height: 12.h),
          _buildActivityRow('Water Intake', '7.5 L', Colors.orange,
              'assets/logo/drinking-water.png'),
        ],
      ),
    );
  }

  Widget _buildActivityRow(
      String label, String value, Color color, String imagePath) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 70.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.15),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sharePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Activity Report', style: pw.TextStyle(fontSize: 24)),
              pw.Divider(),
              pw.Text('Total Sleep: 22 hrs'),
              pw.Text('Total Walking: 7 hrs'),
              pw.Text('Water Intake: 7.5 L'),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/ActivityReport.pdf");
    await file.writeAsBytes(await pdf.save());

    //  await Share.shareXFiles([XFile(file.path)], text: "Activity Report PDF");
  }
}
