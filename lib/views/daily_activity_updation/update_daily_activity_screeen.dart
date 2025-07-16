import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/controllers/activity_controller.dart';
import 'package:alaram/tools/model/activity_log.dart';
import 'package:alaram/views/home/home_screen.dart';
import 'package:alaram/tools/cutomwidget/cutom_home_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class UpdateYourDailyActivityScreen extends StatefulWidget {
  @override
  _UpdateYourDailyActivityScreenState createState() =>
      _UpdateYourDailyActivityScreenState();
}

class _UpdateYourDailyActivityScreenState
    extends State<UpdateYourDailyActivityScreen> {

        final ActivityController _activityController = Get.put(ActivityController());
  final TextEditingController sleepController = TextEditingController();
  final TextEditingController walkingController = TextEditingController();
  final TextEditingController waterController = TextEditingController();
   final TextEditingController additionalInfoController  = TextEditingController();

  DateTime selectedDate =
      DateTime.now().subtract(Duration(days: 1)); // Default to yesterday's date
  bool hasPendingUpdate = false;
  String? pendingDate;

  @override
  void initState() {
    super.initState();
    _checkPendingUpdates();
  }

  void _checkPendingUpdates() async {
    var box = Hive.box<ActivityLog>('activityLogs');

    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));
    DateTime dayBeforeYesterday = now.subtract(Duration(days: 2));
    DateTime threeDaysAgo = now.subtract(Duration(days: 3));

    DateTime normalizedYesterday =
        DateTime(yesterday.year, yesterday.month, yesterday.day);
    DateTime normalizedDayBeforeYesterday = DateTime(dayBeforeYesterday.year,
        dayBeforeYesterday.month, dayBeforeYesterday.day);
    DateTime normalizedThreeDaysAgo =
        DateTime(threeDaysAgo.year, threeDaysAgo.month, threeDaysAgo.day);

    String formattedYesterday =
        DateFormat('MMMM dd, yyyy').format(normalizedYesterday);
    String formattedDayBeforeYesterday =
        DateFormat('MMMM dd, yyyy').format(normalizedDayBeforeYesterday);
    String formattedThreeDaysAgo =
        DateFormat('MMMM dd, yyyy').format(normalizedThreeDaysAgo);

    bool hasEntryForYesterday = box.values.any((log) {
      DateTime normalizedLogDate =
          DateTime(log.date.year, log.date.month, log.date.day);
      return normalizedLogDate.isAtSameMomentAs(normalizedYesterday);
    });

    bool hasEntryForDayBeforeYesterday = box.values.any((log) {
      DateTime normalizedLogDate =
          DateTime(log.date.year, log.date.month, log.date.day);
      return normalizedLogDate.isAtSameMomentAs(normalizedDayBeforeYesterday);
    });

    bool hasEntryForThreeDaysAgo = box.values.any((log) {
      DateTime normalizedLogDate =
          DateTime(log.date.year, log.date.month, log.date.day);
      return normalizedLogDate.isAtSameMomentAs(normalizedThreeDaysAgo);
    });

    if (!hasEntryForYesterday &&
        !hasEntryForDayBeforeYesterday &&
        !hasEntryForThreeDaysAgo) {
      pendingDate =
          'Updates for $formattedYesterday, $formattedDayBeforeYesterday, and $formattedThreeDaysAgo are pending';
    } else if (!hasEntryForYesterday && !hasEntryForDayBeforeYesterday) {
      pendingDate =
          'Updates for $formattedYesterday and $formattedDayBeforeYesterday are pending';
    } else if (!hasEntryForYesterday && !hasEntryForThreeDaysAgo) {
      pendingDate =
          'Updates for $formattedYesterday and $formattedThreeDaysAgo are pending';
    } else if (!hasEntryForDayBeforeYesterday && !hasEntryForThreeDaysAgo) {
      pendingDate =
          'Updates for $formattedDayBeforeYesterday and $formattedThreeDaysAgo are pending';
    } else if (!hasEntryForYesterday) {
      pendingDate = 'Update for $formattedYesterday is pending';
    } else if (!hasEntryForDayBeforeYesterday) {
      pendingDate = 'Update for $formattedDayBeforeYesterday is pending';
    } else if (!hasEntryForThreeDaysAgo) {
      pendingDate = 'Update for $formattedThreeDaysAgo is pending';
    } else {
      pendingDate = 'No pending updates'; // No pending updates message
    }

    hasPendingUpdate = pendingDate != 'No pending updates';
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
  child: ListView(
    children: [
      Column(
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
            )
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                kheight40,
                kheight40,
                kheight40,
                Center(
                  child: Text(
                    'No update pending, you can update tomorrow.',
                    style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          if (hasPendingUpdate) ...[
            Text(
              'Update your yesterday activities to keep track of your daily progress.',
              style: GoogleFonts.roboto(
                  fontSize: 16.sp, color: Colors.grey[700]),
            ),
            SizedBox(height: 20.h),
            _buildDateSelector(),
            _buildActivityCard(
                'Sleep', 'Hours of sleep', 'hours', sleepController),
            _buildActivityCard(
                'Walking', 'Hours walked', 'hours', walkingController),
            _buildActivityCard(
                'Water Intake', 'Liters of water', 'liters', waterController),
            Card(
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
                      'Additional Information (optional)',
                      style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: additionalInfoController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter any notes or comments...',
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
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
                  style: GoogleFonts.lato(
                      fontSize: 18.sp, color: Colors.white),
                ),
              ),
            ),
          ],
          SizedBox(height: 20),
          CustomHomeButton(),
        ],
      ),
    ],
  ),
)

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

    // Validation: Prevent duplicate entry for the same date
    bool alreadyExists = box.values.any((log) {
      DateTime logDate = DateTime(log.date.year, log.date.month, log.date.day);
      return logDate.isAtSameMomentAs(normalizedDate);
    });
    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You have already updated your activity for this date.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final activityLog = ActivityLog(
      date: normalizedDate,
      sleepHours: sleep,
      walkingHours: walking,
      waterIntake: water,
      additionalInformation: additionalInfoController.text
    );

    await box.add(activityLog);

    // Clear the inputs after saving
    sleepController.clear();
    walkingController.clear();
    waterController.clear();

    Get.to(HomeScreen());
    _activityController.update();
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
                    EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
