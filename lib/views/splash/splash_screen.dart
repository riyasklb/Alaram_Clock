import 'package:alaram/tools/dummy/dummy_initial_screen.dart';
import 'package:alaram/views/bottum_nav/bottum_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkRegistrationStatus();
  }

  // Check if the user is registered
  Future<void> _checkRegistrationStatus() async {
    final settingsBox = Hive.box('settingsBox'); // Separate box for settings/flags
    final bool isRegistered = settingsBox.get('isRegistered', defaultValue: false);

    // Delay for 3 seconds before navigating
    await Future.delayed(const Duration(seconds: 3));

    if (isRegistered) {
      // Navigate to BottomNavBar if registered
      Get.offAll(() => BottumNavBar());
    } else {
      // Navigate to RegisterScreen if not registered
      Get.offAll(() => DummyHomeScreen());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Section
            CircleAvatar(
              backgroundImage: AssetImage('assets/logo/index-logo.jpg'),
              radius: 150.r,
            ),
            SizedBox(height: 30.h),
            // App Title
            Text(
              "Thrombosis App",
              style: GoogleFonts.poppins(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 12.h),
            // Subtitle
            Text(
              "Managing Your Health",
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            // Loading Indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
