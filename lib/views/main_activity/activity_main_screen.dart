import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/model/activity_log.dart';
import 'package:alaram/tools/model/profile_model.dart';
import 'package:alaram/views/chart/dashboard_screen.dart';
import 'package:alaram/views/completed_tasks/activity_sleep_log_screen.dart';
import 'package:alaram/views/completed_tasks/daily_activity_medicine_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class ActivityMainPage extends StatefulWidget {
  @override
  _ActivityMainPageState createState() => _ActivityMainPageState();
}

class _ActivityMainPageState extends State<ActivityMainPage> {
  late Box<ActivityLog> _activityLogBox;

  @override
  void initState() {
    super.initState();
    _activityLogBox = Hive.box<ActivityLog>(sleepactivitys);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(onTap: () {}, child: _buildProfileCard()), // Profile card
              SizedBox(height: 20.h),
              _buildActivityCategoryList(
                  'Walking',
                  'Walking Hours',
                  (log) => log.walkingHours,
                  Icons.directions_walk,
                  Colors.blue),
              SizedBox(height: 20.h),
              _buildActivityCategoryList('Sleeping', 'Sleep Hours',
                  (log) => log.sleepHours, Icons.bed, Colors.orange),
              SizedBox(height: 20.h),
              _buildActivityCategoryList('Water Intake', 'Water Intake',
                  (log) => log.waterIntake, Icons.local_drink, Colors.green),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCategoryList(
      String category,
      String label,
      double Function(ActivityLog) valueExtractor,
      IconData icon,
      Color categoryColor) {
    return ValueListenableBuilder(
      valueListenable: _activityLogBox.listenable(),
      builder: (context, Box<ActivityLog> box, _) {
        List<ActivityLog> activityLogs = box.values.toList();

        // Sort logs by date and get the latest
        activityLogs.sort((a, b) => b.date
            .compareTo(a.date)); // assuming `date` is a field in ActivityLog

        if (activityLogs.isEmpty) {
          return SizedBox.shrink();
        }

        ActivityLog latestLog = activityLogs.first;
        double value = valueExtractor(latestLog);
        String formattedDate =
            DateFormat('yyyy-MM-dd HH:mm').format(latestLog.date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
            _buildActivityCard(
                label, value, icon, categoryColor, formattedDate),
          ],
        );
      },
    );
  }

  Widget _buildActivityCard(String label, double value, IconData icon,
      Color categoryColor, String date) {
    return GestureDetector(
      onTap: () {
      //  Get.to(ActivityPieChartScreen());
        // Handle activity card tap
      },
      child: AnimatedContainer(
        width: double.infinity,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: categoryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40.r,
                color: categoryColor,
              ),
              SizedBox(height: 10.h),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                '$value hours',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Last updated: $date',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: CircularProgressIndicator(
                  value: value / 24, // Assuming max value is 24 hours
                  valueColor: AlwaysStoppedAnimation(categoryColor),
                  backgroundColor: categoryColor.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildCustomAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),
          ),
        ),
      ),
      toolbarHeight: 80.h,
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Activity ',
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: 'Overview',
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      elevation: 10,
      shadowColor: Colors.blueAccent.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      actions: [
        InkWell(
            onTap: () {
              Get.to(DailyMedicineActivityLog());
            },
            child: Icon(
              Icons.medical_information,
              color: kwhite,
            )),
        SizedBox(
          width: 50,
        )
      ],
    );
  }

  Widget _buildProfileCard() {
    final profileBox = Hive.box<ProfileModel>('profileBox');
    final ProfileModel? profileData = profileBox.get('userProfile');

    return GestureDetector(
      onTap: () {
        Get.to(DailyMedicineActivityLog());
        // Handle profile card tap
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 30.r,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileData?.username ?? 'No Name',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        profileData?.email ?? 'No Email',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                'Daily Goals',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10.h),
              _buildGoalCard(
                  'Water Intake',
                  profileData?.waterIntakeGoal.toString() ?? 'No data',
                  Icons.local_drink),
              SizedBox(height: 10.h),
              _buildGoalCard('Sleep Goal',
                  profileData?.sleepGoal.toString() ?? 'No data', Icons.bed),
              SizedBox(height: 10.h),
              _buildGoalCard(
                  'Walking Goal',
                  profileData?.walkingGoal.toString() ?? 'No data',
                  Icons.directions_walk),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(String label, String value, IconData icon) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            Icon(icon, size: 40.r, color: Colors.blueAccent),
            SizedBox(width: 15.w),
            Text(
              '$label: $value',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
