import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/constans/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class GoalCompletionScreen extends StatefulWidget {
  @override
  State<GoalCompletionScreen> createState() => _GoalCompletionScreenState();
}

class _GoalCompletionScreenState extends State<GoalCompletionScreen> {
  final profileBox = Hive.box<ProfileModel>('profileBox');
  late ProfileModel profile;
  Box? goalBox;

  double waterProgress = 0.0;
  double sleepProgress = 0.0;
  double walkingProgress = 0.0;
  bool hasTakenBreakfast = false;
  bool hasTakenMorningMedicine = false;
  bool hasTakenNightMedicine = false;
  bool hasTakenMorningInjection = false;
  bool hasTakenNightInjection = false;

  final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    profile = profileBox.get('userProfile')!;
    _initializeDailyGoals();
  }

  Future<void> _initializeDailyGoals() async {
    goalBox = await Hive.openBox('goalBox');

    String lastSavedDate = goalBox?.get('lastSavedDate') ?? '';
    if (lastSavedDate != currentDate) {
      _resetDailyGoals();
      await goalBox?.put('lastSavedDate', currentDate);
    }

    setState(() {
      hasTakenBreakfast = goalBox?.get('hasTakenBreakfast') ?? false;
      hasTakenMorningMedicine = goalBox?.get('hasTakenMorningMedicine') ?? false;
      hasTakenNightMedicine = goalBox?.get('hasTakenNightMedicine') ?? false;

      waterProgress = goalBox?.get('waterProgress') ?? profile.waterIntakeGoal ?? 0.0;
      sleepProgress = goalBox?.get('sleepProgress') ?? profile.sleepGoal ?? 0.0;
      walkingProgress = goalBox?.get('walkingProgress') ?? profile.walkingGoal ?? 0.0;
      _isLoading = false;
    });
  }

  void _resetDailyGoals() {
    setState(() {
      hasTakenBreakfast = false;
      hasTakenMorningMedicine = false;
      hasTakenNightMedicine = false;
      hasTakenMorningInjection = false;
      hasTakenNightInjection = false;
      waterProgress = 0.0;
      sleepProgress = 0.0;
      walkingProgress = 0.0;
    });
  }

  Future<void> _saveDailyProgress() async {
    await goalBox?.put('hasTakenBreakfast', hasTakenBreakfast);
    await goalBox?.put('hasTakenMorningMedicine', hasTakenMorningMedicine);
    await goalBox?.put('hasTakenNightMedicine', hasTakenNightMedicine);

    await goalBox?.put('waterProgress', waterProgress);
    await goalBox?.put('sleepProgress', sleepProgress);
    await goalBox?.put('walkingProgress', walkingProgress);
    await goalBox?.put('lastSavedDate', currentDate);
  }

  void _submitBreakfast() async {
    setState(() => hasTakenBreakfast = true);
    await _saveDailyProgress();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Breakfast submitted successfully!')));
  }

  void _takeMorningMedicine() async {
    setState(() => hasTakenMorningMedicine = true);
    await _saveDailyProgress();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Morning medicine taken!')));
  }

  void _takeNightMedicine() async {
    setState(() => hasTakenNightMedicine = true);
    await _saveDailyProgress();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Night medicine taken!')));
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Goal Completion',
          style: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Goals', style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.bold)),
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
                    SizedBox(height: 20.h),
                    Text('Food Cycle', style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.h),
                    hasTakenBreakfast
                        ? Text('Breakfast taken', style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.green))
                        : ElevatedButton(
                            onPressed: _submitBreakfast,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            ),
                            child: Text(
                              'Submit Breakfast',
                              style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                    SizedBox(height: 20.h),
                    Text('Medicine', style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    hasTakenMorningMedicine
                        ? Text('Morning medicine taken', style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.green))
                        : ElevatedButton(
                            onPressed: _takeMorningMedicine,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            ),
                            child: Text(
                              'Take Morning Medicine',
                              style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                    SizedBox(height: 10.h),
                    hasTakenNightMedicine
                        ? Text('Night medicine taken', style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.green))
                        : ElevatedButton(
                            onPressed: _takeNightMedicine,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            ),
                            child: Text(
                              'Take Night Medicine',
                              style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                    SizedBox(height: 20.h),
                 
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildGoalProgress({required String label, required double? goal, required double progress, required Function(double) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label (${progress.toStringAsFixed(1)} / ${goal?.toStringAsFixed(1) ?? 0})',
            style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500)),
        Slider(
          min: 0.0,
          max: goal ?? 1.0,
          value: progress,
          onChanged: onChanged,
          activeColor: Colors.blueAccent,
          inactiveColor: Colors.grey[300],
        ),
      ],
    );
  }
}
