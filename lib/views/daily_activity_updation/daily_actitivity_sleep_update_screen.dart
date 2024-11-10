import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/model/activity_log.dart';
import 'package:alaram/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class DailyActivitySleepUpdateScreen extends StatefulWidget {
  @override
  _DailyActivitySleepUpdateScreenState createState() =>
      _DailyActivitySleepUpdateScreenState();
}
class _DailyActivitySleepUpdateScreenState extends State<DailyActivitySleepUpdateScreen> {
  final TextEditingController sleepController = TextEditingController();
  final TextEditingController walkingController = TextEditingController();
  final TextEditingController waterController = TextEditingController();

  DateTime selectedDate =
      DateTime.now().subtract(Duration(days: 1)); // Default to yesterday's date
  bool hasPendingUpdate = false;

  @override
  void initState() {
    super.initState();
    _checkPendingUpdates();
  }

  String? pendingDate; // Add a variable to store the pending date

void _checkPendingUpdates() async {
  var box = Hive.box<ActivityLog>('activityLogs');

  // Get yesterday and the day before yesterday
  DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
  DateTime dayBeforeYesterday = DateTime.now().subtract(Duration(days: 2));

  // Normalize both dates to ignore time
  DateTime normalizedYesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);
  DateTime normalizedDayBeforeYesterday = DateTime(dayBeforeYesterday.year, dayBeforeYesterday.month, dayBeforeYesterday.day);

  // Check if there's an entry for yesterday or day before yesterday
  bool hasEntryForYesterday = box.values.any((log) {
    DateTime normalizedLogDate = DateTime(log.date.year, log.date.month, log.date.day);
    return normalizedLogDate.isAtSameMomentAs(normalizedYesterday);
  });

  bool hasEntryForDayBeforeYesterday = box.values.any((log) {
    DateTime normalizedLogDate = DateTime(log.date.year, log.date.month, log.date.day);
    return normalizedLogDate.isAtSameMomentAs(normalizedDayBeforeYesterday);
  });

  // Determine the pending status for both dates
  if (!hasEntryForYesterday && !hasEntryForDayBeforeYesterday) {
    pendingDate = 'Both yesterday and the day before yesterday updates are pending';
  } else if (!hasEntryForYesterday) {
    pendingDate = 'Yesterday\'s update is pending';
  } else if (!hasEntryForDayBeforeYesterday) {
    pendingDate = DateFormat('MMMM dd, yyyy').format(normalizedDayBeforeYesterday); // Show date for "Day before yesterday"
  } else {
    pendingDate = null; // No pending updates
  }

  // Set the pending update status
  hasPendingUpdate = pendingDate != null;

  setState(() {});
}


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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasPendingUpdate)
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Text(
                  'You have a pending update for $pendingDate. Please update to keep your activity log complete.',
                  style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500),
                ),
              ),
            Text(
              'Update your activities for the day before yesterday to keep track of your daily progress.',
              style:
                  GoogleFonts.roboto(fontSize: 16.sp, color: Colors.grey[700]),
            ),
            SizedBox(height: 20.h),
            _buildDateSelector(),
            _buildActivityCard(
                'Sleep', 'Hours of sleep', 'hours', sleepController),
            _buildActivityCard(
                'Walking', 'Hours walked', 'hours', walkingController),
            _buildActivityCard(
                'Water Intake', 'Liters of water', 'liters', waterController),
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

  // Widget for date selector
  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.blueAccent, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM dd, yyyy').format(selectedDate),
              style: GoogleFonts.roboto(
                  fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            Icon(Icons.calendar_today, color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  // Function to select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now()
          .subtract(Duration(days: 365)), // Allows selecting up to 1 year ago
      lastDate: DateTime.now()
          .subtract(Duration(days: 1)), // Exclude today and future dates
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to save the activity log
  void saveActivityLog() async {
    var sleep = double.tryParse(sleepController.text) ?? 0.0;
    var walking = double.tryParse(walkingController.text) ?? 0.0;
    var water = double.tryParse(waterController.text) ?? 0.0;

    var box = Hive.box<ActivityLog>('activityLogs');

    // Normalize the date before saving it to Hive
    DateTime normalizedDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    final activityLog = ActivityLog(
      date: normalizedDate,
      sleepHours: sleep,
      walkingHours: walking,
      waterIntake: water,
    );

    await box.add(activityLog);

    // Clear the inputs after saving
    sleepController.clear();
    walkingController.clear();
    waterController.clear();

    Get.to(BottumNavBar());

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Activity log for ${DateFormat('MMMM dd, yyyy').format(selectedDate)} saved!')),
    );
  }

  // Widget for input fields (Sleep, Walking, Water Intake)
  Widget _buildActivityCard(String title, String hint, String unit,
      TextEditingController controller) {
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
                hintStyle:
                    GoogleFonts.roboto(fontSize: 16.sp, color: Colors.grey),
                suffixText: unit,
                suffixStyle: GoogleFonts.roboto(fontSize: 16.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
