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

  bool enableBreakfast = false;
  bool enableLunch = false;
  bool enableDinner = false;

  Map<String, bool> mealStatus = {
    'Breakfast': false,
    'Lunch': false,
    'Dinner': false,
  };

  Map<String, bool> medicineStatus = {
    'Morning': false,
    'Afternoon': false,
    'Evening': false,
    'Night': false,
  };

  List<List<String>> medicineTimes = []; // A list of lists of strings

  List<String> medicineNames = []; // New list to hold medicine names
  bool _isLoading = true;
  final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    profile = profileBox.get('userProfile')!;
    fetchMedicineDetails();
    _initializeDailyGoals();
  }

  Future<void> fetchMedicineDetails() async {
    goalBox = Hive.box('goalBox');
    var medicines = goalBox?.get('medicines');

    if (medicines != null) {
      for (var medicine in medicines) {
        List<String> times = List<String>.from(medicine['times'] ?? []);
        medicineTimes
            .add(times); // Add each medicine's times as a separate list
        medicineNames.add(medicine['name']); // Store the medicine name
      }
    } else {
      print('No medicines data found!');
    }

    setState(() {
      enableBreakfast = goalBox?.get('enableBreakfast') ?? true;
      enableLunch = goalBox?.get('enableLunch') ?? true;
      enableDinner = goalBox?.get('enableDinner') ?? true;
      _isLoading = false;
    });
  }

  void _initializeDailyGoals() async {
    goalBox = await Hive.openBox('goalBox');
    String lastSavedDate = goalBox?.get('lastSavedDate') ?? '';

    if (lastSavedDate != currentDate) {
      _resetDailyGoals();
      await goalBox?.put('lastSavedDate', currentDate);
    }

    setState(() {
      medicineStatus = {
        'Morning': goalBox?.get('hasTakenMorningMedicine') ?? false,
        'Afternoon': goalBox?.get('hasTakenAfternoonMedicine') ?? false,
        'Evening': goalBox?.get('hasTakenEveningMedicine') ?? false,
        'Night': goalBox?.get('hasTakenNightMedicine') ?? false,
      };
    });
  }

  void _resetDailyGoals() {
    setState(() {
      medicineStatus = {
        'Morning': false,
        'Afternoon': false,
        'Evening': false,
        'Night': false,
      };
      waterProgress = 0.0;
      sleepProgress = 0.0;
      walkingProgress = 0.0;
      mealStatus = {
        'Breakfast': false,
        'Lunch': false,
        'Dinner': false,
      };
    });
  }

  Future<void> _saveDailyProgress() async {
    for (var time in medicineStatus.keys) {
      await goalBox?.put('hasTaken${time}Medicine', medicineStatus[time]);
    }

    for (var meal in mealStatus.keys) {
      await goalBox?.put('hasEaten${meal}', mealStatus[meal]);
    }

    await goalBox?.put('waterProgress', waterProgress);
    await goalBox?.put('sleepProgress', sleepProgress);
    await goalBox?.put('walkingProgress', walkingProgress);
    await goalBox?.put('lastSavedDate', currentDate);
  }

  void _takeMeal(String meal) async {
    setState(() {
      mealStatus[meal] = true;
    });
    await _saveDailyProgress();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$meal taken!')),
    );
  }

  void _takeMedicine(String time) async {
    setState(() {
      medicineStatus[time] = true;
    });
    await _saveDailyProgress();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$time medicine taken!')),
    );
  }

  Widget _buildMealButton(String meal) {
    return mealStatus[meal]!
        ? Text('$meal taken',
            style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.green))
        : ElevatedButton(
            onPressed: () => _takeMeal(meal),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text(
              'Eat $meal',
              style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          );
  }

  Widget _buildMedicineButton(String time, String medicineName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          medicineName, // Display medicine name
          style:
              GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h), // Space between medicine name and button
        medicineStatus[time]!
            ? Text('$time medicine taken',
                style:
                    GoogleFonts.poppins(fontSize: 14.sp, color: Colors.green))
            : ElevatedButton(
                onPressed: () => _takeMedicine(time),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                child: Text(
                  'Take $time Medicine',
                  style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
        SizedBox(height: 16.h), // Space between medicine buttons
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Goal Completion',
          style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
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
                    // Text(
                    //   'Your Goals',
                    //   style: GoogleFonts.poppins(
                    //       fontSize: 20.sp, fontWeight: FontWeight.bold),
                    // ),
                    SizedBox(height: 20.h), Text(
                      'Meal',
                      style: GoogleFonts.poppins(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),kheight40,

                    // Meal Buttons
                    if (enableBreakfast) _buildMealButton('Breakfast'),
                    if (enableLunch) _buildMealButton('Lunch'),
                    if (enableDinner) _buildMealButton('Dinner'),

                    SizedBox(height: 20.h),

                    // Sliders Section
                    Text(
                      'Progress',
                      style: GoogleFonts.poppins(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.h),

                    // Water Intake Slider
                    _buildSlider(
                      label: 'Water Intake',
                      value: waterProgress,
                      onChanged: (value) {
                        setState(() {
                          waterProgress = value;
                        });
                      },
                    ),

                    // Sleep Slider
                    _buildSlider(
                      label: 'Sleep',
                      value: sleepProgress,
                      onChanged: (value) {
                        setState(() {
                          sleepProgress = value;
                        });
                      },
                    ),

                    // Walking Slider
                    _buildSlider(
                      label: 'Walking',
                      value: walkingProgress,
                      onChanged: (value) {
                        setState(() {
                          walkingProgress = value;
                        });
                      },
                    ),

                    SizedBox(height: 20.h),

               
// Medicine Buttons
                    Text(
                      'Medicine',
                      style: GoogleFonts.poppins(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
kheight40,
                    for (var i = 0; i < medicineNames.length; i++)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the medicine name only once
                          // Text(
                          //   medicineNames[i],
                          //   style: GoogleFonts.poppins(
                          //       fontSize: 18.sp, fontWeight: FontWeight.bold),
                          // ),
                          SizedBox(height: 8.h),

                          // Display a button for each time for the current medicine
                          for (var time in medicineTimes[i])
                            _buildMedicineButton(time, medicineNames[i]),

                          SizedBox(height: 16.h), // Space between each medicine
                        ],
                      ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSlider(
      {required String label,
      required double value,
      required ValueChanged<double> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 16.sp)),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 100,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
