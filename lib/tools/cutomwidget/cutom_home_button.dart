import 'package:alaram/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHomeButton extends StatelessWidget {
  const CustomHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
   
    return ElevatedButton(
      onPressed: () {
        Get.offAll(
            () => HomeScreen()); // Replace with your actual HomeScreen widget
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Text(
        'Home',
        style: GoogleFonts.poppins(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
  }
