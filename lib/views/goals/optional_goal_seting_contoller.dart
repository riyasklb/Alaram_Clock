// import 'package:alaram/views/bottum_nav/bottum_nav_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:hive/hive.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class OptionalGoalSettingController extends GetxController {
//   final List<TextEditingController> medicineNameControllers = [];
//   final List<TextEditingController> medicineDosageControllers = [];
//   final List<String> selectedMedicineTimes = <String>[].obs;
//   final List<bool> medicineVisible =
//       []; // Track visibility for each medicine input
//   List<String?> medicineFrequency = [];
//   List<String?> injectionFrequency = [];
//   final List<TextEditingController> injectionNameControllers = [];
//   final List<TextEditingController> injectionDosageControllers = [];
//   final List<String> selectedInjectionTimes = <String>[].obs;
//   final List<bool> injectionVisible =
//       []; // Track visibility for each injection input
// bool showAddMedicineButton = false;
// bool showAddinjectionButton = false;
//   bool enableBreakfast = false;
//   bool enableLunch = false;
//   bool enableDinner = false;

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Frequency options
//   final List<String> medicineFrequencies = [
//     'Daily',
//     'Every 2 Days',
//     'Every 3 Day',
//     'Weekly',
//     'Every 2 Weeks'
//   ];
//   final List<String> injectionFrequencies = [
//     'Daily',
//     'Every 2 Days',
//     'Every 3 Day',
//     'Weekly',
//     'Every 2 Weeks'
//   ];

//   @override
//   void onInit() {
//     super.onInit();
//     initializeNotifications();
//     addNewMedicine();
//     addNewInjection();
//   }

//   @override
//   void onClose() {
//     medicineNameControllers.forEach((controller) => controller.dispose());
//     medicineDosageControllers.forEach((controller) => controller.dispose());
//     injectionNameControllers.forEach((controller) => controller.dispose());
//     injectionDosageControllers.forEach((controller) => controller.dispose());
//     super.onClose();
//   }



//   Future<void> initializeNotifications() async {
//     tz.initializeTimeZones();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'your_channel_id',
//       'your_channel_name',
//       description: 'your_channel_description',
//       importance: Importance.max,
//       playSound: true,
//       enableVibration: true,
//     );

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   void scheduleReminder(String time, {bool isInjection = false}) {
//     DateTime now = DateTime.now();
//     DateTime scheduledTime;
//     List<String> parts = time.split(':');
//     int hour = int.parse(parts[0]);
//     int minute = int.parse(parts[1]);
//     scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

//     if (scheduledTime.isBefore(now)) {
//       scheduledTime = scheduledTime.add(Duration(days: 1));
//     }

//     final tzDateTime = tz.TZDateTime.from(scheduledTime, tz.local);
//     flutterLocalNotificationsPlugin.zonedSchedule(
//       isInjection ? 1 : 0,
//       'Health Reminder',
//       isInjection ? 'Time for your injection!' : 'Time to take your medicine!',
//       tzDateTime,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'your_channel_id',
//           'your_channel_name',
//           channelDescription: 'your_channel_description',
//           importance: Importance.max,
//           priority: Priority.high,
//           showWhen: false,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

//   void addNewMedicine() {
//     medicineNameControllers.add(TextEditingController());
//     medicineDosageControllers.add(TextEditingController());
//     medicineFrequency.add(null);
//     medicineVisible.add(false);
//     print(showAddMedicineButton);
//     showAddMedicineButton = false; 
//     print('-----------------------------');
//         print(showAddMedicineButton);
//     update();
//   }

//   void addNewInjection() {
//     injectionNameControllers.add(TextEditingController());
//     injectionDosageControllers.add(TextEditingController());
//     injectionFrequency.add(null);
//     injectionVisible.add(false);
//     showAddinjectionButton=true;
//     update();
//   }

//   void setMedicineFrequency(String frequency, int index) {
//     if (index < medicineFrequency.length) {
//       medicineFrequency[index] = frequency;
//       update();
//     }
//   }

//   void setInjectionFrequency(String frequency, int index) {
//     if (index < injectionFrequency.length) {
//       injectionFrequency[index] = frequency;
//       update();
//     }
//   }
//   Future<void> saveOptionalGoals() async {
//     final box = await Hive.openBox('goalBox');

//     // Save multiple medicines
//     for (int i = 0; i < medicineNameControllers.length; i++) {
//       String name = medicineNameControllers[i].text;
//       String dosage = medicineDosageControllers[i].text;
//       if (name.isNotEmpty &&
//           dosage.isNotEmpty &&
//           selectedMedicineTimes.isNotEmpty &&
//           medicineFrequency != null) {
//         final medicineTask = {
//           'name': name,
//           'times': selectedMedicineTimes,
//           'frequency': medicineFrequency,
//           'dosage': dosage,
//         };
//         await box.put('medicineTask_$i', medicineTask);

//         for (String time in selectedMedicineTimes) {
//           scheduleReminder(time);
//         }
//       }
//     }

//     // Save multiple injections
//     for (int i = 0; i < injectionNameControllers.length; i++) {
//       String name = injectionNameControllers[i].text;
//       String dosage = injectionDosageControllers[i].text;
//       if (name.isNotEmpty &&
//           dosage.isNotEmpty &&
//           selectedInjectionTimes.isNotEmpty &&
//           injectionFrequency != null) {
//         final injectionTask = {
//           'name': name,
//           'times': selectedInjectionTimes,
//           'frequency': injectionFrequency,
//           'dosage': dosage,
//         };
//         await box.put('injectionTask_$i', injectionTask);

//         for (String time in selectedInjectionTimes) {
//           scheduleReminder(time, isInjection: true);
//         }
//       }
//     }

//     // Food intake is optional and doesn’t need validation
//     final foodIntakeTask = {
//       'enableBreakfast': enableBreakfast,
//       'enableLunch': enableLunch,
//       'enableDinner': enableDinner,
//     };
//     await box.put('foodIntakeTask', foodIntakeTask);

//     // Schedule general reminder one minute after submission
//     DateTime now = DateTime.now().add(Duration(minutes: 1));
//     String reminderTime =
//         "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
//     scheduleReminder(reminderTime);

//     Get.snackbar('Success', 'Tasks saved successfully!',
//         snackPosition: SnackPosition.BOTTOM);
//     Get.offAll(BottumNavBar());
//   }
// }
