
import 'package:alaram/views/daily_activity_updation/dailyactivity_medicine_update_screen.dart';
import 'package:alaram/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alaram/views/daily_activity_updation/callender_daily_task_screen.dart';
import 'package:alaram/views/pdf_exel_output/activity_main_screen.dart';
import 'package:alaram/views/profile/profile_screen.dart';
import 'package:alaram/views/video/video_tutorial.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String totalHoursWalked = "5h";
    final String totalHoursSlept = "7h";
    final String totalWaterIntake = "2L";
    final String overallHealth = "Good";
    final String date = "2024-11-08";

    return Scaffold(
      body: Stack(
        children: [
          // Curved background for the AppBar
          ClipPath(
            clipper: AppBarClipper(),
            child: Container(
              color: Colors.blueAccent,
              height: 200.h,
              padding: EdgeInsets.only(top: 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Home',
                          style: GoogleFonts.poppins(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          date,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAppBarInfoCard('Walk', totalHoursWalked, Icons.directions_walk),
                        _buildAppBarInfoCard('Sleep', totalHoursSlept, Icons.bedtime),
                        _buildAppBarInfoCard('Water', totalWaterIntake, Icons.local_drink),
                        _buildAppBarInfoCard('Overall', overallHealth, Icons.health_and_safety),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main content with padding to avoid overlap with curved AppBar
          Padding(
            padding: EdgeInsets.only(top: 180.h),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              padding: EdgeInsets.all(16.w),
              children: [
                _buildGridItem(
                  title: 'Profile',
                  icon: Icons.person,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
                  },
                ),
                _buildGridItem(
                  title: 'Activity',
                  icon: Icons.fitness_center,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ActivityMainPage()));
                  },
                ),
                _buildGridItem(
                  title: 'Calendar',
                  icon: Icons.calendar_today,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => DailyMedicneTaskCallenderScreen()));
                  },
                ),
                _buildGridItem(
                  title: 'Video Tutorials',
                  icon: Icons.video_library,
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => VideoTutorial()));
                  },
                ),
                _buildGridItem(
                  title: 'Resources',
                  icon: Icons.book,
                  color: Colors.green,
                  onTap: () {
              //      Get.to(DailyMedicineIntakeScreen());
                    // Add your Resources screen here
                  },
                ),
                _buildGridItem(
                  title: 'Medicine',
                  icon: Icons.medical_services,
                  color: Colors.purple,
                  onTap: () {
                    Get.to(DailyMedicneTaskCallenderScreen());
                    // Add your Medicine screen here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for AppBar information cards
  Widget _buildAppBarInfoCard(String title, String data, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24.sp),
        SizedBox(height: 4.h),
        Text(
          data,
          style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }

  // Widget for grid items with onTap callback
  Widget _buildGridItem({required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: color.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50.sp, color: color),
              SizedBox(height: 10.h),
              Text(
                title,
                style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Clipper for creating a curved AppBar background
class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40.h); // Starting point of curve
    path.quadraticBezierTo(
      size.width / 2, size.height,
      size.width, size.height - 40.h,
    );
    path.lineTo(size.width, 0); // Close the shape
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}