import 'dart:math';
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
  final Random _random = Random();

  var enableBreakfast = false.obs;
  var enableLunch = false.obs;
  var enableDinner = false.obs;
  var enableevening = false.obs;
  var medicines = <Map<String, dynamic>>[].obs;

  NotificationController() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
  }

  @override
  void onInit() {
    super.onInit();
    initializeNotifications();
    addMedicine();
  }

  // Generates a 32-bit integer safe for Hive
  int _generate32BitKey() {
    return _random.nextInt(0xFFFFFFFF);
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
        if (response.payload != null) {
          debugPrint('Notification payload: ${response.payload}');
        }
        Get.to(() => HomeScreen());
      },
    );
  }

  void scheduleGoalNotifications(Goal goal) {
    cancelGoalNotifications(goal.goalId);
    
    if (enableBreakfast.value) {
      scheduleDailyNotification(
        id: goal.goalId * 10 + 1,
        title: "Breakfast Reminder",
        body: "Time for your breakfast!",
        hour: 8,
      );
    }
    if (enableLunch.value) {
      scheduleDailyNotification(
        id: goal.goalId * 10 + 2,
        title: "Lunch Reminder",
        body: "Time for your lunch!",
        hour: 12,
      );
    }
    if (enableDinner.value) {
      scheduleDailyNotification(
        id: goal.goalId * 10 + 3,
        title: "Dinner Reminder",
        body: "Time for your dinner!",
        hour: 18,
      );
    }
    if (enableevening.value) {
      scheduleDailyNotification(
        id: goal.goalId * 10 + 4,
        title: "Evening Reminder",
        body: "Time for your evening snack!",
        hour: 16,
      );
    }

    if (goal.MealValue != null) {
      if (goal.MealValue!.morning == true) {
        scheduleDailyNotification(
          id: goal.goalId * 10 + 5,
          title: "Morning Meal Reminder",
          body: "Time for your morning meal!",
          hour: 8,
        );
      }
      if (goal.MealValue!.afternoon == true) {
        scheduleDailyNotification(
          id: goal.goalId * 10 + 6,
          title: "Afternoon Meal Reminder",
          body: "Time for your afternoon meal!",
          hour: 12,
        );
      }
      if (goal.MealValue!.evening == true) {
        scheduleDailyNotification(
          id: goal.goalId * 10 + 7,
          title: "Evening Meal Reminder",
          body: "Time for your evening meal!",
          hour: 18,
        );
      }
      if (goal.MealValue!.night == true) {
        scheduleDailyNotification(
          id: goal.goalId * 10 + 8,
          title: "Night Meal Reminder",
          body: "Time for your night meal!",
          hour: 21,
        );
      }
    }

    if (goal.medicines != null) {
      for (var medicine in goal.medicines!) {
        for (var selectedTime in medicine.selectedTimes) {
          int hour = _getHourForTime(selectedTime);
          scheduleMedicineNotification(
            goal.goalId, 
            medicine, 
            hour, 
            selectedTime
          );
        }
      }
    }
  }

  void cancelGoalNotifications(int goalId) {
    for (int i = 1; i <= 8; i++) {
      flutterLocalNotificationsPlugin.cancel(goalId * 10 + i);
    }
  }

  void scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
  }) {
    final location = tz.getLocation('Asia/Kolkata');
    var now = tz.TZDateTime.now(location);
    var scheduleTime = tz.TZDateTime(location, now.year, now.month, now.day, hour);

    if (scheduleTime.isBefore(now)) {
      scheduleTime = scheduleTime.add(const Duration(days: 1));
    }

    var androidDetails = const AndroidNotificationDetails(
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

    print('✅ Scheduled daily notification: $title at ${scheduleTime.toLocal()}');
  }

  void scheduleMedicineNotification(
    int goalId, 
    Medicine medicine, 
    int hour,
    String selectedTime
  ) {
    final location = tz.getLocation('Asia/Kolkata');
    var now = tz.TZDateTime.now(location);
    var scheduleTime = tz.TZDateTime(location, now.year, now.month, now.day, hour);

    var androidDetails = const AndroidNotificationDetails(
      'medicine_reminder_channel',
      'Medicine Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);

    switch (medicine.frequencyType.toLowerCase()) {
      case 'daily':
        if (scheduleTime.isBefore(now)) {
          scheduleTime = scheduleTime.add(const Duration(days: 1));
        }
        flutterLocalNotificationsPlugin.zonedSchedule(
          _generateMedicineNotificationId(goalId, medicine, selectedTime, 0),
          'Medicine Reminder: ${medicine.name}',
          'Time to take ${medicine.dosage}',
          scheduleTime,
          platformDetails,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.time,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
        print('✅ Scheduled DAILY ${medicine.name} at ${scheduleTime.toLocal()}');
        break;

      case 'every other day':
        int interval = 2;
        int maxOccurrences = 15;
        int count = 0;
        for (int i = 0; count < maxOccurrences; i++) {
          var notificationTime = scheduleTime.add(Duration(days: i * interval));
          if (notificationTime.isBefore(now)) continue;
          
          flutterLocalNotificationsPlugin.zonedSchedule(
            
            _generateMedicineNotificationId(goalId, medicine, selectedTime, count),
            'Medicine Reminder: ${medicine.name}',
            'Time to take ${medicine.dosage}',
            notificationTime,
            platformDetails,
            androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
          count++;
          print('⏱ Scheduled EVERY OTHER DAY ${medicine.name} at ${notificationTime.toLocal()}');
        }
        break;

      case 'weekly':
        int interval = 7;
        int maxOccurrences = 12;
        int count = 0;
        for (int i = 0; count < maxOccurrences; i++) {
          var notificationTime = scheduleTime.add(Duration(days: i * interval));
          if (notificationTime.isBefore(now)) continue;
          
          flutterLocalNotificationsPlugin.zonedSchedule(
            _generateMedicineNotificationId(goalId, medicine, selectedTime, count),
            'Medicine Reminder: ${medicine.name}',
            'Time to take ${medicine.dosage}',
            notificationTime,
            platformDetails,
            androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
          count++;
          print('📅 Scheduled WEEKLY ${medicine.name} at ${notificationTime.toLocal()}');
        }
        break;

      default:
        print('❌ Invalid frequency: ${medicine.frequencyType}');
        break;
    }
  }

  int _generateMedicineNotificationId(
    int goalId, 
    Medicine medicine, 
    String selectedTime, 
    int index
  ) {
    String uniqueKey = '$goalId-${medicine.name}-$selectedTime-$index';
    return uniqueKey.hashCode.abs() % 2147483647;
  }

  int _getHourForTime(String time) {
    switch (time.toLowerCase()) {
      case 'morning': return 8;
      case 'afternoon': return 12;
      case 'evening': return 18;
      case 'night': return 21;
      default: return 9;
    }
  }

  void addMedicine() {
    medicines.add({
      'nameController': TextEditingController(),
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

    // 🧹 Clear all previously saved Goal data
    await box.clear();

    // ⏱ Optional delay
    await Future.delayed(const Duration(milliseconds: 500));

    List<Medicine> medicinesData = medicines.map((medicine) {
      return Medicine(
        name: medicine['nameController'].text,
        frequencyType: medicine['frequency'] ?? 'daily',
        dosage: medicine['dosageController'].text,
        quantity: int.tryParse(medicine['quantityController'].text) ?? 1,
        selectedTimes: List<String>.from(medicine['selectedTimes']),
      );
    }).toList();

    Goal goal = Goal(
      goalId: _generate32BitKey(),
      goalType: "Optional",
      date: DateTime.now(),
      MealValue: Meal(
        morning: enableBreakfast.value,
        afternoon: enableLunch.value,
        evening: enableevening.value,
        night: enableDinner.value,
      ),
      medicines: medicinesData,
    );

    await box.put(goal.goalId, goal);
    scheduleGoalNotifications(goal);
    Get.off(() => HomeScreen());
    Get.snackbar('Success', 'Previous goals cleared and new goal saved');
  }
}



  void scheduleSpecificTimeNotification() async {
    final location = tz.getLocation('Asia/Kolkata');
    var androidDetails = const AndroidNotificationDetails(
      'specific_time_channel',
      'Specific Time Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);

    var now = tz.TZDateTime.now(location);
    var targetTime = tz.TZDateTime(location, now.year, now.month, now.day, 16, 0);

    if (targetTime.isBefore(now)) {
      targetTime = targetTime.add(const Duration(days: 1));
    }

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        _generate32BitKey(),
        'Specific Time Reminder',
        'This is your reminder for ${targetTime.hour}:${targetTime.minute}',
        targetTime,
        platformDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
      debugPrint("✅ Test notification scheduled for ${targetTime.toLocal()}");
    } catch (e) {
      debugPrint("❌ Error: $e");
    }
  }

  var items = <String>[].obs;
  var filteredItems = <String>[].obs;
  var selectedValue = ''.obs;

  void initialize(List<String> values) {
    items.assignAll(values);
    filteredItems.assignAll(values);
  }

  void filterItems(String input) {
    selectedValue.value = input;
    filteredItems.value = items
        .where((item) => item.toLowerCase().contains(input.toLowerCase()))
        .toList();
  }

  void selectItem(String item) {
    selectedValue.value = item;
    filteredItems.assignAll(items);
  }
}