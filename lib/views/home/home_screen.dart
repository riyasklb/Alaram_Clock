import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/model/profile_model.dart';
import 'package:alaram/views/clinic_visit/clinic_visit_screen.dart';

import 'package:alaram/views/completed_tasks/daily_activity_medicine_log.dart';
import 'package:alaram/views/daily_activity_updation/daily_actitivity_sleep_update_screen.dart';
import 'package:alaram/views/landing_screen/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:alaram/tools/model/activity_log.dart';
import '../video/video_tutorial.dart';

import '../daily_activity_updation/callender_daily_task_screen.dart';
import '../chart/chart_screen.dart';
import '../main_activity/activity_main_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _openBoxes() async {
    await Hive.openBox<ProfileModel>('profileBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/logo/top-view-pills-with-spoon.jpg'), // Replace with your background image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // The rest of your widgets remain the same...
      Container(
        height: 240.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3F51B5), Color(0xFF1E88E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade200,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
        child: GestureDetector(
             onTap: () {
          Get.to(ProfileScreen());
        },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  FutureBuilder(
                      future: _openBoxes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Failed to open Hive boxes.'));
                        }
              
                        final profileBox = Hive.box<ProfileModel>('profileBox');
              
                     return Text(
  'Welcome back,\n${profileBox.get('userProfile')?.username ?? 'there'}!',
  style: GoogleFonts.montserrat(
    color: Colors.white,
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
  ),
);

                      }),
                  SizedBox(height: 10.h),
                  Text(
                    'Here is your daily overview!',
                    style: GoogleFonts.montserrat(
                      color: Colors.white70,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              Image.asset(
                'assets/logo/doctor.png',
                height: 120.h,
                width: 120.w,
              ),
            ],
          ),
        ),
      ),
      
      // Calendar Icon Positioned at top right
      Positioned(
        top: 37.h,
        left: 16,
        child: GestureDetector(
          onTap: () {
            Get.to(DailyMedicneTaskCallenderScreen());
            // Handle calendar tap
          },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
        ),
      ),

          // Cards Section
          ValueListenableBuilder(
            valueListenable: Hive.box<ActivityLog>(sleepactivitys).listenable(),
            builder: (context, Box<ActivityLog> box, _) {
              ActivityLog? latestLog = box.isEmpty ? null : box.values.last;
              String totalHoursWalked =
                  latestLog?.walkingHours?.toStringAsFixed(1) ?? '0h';
              String totalHoursSlept =
                  latestLog?.sleepHours?.toStringAsFixed(1) ?? '0h';
              String totalWaterIntake =
                  latestLog?.waterIntake?.toStringAsFixed(1) ?? '0L';

              return Positioned(
                top: 180.h, // Place the cards just below the blue background
                left: 16.w,
                right: 16.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard(
                      color: Colors.deepPurpleAccent,
                      icon: 'assets/logo/walking.png',
                      value: totalHoursWalked,
                      label: 'Hours Walked',
                    ),
                    _buildStatCard(
                      color: Colors.cyan,
                      icon: 'assets/logo/sleeping.png',
                      value: totalHoursSlept,
                      label: 'Hours Slept',
                    ),
                    _buildStatCard(
                      color: Colors.pinkAccent,
                      icon: 'assets/logo/drinking-water.png',
                      value: totalWaterIntake,
                      label: 'Water Intake',
                    ),
                  ],
                ),
              );
            },
          ),

          // Interactive Section
          Padding(
            padding: EdgeInsets.only(top: 360.h),
            child: _InteractiveSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required Color color,
    required String icon,
    required String value,
    required String label,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 140.h,
      width: 110.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon, height: 70.h, // Adjust the size of the image
            width: 70.w,
          ), //  Icon(icon, size: 32.sp, color: Colors.white),  // Using FontAwesomeIcons here
          //SizedBox(height: 10.h),

          Text(
            value,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractiveSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      itemCount: _gridItems.length,
      itemBuilder: (context, index) {
        final item = _gridItems[index];
        return _buildCarouselCard(
          title: item.title,
          imagePath: item.imagePath,
          color: item.color,
          onTap: item.onTap,
        );
      },
    );
  }

  Widget _buildCarouselCard({
    required String title,
    required String imagePath, // Use imagePath instead of icon
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 16.h),
        height: 140.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 16.w),
            CircleAvatar(
              backgroundColor: kwhite,
              radius: 40.r,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Image.asset(
                  // Replace the icon with Image.asset()
                  imagePath,
                  height: 30.sp, // Adjust size as needed
                  width: 30.sp, // Adjust size as needed
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Tap to explore $title!",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 24.sp,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final _gridItems = [
  GridItem(
    title: 'Update Daily Goals',
    imagePath: 'assets/logo/medicine.png', // A more dynamic icon for tasks
    color: Colors.deepPurple,
    onTap: () => Get.to(() =>LandingScreen()),
  ),
  GridItem(
    title: 'Clinic Visit',
    
    imagePath:
        'assets/logo/veterinarian.png', // A calendar with a checkmark, ideal for tracking events
    color: Colors.orange,
    onTap: () => Get.to(() => ClinicalVisitScreen()),
  ),
  GridItem(
    title: 'DashBoard',
    imagePath:
        'assets/logo/bar-chart.png', // A bar chart, providing a more diverse chart option
    color: Colors.blueAccent,
    onTap: () => Get.to(() => ActivityLineChartScreen()),
  ),
  // GridItem(
  //   title: 'Profile',
  //   imagePath:
  //       'assets/logo/boy.png', // A badge, giving a fresh approach to profile
  //   color: Colors.green,
  //   onTap: () => Get.to(() => ProfileScreen()),
  // ),
  // GridItem(
  //   title: 'Activity',
  //   imagePath:
  //       'assets/logo/treadmill.png', // Running icon for activity-related tasks
  //   color: Colors.teal,
  //   onTap: () => Get.to(() => DailyMedicineActivityLog()),
  // ),
  GridItem(
    title: 'Advice & Guidance',
    imagePath:
        'assets/logo/video-marketing.png', // A play icon for tutorials and videos
    color: Colors.pink,
    onTap: () => Get.to(() => VideoTutorial()),
  ),
];

class GridItem {
  final String title;
  final String imagePath;
  final Color color;
  final VoidCallback onTap;

  GridItem({
    required this.title,
    required this.imagePath,
    required this.color,
    required this.onTap,
  });
}

Widget _buildStatCard({
  required Color color,
  required String imagePath, // Use imagePath instead of icon
  required String value,
  required String label,
}) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 300),
    height: 140.h,
    width: 110.w,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [color.withOpacity(0.8), color],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.4),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath, // Use Image.asset() to load an image
          height: 32.sp, // Adjust size as needed
          width: 32.sp, // Adjust size as needed
        ),
        SizedBox(height: 10.h),
        Text(
          value,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            color: Colors.white70,
            fontSize: 12.sp,
          ),
        ),
      ],
    ),
  );
}
