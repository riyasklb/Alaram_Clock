import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/controllers/goal_notification_controller.dart';
import 'package:alaram/tools/model/activity_log.dart';
import 'package:alaram/tools/model/clinical_visit_model.dart';
import 'package:alaram/tools/model/daily_activity_model.dart';
import 'package:alaram/tools/model/goal_model.dart';

import 'package:alaram/tools/model/profile_model.dart';
import 'package:alaram/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
   Get.put(NotificationController());
  // Ensure the Flutter bindings are initialized before running any app code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local notifications
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();

  // Initialize Hive
  await Hive.initFlutter();
  tz.initializeTimeZones();

  // Register Hive adapters

  Hive.registerAdapter(ProfileModelAdapter());
  Hive.registerAdapter(DailyActivityModelAdapter());
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(MedicineAdapter());
  Hive.registerAdapter(MealAdapter());
   Hive.registerAdapter(DailyMedicineAdapter());
Hive.registerAdapter(DailyactivityMealValueAdapter());
 Hive.registerAdapter(ActivityLogAdapter());
 Hive.registerAdapter(ClinicalVisitAdapter());
  await Hive.openBox<ClinicalVisit>('clinical_visits'); // Register the new adapter
  await Hive.openBox<ActivityLog>(sleepactivitys);
  await Hive.openBox<DailyActivityModel>('dailyActivities');

  await Hive.openBox<ProfileModel>('profileBox');
  await Hive.openBox<Goal>('goals');
  await Hive.openBox('settingsBox');

  runApp(const MyApp());
}

// Function to initialize notifications

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(500, 800), // Set the base design size
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme:
                GoogleFonts.poppinsTextTheme(), // Apply Google Fonts globally
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(), // Start with SplashScreen
        );
      },
    );
  }
}
