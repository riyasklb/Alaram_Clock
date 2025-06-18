import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:alaram/views/chart/chart_screen.dart';
import 'package:alaram/views/daily_activity_updation/callender_daily_task_screen.dart';
import 'package:alaram/views/daily_activity_updation/daily_actitivity_sleep_update_screen.dart';



class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFEEF3F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '',
          style: GoogleFonts.poppins(
            color: Colors.blueAccent,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Optional gradient background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE0F7FA), Color(0xFFEEF3F8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 80),
             //   Lottie animation
                Image.asset(
                  'assets/logo/veterinarian.png', // Replace with your asset
                  height: 220,
                ),
                const SizedBox(height: 24),
                Text(
                  'Manage Your Day',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: _buildGlassButton(
                    label: 'Update Daily Goals',
                    icon: Icons.flag_rounded,
                    onTap: () => Get.to(DailyActivitySleepUpdateScreen()),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  child: _buildGlassButton(
                    label: 'Update Medications',
                    icon: Icons.medication_rounded,
                    onTap: () => Get.to(DailyMedicneTaskCallenderScreen()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24, color: Colors.blueAccent),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
