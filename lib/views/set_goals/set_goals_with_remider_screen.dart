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
  List<Map<String, dynamic>> medicines = [];
  List<String> selectedMedicineTimes = [];
  String? selectedMedicineName;
  String? medicineFrequency;

  bool enableBreakfast = false;
  bool enableLunch = false;
  bool enableDinner = false;
  final _formKey = GlobalKey<FormState>();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TextEditingController medicineQuantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeNotifications(); // Initialize notifications on startup
  }

  @override
  void dispose() {
    medicineDosageController.dispose();

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
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void scheduleReminder(String time) {
    // Convert time String to DateTime
    DateTime now = DateTime.now();
    DateTime scheduledTime;

    // Parse the time string and create a DateTime object for today
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

    // Check if the scheduled time is in the past; if so, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }

    // Convert DateTime to TZDateTime
    final tzDateTime = tz.TZDateTime.from(scheduledTime, tz.local);

    // Schedule the notification
    flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Unique ID for the notification
      'Health Reminder', // Notification title
      'Time to take your medicine!', // Notification body
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

      // Prepare medicines data as a list of maps
      List<Map<String, dynamic>> medicinesData = medicines.map((medicine) {
        return {
          'name': medicine['name'],
          'quantity': medicine['quantityController'].text,
          'times': medicine['selectedTimes'],
          'frequency': medicine['frequency'],
          'dosage': medicine['dosageController'].text,
        };
      }).toList();

      // Save medicines data to the box
      await box.put('medicines', medicinesData);

      // Save additional data to the box
      await box.put('enableBreakfast', enableBreakfast);
      await box.put('enableLunch', enableLunch);
      await box.put('enableDinner', enableDinner);

      // Schedule notifications for each medicine entry
      for (var medicine in medicinesData) {
        for (String time in medicine['times']) {
          String mappedTime =
              timeMapping[time] ?? '08:00'; // Default to 8 AM if not found
          scheduleReminder(mappedTime); // Schedule for mapped time
        }
      }

      // Schedule a notification one minute after submission
      DateTime now = DateTime.now().add(Duration(minutes: 1));
      String reminderTime =
          "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
      scheduleReminder(
          reminderTime); // Schedule notification for 1 minute later

      // Show a success message and navigate to the next screen
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
                fontSize: 22.sp, fontWeight: FontWeight.bold, color: kwhite),
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDropdownField(
                            label: 'Medicine Name',
                            value: medicines[index]['name'],
                            items: <String>[
                              'Paracetamol',
                              'Ibuprofen',
                              'Aspirin',
                              'Amoxicillin'
                            ], // Specify List<String>
                            onChanged: (String? val) =>
                                setState(() => medicines[index]['name'] = val),
                          ),
                          _buildTextField(
                            controller: medicines[index]['quantityController'],
                            labelText: 'Quantity (e.g., 10 tablets)',
                            validator: (value) =>
                                value!.isEmpty ? 'Enter quantity' : null,
                          ),
                          _buildMultiSelectChip(
                            label: 'Select Medicine Times',
                            items: <String>[
                              'Morning',
                              'Afternoon',
                              'Evening',
                              'Night'
                            ],
                            selectedItems: medicines[index]['selectedTimes']
                                as List<String>,
                            onSelectionChanged: (List<String> selectedList) {
                              setState(() => medicines[index]['selectedTimes'] =
                                  selectedList);
                            },
                          ),
                          _buildDropdownField(
                            label: 'Frequency',
                            value: medicines[index]['frequency'],
                            items: ['Daily', 'Every Other Day', 'Weekly'],
                            onChanged: (val) => setState(
                                () => medicines[index]['frequency'] = val),
                          ),
                          _buildTextField(
                            controller: medicines[index]['dosageController'],
                            labelText: 'Dosage (e.g., 1 tablet)',
                            validator: (value) =>
                                value!.isEmpty ? 'Enter dosage amount' : null,
                          ),
                          if (index > 0)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    medicines.removeAt(index);
                                  });
                                },
                                child: Text('Remove Medicine'),
                              ),
                            ),
                          SizedBox(height: 20.h),
                        ],
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        medicines.add({
                          'name': null,
                          'quantityController': TextEditingController(),
                          'selectedTimes': <String>[],
                          'frequency': null,
                          'dosageController': TextEditingController(),
                        });
                      });
                    },
                    child: Text('Add Another Medicine'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: Text('Skip'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
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
