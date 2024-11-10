import 'package:alaram/tools/dummy/dummy_initial_screen.dart';
import 'package:alaram/views/bottum_nav/bottum_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
    _startAnimation();
  }

  // Initiate the fade-in animation
  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  // Check if the user is registered
  Future<void> _checkRegistrationStatus() async {
    final settingsBox = Hive.box('settingsBox');
    final bool isRegistered = settingsBox.get('isRegistered', defaultValue: false);

    await Future.delayed(const Duration(seconds: 2));

    if (isRegistered) {
      Get.offAll(() => BottumNavBar());
    } else {
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
            // Animated logo
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.8, end: 1.0),
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: const Duration(seconds: 1),
                    child: CircleAvatar(
                      backgroundImage: const AssetImage('assets/logo/index-logo.jpg'),
                      radius: 150.r,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 30.h),
            // Animated app title
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(seconds: 2),
              child: Text(
                "Thrombosis App",
                style: GoogleFonts.poppins(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // Animated subtitle
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(seconds: 2),
              child: Text(
                "Managing Your Health",
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40.h),
            // Pulsating loading indicator
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.8, end: 1.0),
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                );
              },
              onEnd: () {
                // Loop the scaling animation
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {});
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
