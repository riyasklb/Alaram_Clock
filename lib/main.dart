import 'package:alaram/tools/constans/model/daily_activity_model.dart';
import 'package:alaram/tools/constans/model/goal_model.dart';

import 'package:alaram/tools/constans/model/profile_model.dart';
import 'package:alaram/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
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
