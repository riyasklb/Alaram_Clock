import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class GoalSummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Open the goalBox to retrieve the saved data
    final goalBox = Hive.box('goalBox');

    // Get the saved data
    final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final bool hasTakenBreakfast = goalBox.get('hasTakenBreakfast') ?? false;
    final bool hasTakenMorningMedicine = goalBox.get('hasTakenMorningMedicine') ?? false;
    final bool hasTakenNightMedicine = goalBox.get('hasTakenNightMedicine') ?? false;
  
    final double waterProgress = goalBox.get('waterProgress') ?? 0.0;
    final double sleepProgress = goalBox.get('sleepProgress') ?? 0.0;
    final double walkingProgress = goalBox.get('walkingProgress') ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Goal Summary',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary for $currentDate',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildGoalRow('Water Intake', waterProgress),
            _buildGoalRow('Sleep', sleepProgress),
            _buildGoalRow('Walking', walkingProgress),
            SizedBox(height: 20),
            
            Text(
              'Daily Activities',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildActivityRow('Breakfast', hasTakenBreakfast),
            _buildActivityRow('Morning Medicine', hasTakenMorningMedicine),
            _buildActivityRow('Night Medicine', hasTakenNightMedicine),
      
          ],
        ),
      ),
    );
  }

  Widget _buildGoalRow(String label, double progress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 16)),
        Text('${progress.toStringAsFixed(1)}', style: GoogleFonts.poppins(fontSize: 16)),
      ],
    );
  }

  Widget _buildActivityRow(String label, bool isCompleted) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 16)),
        Text(
          isCompleted ? '✅ Completed' : '❌ Not Completed',
          style: GoogleFonts.poppins(fontSize: 16, color: isCompleted ? Colors.green : Colors.red),
        ),
      ],
    );
  }
}
