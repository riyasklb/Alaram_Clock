import 'package:alaram/tools/dummy/dummy_initial_screen.dart';
import 'package:alaram/views/auth/register_screen.dart';
import 'package:alaram/views/home/home_screen.dart';
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

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isVisible = true);
    });
  }

  Future<void> _checkRegistrationStatus() async {
    final settingsBox = Hive.box('settingsBox');
    final bool isRegistered = settingsBox.get('isRegistered', defaultValue: false);

    await Future.delayed(const Duration(seconds: 3));
    isRegistered ?
     Get.offAll(() => HomeScreen())
      : Get.offAll(() => RegisterScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.blueAccent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: _isVisible ? 1.0 : 0.0,
                      duration: const Duration(seconds: 1),
                      child: Image.asset(
                        'assets/logo/veterinarian.png',
                        height: 150.h,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    AnimatedOpacity(
                      opacity: _isVisible ? 1.0 : 0.0,
                      duration: const Duration(seconds: 1),
                      child: Text(
                        "Thrombosis App",
                        style: GoogleFonts.poppins(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    AnimatedOpacity(
                      opacity: _isVisible ? 1.0 : 0.0,
                      duration: const Duration(seconds: 2),
                      child: Text(
                        "Empowering Your Health Journey",
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
