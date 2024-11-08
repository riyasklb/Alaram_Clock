import 'package:alaram/tools/model/activity_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';


class DailyActivitySleepUpadateScreen extends StatelessWidget {
  // TextEditingControllers to capture user input
  final TextEditingController sleepController = TextEditingController();
  final TextEditingController walkingController = TextEditingController();
  final TextEditingController waterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily Activity Tracker',
          style: GoogleFonts.lato(fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildActivityCard('Sleep', 'Hours of sleep', 'hours', sleepController),
            _buildActivityCard('Walking', 'Hours walked', 'hours', walkingController),
            _buildActivityCard('Water Intake', 'Liters of water', 'liters', waterController),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveActivityLog,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Update Activities',
                  style: GoogleFonts.lato(fontSize: 18.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to store the data in Hive
  void saveActivityLog() async {
    var sleep = double.tryParse(sleepController.text) ?? 0.0;
    var walking = double.tryParse(walkingController.text) ?? 0.0;
    var water = double.tryParse(waterController.text) ?? 0.0;

    var box = Hive.box<ActivityLog>('activityLogs');
    final activityLog = ActivityLog(
      date: DateTime.now(),
      sleepHours: sleep,
      walkingHours: walking,
      waterIntake: water,
    );

    await box.add(activityLog);

    // Optionally, clear the inputs after saving
    sleepController.clear();
    walkingController.clear();
    waterController.clear();

    // Optionally, show a confirmation message
    print('Activity log saved!');
  }

  Widget _buildActivityCard(String title, String hint, String unit, TextEditingController controller) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.grey),
                suffixText: unit,
                suffixStyle: GoogleFonts.roboto(fontSize: 16.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
