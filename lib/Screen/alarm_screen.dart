import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart'; // Import for sound control
import 'package:provider/provider.dart';
import '../Provider/Provier.dart'; // Adjust the import path accordingly

class AlarmStopScreen extends StatelessWidget {
  final int notificationId; // Add notificationId as a parameter

  const AlarmStopScreen({super.key, required this.notificationId});

  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Alarm Ringing!',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Icon(
              Icons.alarm,
              color: Colors.white,
              size: 100,
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Stop Button
                ElevatedButton(
                  onPressed: () async {
                    // Stop the alarm by canceling the notification
                    context.read<alarmprovider>().CancelNotification(notificationId); // Use the passed notificationId

                  

                    // After stopping the alarm, close the screen
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Stop Alarm',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Snooze Button
                ElevatedButton(
                  onPressed: () {
                    // Handle Snooze Logic (e.g., reschedule the alarm for 5 minutes later)
                   context.read<alarmprovider>().CancelNotification(notificationId);
                    // Stop the sound for now, but reschedule it for later
                 
                    Navigator.pop(context); // Close the AlarmStopScreen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Snooze',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
