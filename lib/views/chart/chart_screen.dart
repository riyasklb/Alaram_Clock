// Updated ActivityLineChartScreen with more colorful UI
import 'dart:io';
import 'package:alaram/views/chart/widgets/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/controllers/activity_controller.dart';
import 'package:alaram/views/chart/widgets/daily_activity_widget.dart';
import 'package:alaram/views/chart/widgets/line_chart_widget.dart';

import 'package:pdf/widgets.dart' as pw;
//import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ActivityLineChartScreen extends StatefulWidget {
  @override
  State<ActivityLineChartScreen> createState() =>
      _ActivityLineChartScreenState();
}

class _ActivityLineChartScreenState extends State<ActivityLineChartScreen> {
  final ActivityController _activityController = Get.put(ActivityController());
  String _selectedChartType = 'Line';

  @override
  void initState() {
    super.initState();
    _activityController.setFilter(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              colors: [Colors.orange.shade100, Colors.yellow.shade100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            children: [
              _buildFilterDropdown(),
              _buildChartTypeSelector(),
              _buildChart(),
              _buildActivityData(),
              DailyActivitiesWidget(activityController: _activityController),
            ],
          ),
        );
      }),
    );
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

  Widget _buildChartTypeSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['Line', 'Pie'].map((type) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedChartType == type ? Colors.blue : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => setState(() => _selectedChartType = type),
            child: Text(type, style: TextStyle(color: Colors.white)),
          );
        }).toList(),
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
List<DateTime> dates = dateStrings.map((date) => DateTime.parse(date)).toList();
  List<double> sleepData = [7, 8, 6.5];
  List<double> walkingData = [2, 3, 1.5];
  List<double> waterIntakeData = [2, 2.5, 3];

  return _selectedChartType == 'Line'
      ? ActivityLineChart(
          sleepData: sleepData,
          walkingData: walkingData,
          waterIntakeData: waterIntakeData,
          dates: dates,
        )
      : ActivityPieChart(
          sleepTotal: sleepData.reduce((a, b) => a + b),
          walkingTotal: walkingData.reduce((a, b) => a + b),
          waterIntakeTotal: waterIntakeData.reduce((a, b) => a + b),
        );
}


  Widget _buildActivityData() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildActivityRow('Total Sleep', '22 hrs', Colors.blue,'assets/logo/sleeping.png'),
          _buildActivityRow('Total Walking', '7 hrs', Colors.green,'assets/logo/treadmill.png'),
          _buildActivityRow('Water Intake', '7.5 L', Colors.orange,'assets/logo/drinking-water.png'),
        ],
      ),
    );
  }

  Widget _buildActivityRow(String label, String value, Color color,String imge) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color,backgroundImage:AssetImage(imge),),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
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
