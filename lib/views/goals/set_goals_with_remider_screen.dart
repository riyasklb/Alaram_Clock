import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/views/bottum_nav/bottum_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // Updated import for GetX
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class OptionalGoalSettingScreen extends StatefulWidget {
  @override
  State<OptionalGoalSettingScreen> createState() =>
      _OptionalGoalSettingScreenState();
}

class _OptionalGoalSettingScreenState extends State<OptionalGoalSettingScreen> {
  final TextEditingController medicineDosageController =
      TextEditingController();
  final TextEditingController injectionDosageController =
      TextEditingController();
  List<String> selectedMedicineTimes = [];
  List<String> selectedInjectionTimes = [];
  String? medicineFrequency;
  String? injectionFrequency;
  bool enableBreakfast = false;
  bool enableLunch = false;
  bool enableDinner = false;
  final _formKey = GlobalKey<FormState>();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications(); // Initialize notifications on startup
  }

  @override
  void dispose() {
    medicineDosageController.dispose();
    injectionDosageController.dispose();
    super.dispose();
  }

  Future<void> initializeNotifications() async {
  tz.initializeTimeZones(); // Initialize timezone database

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create a notification channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'your_channel_id', // Use the same ID as in the notification schedule
    'your_channel_name',
    description: 'your_channel_description',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  // Create the channel on the fly
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
}


void scheduleReminder(String time, {bool isInjection = false}) {
  // Convert time String to DateTime
  DateTime now = DateTime.now();
  DateTime scheduledTime;

  // Parse the time string and create a DateTime object for today
  List<String> parts = time.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);
  
  scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);
  
  // Check if the scheduled time is in the past, if so, schedule for tomorrow
  if (scheduledTime.isBefore(now)) {
    scheduledTime = scheduledTime.add(Duration(days: 1));
  }

  // Convert DateTime to TZDateTime
  final tzDateTime = tz.TZDateTime.from(scheduledTime, tz.local);

  // Schedule the notification
  flutterLocalNotificationsPlugin.zonedSchedule(
    isInjection ? 1 : 0, // Use different IDs for medicine and injection
    'Health Reminder', // Notification title
    isInjection
        ? 'Time for your injection!'
        : 'Time to take your medicine!', // Notification body
    tzDateTime, // Scheduled time
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

// Map to convert the time strings to actual hour and minute values
final Map<String, String> timeMapping = {
  'Morning': '08:00',
  'Afternoon': '12:00',
  'Evening': '18:00',
  'Night': '20:00',
};

void _saveOptionalGoals() async {
  if (_formKey.currentState!.validate()) {
    // Save data to Hive or any other database
    final box = await Hive.openBox('goalBox');
    await box.put('medicineTimes', selectedMedicineTimes);
    await box.put('medicineFrequency', medicineFrequency);
    await box.put('medicineDosage', medicineDosageController.text);
    await box.put('injectionTimes', selectedInjectionTimes);
    await box.put('injectionFrequency', injectionFrequency);
    await box.put('injectionDosage', injectionDosageController.text);
    await box.put('enableBreakfast', enableBreakfast);
    await box.put('enableLunch', enableLunch);
    await box.put('enableDinner', enableDinner);

    // Schedule notifications for medicine and injection times
    for (String time in selectedMedicineTimes) {
      String mappedTime = timeMapping[time] ?? '08:00'; // Default to 8 AM if not found
      scheduleReminder(mappedTime); // Pass mapped time for medicine
    }

    for (String time in selectedInjectionTimes) {
      String mappedTime = timeMapping[time] ?? '08:00'; // Default to 8 AM if not found
      scheduleReminder(mappedTime, isInjection: true); // Pass mapped time for injection
    }

    // Schedule a notification one minute after submission
    DateTime now = DateTime.now().add(Duration(minutes: 1));
    String reminderTime = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
    scheduleReminder(reminderTime); // Schedule notification for 1 minute later

    Get.snackbar('Success', 'Optional goals saved successfully!',
        snackPosition: SnackPosition.BOTTOM);
    Get.to(BottumNavBar());
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set Optional Goals',
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,color: kwhite
          ),
        ),
        backgroundColor: kblue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Medicine Intake'),
                _buildMultiSelectChip(
                  label: 'Select Medicine Times',
                  items: ['Morning', 'Afternoon', 'Evening', 'Night'],
                  selectedItems: selectedMedicineTimes,
                  onSelectionChanged: (selectedList) {
                    setState(() => selectedMedicineTimes = selectedList);
                  },
                ),
                _buildDropdownField(
                  label: 'Frequency',
                  value: medicineFrequency,
                  items: ['Daily', 'Twice a Day', 'Thrice a Day'],
                  onChanged: (val) => setState(() => medicineFrequency = val),
                ),
                _buildTextField(
                  controller: medicineDosageController,
                  labelText: 'Dosage (e.g., 1 tablet)',
                  validator: (value) =>
                      value!.isEmpty ? 'Enter dosage amount' : null,
                ),
                SizedBox(height: 20.h),
                _buildSectionHeader('Food Intake'),
                _buildToggleSwitch('Enable Breakfast', enableBreakfast,
                    (val) => setState(() => enableBreakfast = val)),
                _buildToggleSwitch('Enable Lunch', enableLunch,
                    (val) => setState(() => enableLunch = val)),
                _buildToggleSwitch('Enable Dinner', enableDinner,
                    (val) => setState(() => enableDinner = val)),
                SizedBox(height: 20.h),
                _buildSectionHeader('Injection'),
                _buildDropdownField(
                  label: 'Frequency',
                  value: injectionFrequency,
                  items: ['Daily', 'Twice a Day', 'Thrice a Day'],
                  onChanged: (val) => setState(() => injectionFrequency = val),
                ),
                _buildMultiSelectChip(
                  label: 'Select Injection Times',
                  items: ['Morning', 'Afternoon', 'Evening', 'Night'],
                  selectedItems: selectedInjectionTimes,
                  onSelectionChanged: (selectedList) {
                    setState(() => selectedInjectionTimes = selectedList);
                  },
                ),
                _buildTextField(
                  controller: injectionDosageController,
                  labelText: 'Dosage (e.g., 2ml)',
                  validator: (value) =>
                      value!.isEmpty ? 'Enter dosage amount' : null,
                ),
                SizedBox(height: 30.h),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _saveOptionalGoals,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kblue,
                        padding: EdgeInsets.symmetric(
                            horizontal: 80.w, vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Save Goals',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottumNavBar(),
                    ),
                  );
                },
                child: Text('Skip'),
              ),      ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch(
    String label,
    bool value,
    void Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 16.sp),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: kblue,
    );
  }

  Widget _buildMultiSelectChip({
    required String label,
    required List<String> items,
    required List<String> selectedItems,
    required void Function(List<String>) onSelectionChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 16.sp),
          ),
          Wrap(
            spacing: 8.w,
            children: items.map((item) {
              final isSelected = selectedItems.contains(item);
              return ChoiceChip(
                label: Text(item),
                selected: isSelected,
                selectedColor: kblue,
                onSelected: (selected) {
                  setState(() {
                    selected
                        ? selectedItems.add(item)
                        : selectedItems.remove(item);
                  });
                  onSelectionChanged(List.from(selectedItems));
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


}
