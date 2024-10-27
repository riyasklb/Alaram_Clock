import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/constans/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class GoalCompletionScreen extends StatefulWidget {
  @override
  State<GoalCompletionScreen> createState() => _GoalCompletionScreenState();
}

class _GoalCompletionScreenState extends State<GoalCompletionScreen> {
  final profileBox = Hive.box<ProfileModel>('profileBox');
  late ProfileModel profile;
  Box? goalBox; // Make nullable

  double waterProgress = 0.0;
  double sleepProgress = 0.0;
  double walkingProgress = 0.0;
  bool hasTakenBreakfast = false; // Track breakfast submission
  bool hasTakenMedicine = false; // Track medicine submission
  double medicineDosage = 0.0; // Track selected medicine dosage
  String injectionDay = ""; // Track the day for the injection
  bool hasTakenInjection = false; // Track injection submission

  @override
  void initState() {
    super.initState();
    profile = profileBox.get('userProfile')!;
    _initializeBoxes();
  }

  Future<void> _initializeBoxes() async {
    goalBox = await Hive.openBox('goalBox');
    _initializeProgress();
    setState(() {
      hasTakenBreakfast = goalBox?.get('hasTakenBreakfast') ?? false; // Retrieve stored breakfast status
      hasTakenMedicine = goalBox?.get('hasTakenMedicine') ?? false; // Retrieve stored medicine status
      medicineDosage = goalBox?.get('medicineDosage') ?? 0.0; // Retrieve stored medicine dosage
      injectionDay = _getInjectionDay(); // Get injection day based on frequency
    });
  }

  void _initializeProgress() {
    setState(() {
      waterProgress = profile.waterIntakeGoal ?? 0.0;
      sleepProgress = profile.sleepGoal ?? 0.0;
      walkingProgress = profile.walkingGoal ?? 0.0;
    });
  }

  String _getInjectionDay() {
    final today = DateTime.now();
    final nextWeek = today.add(Duration(days: 7));
    final dayAfterTomorrow = today.add(Duration(days: 2));

    String frequency = goalBox?.get('injectionFrequency') ?? "not set"; // Set default to "not set"

    // Check for the frequency and return appropriate message
    if (frequency == 'Daily') {
      return 'Today (${DateFormat.yMMMd().format(today)})';
    } else if (frequency == 'Every Other Day') {
      // Check if today is an even or odd day
      return (today.day % 2 == 0)
          ? 'Today (${DateFormat.yMMMd().format(today)})'
          : 'Next (${DateFormat.yMMMd().format(dayAfterTomorrow)})';
    } else if (frequency == 'Weekly') {
      return 'Next Week (${DateFormat.yMMMd().format(nextWeek)})';
    } else {
      return 'No injections scheduled'; // Default case
    }
  }

  void _saveProgress() async {
    profile.waterIntakeGoal = waterProgress;
    profile.sleepGoal = sleepProgress;
    profile.walkingGoal = walkingProgress;
    await profile.save();
    
    await goalBox?.put('medicineDosage', medicineDosage); // Save selected medicine dosage

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Progress saved successfully!')),
    );
  }

  void _submitBreakfast() async {
    setState(() {
      hasTakenBreakfast = true;
    });
    await goalBox?.put('hasTakenBreakfast', true); // Store breakfast submission status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Breakfast submitted successfully!')),
    );
  }

  void _takeMedicine() async {
    setState(() {
      hasTakenMedicine = true; // Update the medicine status
    });
    await goalBox?.put('hasTakenMedicine', true); // Store medicine submission status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Medicine taken!')),
    );
  }

  void _takeInjection() async {
    setState(() {
      hasTakenInjection = true; // Update the injection status
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Injection taken!')),
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
      body: goalBox == null
          ? Center(child: CircularProgressIndicator()) // Show loading until goalBox is ready
          : Padding(
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
                    // Water Intake Goal Slider
                    _buildGoalProgress(
                      label: 'Water Intake Goal',
                      goal: profile.waterIntakeGoal,
                      progress: waterProgress,
                      onChanged: (value) => setState(() => waterProgress = value),
                    ),
                    SizedBox(height: 16.h),
                    // Sleep Goal Slider
                    _buildGoalProgress(
                      label: 'Sleep Goal',
                      goal: profile.sleepGoal,
                      progress: sleepProgress,
                      onChanged: (value) => setState(() => sleepProgress = value),
                    ),
                    SizedBox(height: 16.h),
                    // Walking Goal Slider
                    _buildGoalProgress(
                      label: 'Walking Goal',
                      goal: profile.walkingGoal,
                      progress: walkingProgress,
                      onChanged: (value) => setState(() => walkingProgress = value),
                    ),
                    SizedBox(height: 16.h),
                    _buildGoalCard('Medicine Frequency', goalBox?.get('medicineFrequency') ?? 'Not Set'),
                    _buildGoalCard('Injection Dosage', goalBox?.get('injectionDosage') ?? 'Not Set'),
                    _buildGoalCard('Injection Frequency', goalBox?.get('injectionFrequency') ?? 'Not Set'),
                    SizedBox(height: 20.h),
                    // Show the injection day based on the frequency
                    _buildGoalCard('Injection Day', injectionDay),
                    SizedBox(height: 20.h),
                    if (goalBox?.get('enableBreakfast') == true) // Only show if breakfast is enabled
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Breakfast',
                            style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.h),
                          hasTakenBreakfast
                              ? Text(
                                  'Breakfast taken',
                                  style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.green),
                                )
                              : ElevatedButton(
                                  onPressed: _submitBreakfast,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Submit Breakfast',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                      kheight40,kheight40,  ],
                      ),
                    SizedBox(height: 20.h),
                    // Medicine section with dosage slider
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Medicine Dosage',
                          style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        Slider(
                          value: medicineDosage,
                          min: 0,
                          max: 10, // Adjust maximum dosage as needed
                          divisions: 10, // Adjust divisions for slider steps
                          label: medicineDosage.toStringAsFixed(1),
                          onChanged: (double value) {
                            setState(() {
                              medicineDosage = value; // Update the dosage value
                            });
                          },
                        ),
                        Text(
                          'Dosage: ${medicineDosage.toStringAsFixed(1)}',
                          style: GoogleFonts.poppins(fontSize: 14.sp),
                        ),
                        SizedBox(height: 8.h),
                        hasTakenMedicine
                            ? Text(
                                'Medicine taken',
                                style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.green),
                              )
                            : ElevatedButton(
                                onPressed: _takeMedicine,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Text(
                                  'Take Medicine',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // Injection section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Injection',
                          style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        hasTakenInjection
                            ? Text(
                                'Injection taken',
                                style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.green),
                              )
                            : ElevatedButton(
                                onPressed: _takeInjection,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Text(
                                  'Take Injection',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: _saveProgress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Save Progress',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
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

  Widget _buildGoalCard(String label, String value) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 16.sp)),
            Text(value, style: GoogleFonts.poppins(fontSize: 16.sp)),
          ],
        ),
      ),
    );
  }
}
