import 'package:alaram/tools/constans/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class GoalOverviewScreen extends StatelessWidget {
  final profileBox = Hive.box<ProfileModel>('profileBox');

  @override
  Widget build(BuildContext context) {
    final profile = profileBox.get('userProfile')!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Goal Overview',
          style: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Goals and Progress',
              style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            _buildGoalCard('Water Intake Goal', profile.waterIntakeGoal, profile.actualWaterIntake),
            SizedBox(height: 16.h),
            _buildGoalCard('Sleep Goal', profile.sleepGoal, profile.actualSleep),
            SizedBox(height: 16.h),
            _buildGoalCard('Walking Goal', profile.walkingGoal, profile.actualWalking),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(String label, double? goal, double? progress) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            SizedBox(height: 8.h),
            Text(
              'Goal: ${goal?.toStringAsFixed(1) ?? 'Not Set'}',
              style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            Text(
              'Progress: ${progress?.toStringAsFixed(1) ?? 'No Progress'}',
              style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
