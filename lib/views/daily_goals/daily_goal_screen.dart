import 'package:alaram/tools/constans/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class GoalCompletionScreen extends StatefulWidget {
  @override
  State<GoalCompletionScreen> createState() => _GoalCompletionScreenState();
}

class _GoalCompletionScreenState extends State<GoalCompletionScreen> {
  final profileBox = Hive.box<ProfileModel>('profileBox');
  late ProfileModel profile;

  double waterProgress = 0.0;
  double sleepProgress = 0.0;
  double walkingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    profile = profileBox.get('userProfile')!;
    _initializeProgress();
  }

  void _initializeProgress() {
    // Initialize progress with saved values or default to 0
    waterProgress = profile.waterIntakeGoal ?? 0.0;
    sleepProgress = profile.sleepGoal ?? 0.0;
    walkingProgress = profile.walkingGoal ?? 0.0;
  }

  void _saveProgress() async {
    profile.waterIntakeGoal = waterProgress;
    profile.sleepGoal = sleepProgress;
    profile.walkingGoal = walkingProgress;
    await profile.save();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Progress saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Goal Completion',
          style: GoogleFonts.poppins(
            fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Goals',
                style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              _buildGoalProgress(
                label: 'Water Intake Goal',
                goal: profile.waterIntakeGoal,
                progress: waterProgress,
                onChanged: (value) => setState(() => waterProgress = value),
              ),
              SizedBox(height: 16.h),
              _buildGoalProgress(
                label: 'Sleep Goal',
                goal: profile.sleepGoal,
                progress: sleepProgress,
                onChanged: (value) => setState(() => sleepProgress = value),
              ),
              SizedBox(height: 16.h),
              _buildGoalProgress(
                label: 'Walking Goal',
                goal: profile.walkingGoal,
                progress: walkingProgress,
                onChanged: (value) => setState(() => walkingProgress = value),
              ),
              SizedBox(height: 30.h),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _saveProgress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 100.w, vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Save Progress',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalProgress({
    required String label,
    double? goal,
    required double progress,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: progress,
                max: goal ?? 1.0,
                onChanged: onChanged,
              ),
            ),
            Text(
              '${progress.toStringAsFixed(1)} / ${goal?.toStringAsFixed(1) ?? 'Not Set'}',
              style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}
