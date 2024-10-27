import 'package:alaram/tools/constans/model/hive_model.dart';
import 'package:alaram/views/callender_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';


class AddDailyActivitiesScreen extends StatefulWidget {
  @override
  _AddDailyActivitiesScreenState createState() =>
      _AddDailyActivitiesScreenState();
}

class _AddDailyActivitiesScreenState extends State<AddDailyActivitiesScreen> {
  final TextEditingController _walkingController = TextEditingController();
  final TextEditingController _sleepController = TextEditingController();
  final TextEditingController _waterIntakeController = TextEditingController();

  late Box<ActivityModel> _activityBox;

  @override
  void initState() {
    super.initState();
    _activityBox = Hive.box<ActivityModel>('activityBox');
  }

  @override
  void dispose() {
    _walkingController.dispose();
    _sleepController.dispose();
    _waterIntakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        title: Text(
          'Daily Activities',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.grey[200], // Light background color
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          // Allow scrolling for smaller screens
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Log Your Activities',
                style: GoogleFonts.lato(
                    fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              Card(
                elevation: 4, // Add elevation for shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      _buildActivityInput(
                        label: 'Minutes Walked',
                        hintText: 'Enter minutes walked',
                        controller: _walkingController,
                        icon: Icons.directions_walk,
                      ),
                      SizedBox(height: 20.h),
                      _buildActivityInput(
                        label: 'Hours Slept',
                        hintText: 'Enter hours slept',
                        controller: _sleepController,
                        icon: Icons.bed,
                      ),
                      SizedBox(height: 20.h),
                      _buildActivityInput(
                        label: 'Water Intake (Liters)',
                        hintText: 'Enter water intake in liters',
                        controller: _waterIntakeController,
                        icon: Icons.local_drink,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              Center(
                child: ElevatedButton(
                  onPressed: _submitActivities,
                  child: Text(
                    'Submit',
                    style:
                        GoogleFonts.lato(fontSize: 18.sp, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 80.w, vertical: 16.h),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ActivityCalendarScreen()), // Navigate to calendar screen
                    );
                  },
                  child: Text(
                    'View Activities Calendar',
                    style: GoogleFonts.lato(
                        fontSize: 16.sp, color: Colors.blueAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to create input fields for activities
  Widget _buildActivityInput({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.blue),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
          ),
        ),
      ],
    );
  }

  void _submitActivities() {
    final String walking = _walkingController.text;
    final String sleep = _sleepController.text;
    final String waterIntake = _waterIntakeController.text;

    if (walking.isNotEmpty && sleep.isNotEmpty && waterIntake.isNotEmpty) {
      final activity = ActivityModel(
        int.parse(walking),
        int.parse(sleep),
        double.parse(waterIntake),
        DateTime.now(), // Capture the current date
      );

      _activityBox.add(activity); // Save to Hive

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Activities logged successfully!')),
      );

      // Clear the input fields
      _walkingController.clear();
      _sleepController.clear();
      _waterIntakeController.clear();


Get.to( ActivityCalendarScreen());
    
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }
}
