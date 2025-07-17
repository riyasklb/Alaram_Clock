import 'dart:io';

import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/controllers/goal_notification_controller.dart';
import 'package:alaram/tools/model/profile_model.dart';
import 'package:alaram/views/careers_and_advice/careers_and_advice.dart';
import 'package:alaram/views/clinic_visit/clinic_visit_screen.dart';

import 'package:alaram/views/completed_tasks/daily_activity_medicine_log.dart';
import 'package:alaram/views/daily_activity_updation/update_daily_activity_screeen.dart';
import 'package:alaram/views/landing_screen/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:alaram/tools/model/activity_log.dart';
import '../video/video_tutorial.dart';

import '../daily_activity_updation/callender_daily_task_screen.dart';
import '../chart/dashboard_screen.dart';
import '../main_activity/activity_main_screen.dart';
import '../profile/profile_screen.dart';
import 'package:alaram/tools/controllers/profile_controller.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF1E88E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: GestureDetector(
              onTap: () => Get.to(() => ProfileScreen()),
              child: FutureBuilder(
                future: _openBoxes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Failed to load profile',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    );
                  }

                  final profileBox = Hive.box<ProfileModel>('profileBox');
                  final profile = profileBox.get('userProfile');

                  final username = profile?.username?.trim().isNotEmpty == true
                      ? profile!.username!
                      : 'there';

                  final hasProfileImage = profile?.imagePath != null &&
                      File(profile!.imagePath!).existsSync();

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome back,',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '$username!',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Here is your daily overview.',
                              style: GoogleFonts.montserrat(
                                color: Colors.white70,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 45.r,
                        backgroundColor: Colors.white,
                        backgroundImage: hasProfileImage
                            ? FileImage(File(profile!.imagePath!))
                            : const AssetImage('assets/logo/boy.png')
                                as ImageProvider,
                      ),
                    ],
                  );
                },
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

          // All main content widgets (background, profile header, cards, interactive section, etc.)

          // Move the pending activity log modal to the end so it is always on top
          FutureBuilder(
            future: _getPendingActivityDates(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) return SizedBox();
              final List<DateTime> pendingDates = snapshot.data as List<DateTime>? ?? [];
              if (pendingDates.isEmpty) return SizedBox();
              return Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.35),
                  child: Center(
                    child: Card(
                      color: Colors.redAccent.withOpacity(0.95),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 12,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32.sp),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    'Pending Activity Logs',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'You have not updated your activity for:',
                              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 16.sp),
                            ),
                            SizedBox(height: 8.h),
                            ...pendingDates.map((date) => Text(
                              '- ${DateFormat('MMMM dd, yyyy').format(date)}',
                              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16.sp),
                            )),
                            SizedBox(height: 20.h),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: Icon(Icons.edit_calendar),
                                label: Text('Update Now', style: TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () => Get.to(() => UpdateYourDailyActivityScreen()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
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

              return Obx(() {
                final double sleepGoal = profileController.sleepGoal.value;
                final double walkingGoal = profileController.walkingGoal.value;
                final double waterGoal = profileController.waterGoal.value;

                final bool sleepAchieved = sleepGoal > 0 && latestLog != null && latestLog.sleepHours >= sleepGoal;
                final bool walkingAchieved = walkingGoal > 0 && latestLog != null && latestLog.walkingHours >= walkingGoal;
                final bool waterAchieved = waterGoal > 0 && latestLog != null && latestLog.waterIntake >= waterGoal;

          

                return Positioned(
                  top: 180.h,
                  left: 16.w,
                  right: 16.w,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard(
                            color:  const Color.fromARGB(255, 122, 60, 37),
                            icon: 'assets/logo/walking.png',
                            value: totalHoursWalked,
                            label: 'Hrs',
                            achieved: walkingAchieved,
                            percent: (walkingGoal > 0 && latestLog != null)
                                ? (latestLog.walkingHours / walkingGoal)
                                : null,
                          ),
                          _buildStatCard(
                            color: const Color.fromARGB(255, 0, 73, 56),
                            icon: 'assets/logo/sleeping.png',
                            value: totalHoursSlept,
                            label: 'Hrs',
                            achieved: sleepAchieved,
                            percent: (sleepGoal > 0 && latestLog != null)
                                ? (latestLog.sleepHours / sleepGoal)
                                : null,
                          ),
                          _buildStatCard(
                            color: const Color.fromARGB(255, 19, 60, 131),
                            icon: 'assets/logo/drinking-water.png',
                            value: totalWaterIntake,
                            label: 'Lts',
                            achieved: waterAchieved,
                            percent: (waterGoal > 0 && latestLog != null)
                                ? (latestLog.waterIntake / waterGoal)
                                : null,
                          ),
                        ],
                      ),
                    
                    ],
                  ),
                );
              });
            },
          ),

          // Interactive Section
          Padding(
            padding: EdgeInsets.only(top: 360.h),
            child: _InteractiveSection(),
          ),
    // Move the pending activity log modal to the end so it is always on top
          FutureBuilder(
            future: _getPendingActivityDates(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) return SizedBox();
              final List<DateTime> pendingDates = snapshot.data as List<DateTime>? ?? [];
              if (pendingDates.isEmpty) return SizedBox();
              return Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.35),
                  child: Center(
                    child: Card(
                      color: Colors.redAccent.withOpacity(0.95),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 12,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32.sp),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    'Pending Activity Logs',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'You have not updated your activity for:',
                              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 16.sp),
                            ),
                            SizedBox(height: 8.h),
                            ...pendingDates.map((date) => Text(
                              '- ${DateFormat('MMMM dd, yyyy').format(date)}',
                              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16.sp),
                            )),
                            SizedBox(height: 20.h),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: Icon(Icons.edit_calendar),
                                label: Text('Update Now', style: TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () => Get.to(() => UpdateYourDailyActivityScreen()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),     ],
      ),
    );
  }

  // Helper to get pending activity log dates for the last 3 days (excluding today)
  Future<List<DateTime>> _getPendingActivityDates() async {
    final box = await Hive.openBox<ActivityLog>('activityLogs');
    final profileBox = await Hive.openBox<ProfileModel>('profileBox');
    final profile = profileBox.get('userProfile');
    final now = DateTime.now();
    // Check if registered today
    if (profile != null && profile.registerdate != null) {
      final reg = profile.registerdate!;
      if (reg.year == now.year && reg.month == now.month && reg.day == now.day) {
        return [];
      }
    }
    List<DateTime> last3Days = List.generate(3, (i) => DateTime(now.year, now.month, now.day).subtract(Duration(days: i + 1)));
    List<DateTime> missing = [];
    for (final date in last3Days) {
      bool exists = box.values.any((log) {
        final logDate = DateTime(log.date.year, log.date.month, log.date.day);
        return logDate.isAtSameMomentAs(date);
      });
      if (!exists) missing.add(date);
    }
    return missing;
  }

  Widget _buildStatCard({
    required Color color,
    required String icon,
    required String value,
    required String label,
    required bool achieved,
    double? percent, // new param for progress bar
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
// height: 160.h,
      width: 120.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
       
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.12),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(8.w),
            child: Image.asset(
              icon, height: 44.h, width: 44.w,
            ),
          ),
          SizedBox(height: 8.h),
          Icon(
            achieved ? Icons.circle : Icons.circle,
            color: achieved ? Colors.green : Colors.red,
            size: 22.sp,
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 8.h),
          // Progress bar
          if (percent != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: LinearProgressIndicator(
                  value: percent.clamp(0, 1),
                  minHeight: 7,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(achieved ? Colors.green : Colors.red),
                ),
              ),
            ),
          SizedBox(height: 13.h),
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
    onTap: () => Get.to(() => LandingScreen()),
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
    onTap: () => Get.to(() => DashBoardScreen()),
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
    onTap: () => Get.to(() => AdviceGuidanceScreen()),
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

