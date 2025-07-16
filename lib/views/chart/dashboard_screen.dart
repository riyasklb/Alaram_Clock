import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/cutomwidget/cutom_home_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alaram/tools/controllers/activity_controller.dart';
import 'package:alaram/views/chart/widgets/daily_activity_widget.dart';
import 'package:alaram/views/chart/widgets/line_chart_widget.dart';

import 'package:alaram/views/chart/activity_metric_detail_screen.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  State<DashBoardScreen> createState() =>
      _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
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
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.print, color: Colors.white),
          //     onPressed: _sharePdf,
          //   )
          // ],
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
    final filterOptions = {
      'All Time': 0,
      'Last 7 Days': 7,
      'Last 30 Days': 30,
      'Last 90 Days': 90,
    };
    String currentLabel = filterOptions.entries.firstWhere((e) => e.value == _activityController.currentFilterDays.value, orElse: () => filterOptions.entries.first).key;
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        value: currentLabel,
        onChanged: (value) {
          if (value != null) {
            _activityController.setFilter(filterOptions[value]!);
          }
        },
        items: filterOptions.keys
            .map((label) => DropdownMenuItem(value: label, child: Text(label)))
            .toList(),
      ),
    );
  }



  Widget _buildActivityData() {
    final totalSleep = _activityController.totalSleep;
    final totalWalking = _activityController.totalWalking;
    final totalWaterIntake = _activityController.totalWaterIntake;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => ActivityMetricDetailScreen(
                metric: 'sleep',
                label: 'Sleep',
                color: Colors.blue,
              ));
            },
            child: _buildActivityRow(
                'Total Sleep', '${totalSleep.toStringAsFixed(1)} hrs', Colors.blue, 'assets/logo/sleeping.png'),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              Get.to(() => ActivityMetricDetailScreen(
                metric: 'walking',
                label: 'Walking',
                color: Colors.green,
              ));
            },
            child: _buildActivityRow('Total Walking', '${totalWalking.toStringAsFixed(1)} hrs', Colors.green,
                'assets/logo/treadmill.png'),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              Get.to(() => ActivityMetricDetailScreen(
                metric: 'water',
                label: 'Water Intake',
                color: Colors.orange,
              ));
            },
            child: _buildActivityRow('Water Intake', '${totalWaterIntake.toStringAsFixed(1)} L', Colors.orange,
                'assets/logo/drinking-water.png'),
          ),
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


}
