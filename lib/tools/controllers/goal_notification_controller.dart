import 'package:alaram/tools/model/goal_model.dart';
import 'package:alaram/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var enableBreakfast = false.obs;
  var enableLunch = false.obs;
  var enableDinner = false.obs;
  var medicines = <Map<String, dynamic>>[].obs;

  NotificationController() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));  // Set IST explicitly
  }

  @override
  void onInit() {
    super.onInit();
    initializeNotifications();
    addMedicine();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) async {
        final String? payload = response.payload;
        if (payload != null) {
          debugPrint('Notification payload: $payload');
        }
      },
    );
  }

  void scheduleGoalNotifications(Goal goal) {
    // Schedule daily notifications for breakfast, lunch, and dinner
    if (enableBreakfast.value) {
      scheduleDailyNotification(
        id: goal.goalId + 100,
        title: "Breakfast Reminder",
        body: "Time for your breakfast!",
        hour: 8,
      );
    }
    if (enableLunch.value) {
      scheduleDailyNotification(
        id: goal.goalId + 200,
        title: "Lunch Reminder",
        body: "Time for your lunch!",
        hour: 12,
      );
    }
    if (enableDinner.value) {
      scheduleDailyNotification(
        id: goal.goalId + 300,
        title: "Dinner Reminder",
        body: "Time for your dinner!",
        hour: 18,
      );
    }

    // Schedule meal reminders based on goal.MealValue
    if (goal.MealValue != null) {
      if (goal.MealValue!.morning == true) {
        scheduleDailyNotification(
          id: goal.goalId + 400,
          title: "Morning Meal Reminder",
          body: "Time for your morning meal!",
          hour: 8,
        );
      }
      if (goal.MealValue!.afternoon == true) {
        scheduleDailyNotification(
          id: goal.goalId + 500,
          title: "Afternoon Meal Reminder",
          body: "Time for your afternoon meal!",
          hour: 12,
        );
      }
      if (goal.MealValue!.evening == true) {
        scheduleDailyNotification(
          id: goal.goalId + 600,
          title: "Evening Meal Reminder",
          body: "Time for your evening meal!",
          hour: 18,
        );
      }
      if (goal.MealValue!.night == true) {
        scheduleDailyNotification(
          id: goal.goalId + 700,
          title: "Night Meal Reminder",
          body: "Time for your night meal!",
          hour: 21,
        );
      }
    }

    // Schedule notifications for medicines if provided
    if (goal.medicines != null) {
      for (var medicine in goal.medicines!) {
        for (var selectedTime in medicine.selectedTimes) {
          int hour = _getHourForTime(selectedTime);
          scheduleMedicineNotification(goal.goalId, medicine, hour);
        }
      }
    }
  }

  void scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
  }) {
    var now = tz.TZDateTime.now(tz.getLocation('Asia/Kolkata'));
    var scheduleTime = tz.TZDateTime(tz.getLocation('Asia/Kolkata'), now.year, now.month, now.day, hour);

    // Make sure the notification is scheduled for the same time every day
    var androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      platformDetails,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    print('Scheduled daily notification: $title at $scheduleTime');
  }

  void scheduleMedicineNotification(int goalId, Medicine medicine, int hour) {
    var now = tz.TZDateTime.now(tz.getLocation('Asia/Kolkata'));
    var scheduleTime = tz.TZDateTime(tz.getLocation('Asia/Kolkata'), now.year, now.month, now.day, hour);

    var androidDetails = AndroidNotificationDetails(
      'medicine_reminder_channel',
      'Medicine Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);

    switch (medicine.frequencyType.toLowerCase()) {
      case 'daily':
        flutterLocalNotificationsPlugin.zonedSchedule(
          goalId + medicine.hashCode,
          'Medicine Reminder: ${medicine.name}',
          'Time to take your medicine: ${medicine.dosage}',
          scheduleTime,
          platformDetails,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.time,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
        print('Scheduled daily notification for ${medicine.name} at $scheduleTime');
        break;

      case 'every other day':
        for (int i = 0; i < 30; i += 2) {
          var notificationTime = scheduleTime.add(Duration(days: i));
          flutterLocalNotificationsPlugin.zonedSchedule(
            goalId + medicine.hashCode + i,
            'Medicine Reminder: ${medicine.name}',
            'Time to take your medicine: ${medicine.dosage}',
            notificationTime,
            platformDetails,
            androidAllowWhileIdle: true,
            matchDateTimeComponents: DateTimeComponents.time,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
          print('Scheduled every-other-day notification for ${medicine.name} at $notificationTime');
        }
        break;

      case 'weekly':
        for (int i = 0; i < 4; i++) {
          var notificationTime = scheduleTime.add(Duration(days: i * 7));
          flutterLocalNotificationsPlugin.zonedSchedule(
            goalId + medicine.hashCode + i,
            'Medicine Reminder: ${medicine.name}',
            'Time to take your medicine: ${medicine.dosage}',
            notificationTime,
            platformDetails,
            androidAllowWhileIdle: true,
            matchDateTimeComponents: DateTimeComponents.time,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
          print('Scheduled weekly notification for ${medicine.name} at $notificationTime');
        }
        break;

      default:
        print('Invalid frequency type for ${medicine.name}');
        break;
    }
  }

  int _getHourForTime(String time) {
    switch (time.toLowerCase()) {
      case 'morning':
        return 8;
      case 'afternoon':
        return 12;
      case 'evening':
        return 18;
      case 'night':
        return 21;
      default:
        return 9;
    }
  }

  void addMedicine() {
    medicines.add({
      'name': null,
      'quantityController': TextEditingController(),
      'selectedTimes': <String>[],
      'frequency': null,
      'dosageController': TextEditingController(),
    });
  }

  void updateMedicineName(int index, String? name) {
    medicines[index]['name'] = name;
    medicines.refresh();
  }

  void updateSelectedTimes(int index, List<String> selectedTimes) {
    medicines[index]['selectedTimes'] = selectedTimes;
    medicines.refresh();
  }

  void updateFrequency(int index, String? frequency) {
    medicines[index]['frequency'] = frequency;
    medicines.refresh();
  }

  void removeMedicine(int index) {
    medicines.removeAt(index);
  }

  void saveOptionalGoals(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() ?? false) {
      final box = await Hive.openBox<Goal>('goals');
      List<Medicine> medicinesData = medicines.map((medicine) {
        return Medicine(
          name: medicine['name'] ?? 'Unnamed Medicine',
          frequencyType: medicine['frequency'] ?? 'daily',
          dosage: medicine['dosageController'].text,
          quantity: int.tryParse(medicine['quantityController'].text) ?? 1,
          selectedTimes: List<String>.from(medicine['selectedTimes']),
        );
      }).toList();

      Goal goal = Goal(
        goalId: 1,
        goalType: "Optional",
        date: DateTime.now(),
        MealValue: Meal(
          morning: enableBreakfast.value,
          afternoon: enableLunch.value,
          night: enableDinner.value,
        ),
        medicines: medicinesData,
      );

         await box.put(goal.goalId, goal);
   scheduleGoalNotifications(goal);
      Get.off(() =>  HomeScreen());
      Get.snackbar('Success', 'Goals saved successfully');
    }
     
  }

  void scheduleSpecificTimeNotification() async {
    // Initialize time zone
 //   initializeTimeZones();

    var androidDetails = AndroidNotificationDetails(
      'specific_time_channel',
      'Specific Time Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);

    // Get the current time in IST
    var now = tz.TZDateTime.now(tz.getLocation('Asia/Kolkata'));
    var targetTime = tz.TZDateTime(
      tz.getLocation('Asia/Kolkata'),
      now.year,
      now.month,
      now.day,
      16, // Hours in IST
      00, // Minutes in IST
    );

    // If the target time has passed for today, schedule for the next day
    if (targetTime.isBefore(now)) {
      targetTime = targetTime.add(Duration(days: 1));
    }

    // Debug output for current and target times
    debugPrint("Device Current Time (IST): $now");
    debugPrint("Scheduled Target Time (IST): $targetTime");

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        DateTime.now().millisecondsSinceEpoch.remainder(100000), // Unique ID
        'Specific Time Reminder',
        'This is your reminder for ${targetTime.hour}:${targetTime.minute} on ${targetTime.year}-${targetTime.month}-${targetTime.day}',
        targetTime,
        platformDetails,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      );
      debugPrint("Notification scheduled successfully for $targetTime");
    } catch (e) {
      debugPrint("Error scheduling notification: $e");
    }
  }

  

  void testNotification() {
  var androidDetails = AndroidNotificationDetails(
    'test_channel',
    'Test Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );
  var platformDetails = NotificationDetails(android: androidDetails);

  var now = tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)); // 5 seconds from now

  flutterLocalNotificationsPlugin.zonedSchedule(
    2000, // Unique ID
    'Test Reminder',
    'This is a test notification.',
    now,
    platformDetails,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );

  print('Scheduled test notification at $now');
}
}
