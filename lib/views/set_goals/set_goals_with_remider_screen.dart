import 'dart:math';

import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/views/bottum_nav/bottum_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../../tools/constans/model/goal_model.dart';

class OptionalGoalSettingScreen extends StatefulWidget {
  @override
  State<OptionalGoalSettingScreen> createState() => _OptionalGoalSettingScreenState();
}

class _OptionalGoalSettingScreenState extends State<OptionalGoalSettingScreen> {
  final TextEditingController medicineDosageController = TextEditingController();
  final List<Map<String, dynamic>> medicines = [];
  bool enableBreakfast = false;
  bool enableLunch = false;
  bool enableDinner = false;

  final _formKey = GlobalKey<FormState>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  @override
  void dispose() {
    for (var medicine in medicines) {
      medicine['quantityController']?.dispose();
      medicine['dosageController']?.dispose();
    }
    super.dispose();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_channel_id',
      'your_channel_name',
      description: 'your_channel_description',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  void scheduleReminder(String time) {
    DateTime now = DateTime.now();
    DateTime scheduledTime;

    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }

    final tzDateTime = tz.TZDateTime.from(scheduledTime, tz.local);

    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Health Reminder',
      'Time to take your medicine!',
      tzDateTime,
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
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _saveOptionalGoals() async {
    if (_formKey.currentState!.validate()) {
      final box = await Hive.openBox<Goal>('goals');

      List<Medicine> medicinesData = medicines.map((medicine) {
        return Medicine(
          name: medicine['name'],
          frequencyType: medicine['frequency'],
          dosage: medicine['dosageController'].text,
          quantity: int.parse(medicine['quantityController'].text),
        );
      }).toList();

      Goal goal = Goal(
        goalId: generateGoalId(),
        goalType: "Optional",
        date: DateTime.now(),
        targetValue: Meal(
          morning: enableBreakfast,
          afternoon: enableLunch,
          night: enableDinner,
        ),
        medicines: medicinesData,
      );

      await box.put(goal.goalId, goal);

      Get.snackbar('Success', 'Optional goals saved successfully!', snackPosition: SnackPosition.BOTTOM);
      Get.to(BottumNavBar());
    }
  }

  int generateGoalId() {
    final random = Random();
    return random.nextInt(0xFFFFFFFF);
  }

  final Map<String, String> timeMapping = {
    'Morning': '08:00',
    'Afternoon': '12:00',
    'Evening': '18:00',
    'Night': '20:00',
  };

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
        actions: [
          TextButton(
            onPressed: () => Get.to(BottumNavBar()),
            child: Text('Skip', style: TextStyle(color: kwhite, fontSize: 16.sp)),
          ),
        ],
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
                    return _buildMedicineInput(index);
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
                _buildToggleSwitch('Enable Breakfast', enableBreakfast, (val) => setState(() => enableBreakfast = val)),
                _buildToggleSwitch('Enable Lunch', enableLunch, (val) => setState(() => enableLunch = val)),
                _buildToggleSwitch('Enable Dinner', enableDinner, (val) => setState(() => enableDinner = val)),

                SizedBox(height: 30.h),
                ElevatedButton(
                  onPressed: _saveOptionalGoals,
                  child: Text('Save Goals', style: TextStyle(fontSize: 18.sp)),
                  style: ElevatedButton.styleFrom(backgroundColor: kblue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineInput(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownField(
          label: 'Medicine Name',
          value: medicines[index]['name'],
          items: <String>['Paracetamol', 'Ibuprofen', 'Aspirin', 'Amoxicillin'],
          onChanged: (String? val) => setState(() => medicines[index]['name'] = val),
        ),
        _buildIntTextField(
          controller: medicines[index]['quantityController'],
          labelText: 'Quantity (e.g., 10 tablets)',
          validator: (value) => value!.isEmpty ? 'Enter quantity' : null,
        ),
        _buildMultiSelectChip(
          label: 'Select Medicine Times',
          items: <String>['Morning', 'Afternoon', 'Evening', 'Night'],
          selectedItems: medicines[index]['selectedTimes'] as List<String>,
          onSelectionChanged: (List<String> selectedList) {
            setState(() => medicines[index]['selectedTimes'] = selectedList);
          },
        ),
        _buildDropdownField(
          label: 'Frequency',
          value: medicines[index]['frequency'],
          items: ['Daily', 'Every Other Day', 'Weekly'],
          onChanged: (val) => setState(() => medicines[index]['frequency'] = val),
        ),
        _buildTextField(
          controller: medicines[index]['dosageController'],
          labelText: 'Dosage (e.g., 1 tablet)',
          validator: (value) => value!.isEmpty ? 'Enter dosage amount' : null,
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
  }

  Widget _buildIntTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        validator: validator,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildMultiSelectChip({
    required String label,
    required List<String> items,
    required List<String> selectedItems,
    required Function(List<String>) onSelectionChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16.sp)),
        Wrap(
          spacing: 8.0,
          children: items.map((item) {
            return FilterChip(
              label: Text(item),
              selected: selectedItems.contains(item),
              onSelected: (selected) {
                selected
                    ? selectedItems.add(item)
                    : selectedItems.remove(item);
                onSelectionChanged(selectedItems);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildToggleSwitch(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16.sp)),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
