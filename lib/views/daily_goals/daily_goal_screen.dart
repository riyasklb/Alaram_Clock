
import 'package:alaram/tools/constans/model/daily_activity_model.dart';
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
  Box? activityBox; // Declare the activityBox


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

  List<List<String>> medicineTimes = [];
  List<String> medicineNames = [];
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
        medicineTimes.add(times);
        medicineNames.add(medicine['name']);
      }
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
     if (!Hive.isBoxOpen('dailyActivities')) {
    activityBox = await Hive.openBox<DailyActivityModel>('dailyActivities');
  } else {
    activityBox = Hive.box<DailyActivityModel>('dailyActivities');
  }
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
  final dailyActivity = DailyActivityModel(
    userId: 'r', // Replace with the actual user ID
    date: currentDate,
    waterIntake: waterProgress,
    sleepHours: sleepProgress,
    walkingSteps: walkingProgress.toInt(),
    foodIntake: _getFoodIntakeStatus(),
    medicineIntake: _getMedicineIntakeStatus(),
  );

  print('-----------1--------------');
  await activityBox?.put(currentDate, dailyActivity);

  // Retrieve the saved data and print it
  final savedDailyActivity = activityBox?.get(currentDate);
  if (savedDailyActivity != null) {
    print('Daily progress saved successfully:');
    print('User ID: ${savedDailyActivity.userId}');
    print('Date: ${savedDailyActivity.date}');
    print('Water Intake: ${savedDailyActivity.waterIntake}');
    print('Sleep Hours: ${savedDailyActivity.sleepHours}');
    print('Walking Steps: ${savedDailyActivity.walkingSteps}');
    print('Food Intake: ${savedDailyActivity.foodIntake}');
    print('Medicine Intake: ${savedDailyActivity.medicineIntake}');
  } else {
    print('Failed to retrieve saved daily progress.');
  }
}


  String _getFoodIntakeStatus() {
    int mealCount = mealStatus.values.where((status) => status).length;
    if (mealCount == 3) return 'GOOD';
    if (mealCount == 2) return 'AVERAGE';
    return 'POOR';
  }

  String _getMedicineIntakeStatus() {
    int medicineCount = medicineStatus.values.where((status) => status).length;
    if (medicineCount == 4) return 'GOOD';
    if (medicineCount == 2 || medicineCount == 3) return 'AVERAGE';
    return 'POOR';
  }

  void _takeMeal(String meal) {
    setState(() {
      mealStatus[meal] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$meal taken!')),
    );
  }

  void _takeMedicine(String time) {
    setState(() {
      medicineStatus[time] = true;
    });
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
          medicineName,
          style:
              GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
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
        SizedBox(height: 16.h),
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
                    SizedBox(height: 20.h),
                    Text(
                      'Meal',
                      style: GoogleFonts.poppins(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                    if (enableBreakfast) _buildMealButton('Breakfast'),
                    if (enableLunch) _buildMealButton('Lunch'),
                    if (enableDinner) _buildMealButton('Dinner'),
                    SizedBox(height: 20.h),
                    Text(
                      'Progress',
                      style: GoogleFonts.poppins(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.h),
                    _buildSlider(
                      label: 'Water Intake',
                      value: waterProgress,
                      onChanged: (value) {
                        setState(() {
                          waterProgress = value;
                        });
                      },
                    ),
                    _buildSlider(
                      label: 'Sleep',
                      value: sleepProgress,
                      onChanged: (value) {
                        setState(() {
                          sleepProgress = value;
                        });
                      },
                    ),
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
                    Text(
                      'Medicines',
                      style: GoogleFonts.poppins(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                    ...medicineNames.asMap().entries.map((entry) {
                      int index = entry.key;
                      String medicineName = entry.value;
                      return _buildMedicineButton(
                          medicineTimes[index].first, medicineName);
                    }).toList(),
                    SizedBox(height: 20.h),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _saveDailyProgress();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Daily goals saved!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                        ),
                        child: Text(
                          'Save Progress',
                          style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
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
        Text(
          '$label: ${value.toStringAsFixed(1)}',
          style: GoogleFonts.poppins(fontSize: 16.sp),
        ),
        Slider(
          value: value,
          min: 0,
          max: 10,
          divisions: 10,
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
