import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/constans/model/daily_activity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'auth/register_screen.dart';
import 'package:alaram/tools/constans/model/profile_model.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Box<DailyActivityModel> activityBox = Hive.box('dailyactivities');
    final profileBox = Hive.box<ProfileModel>('profileBox');
    final goalBox = Hive.box('goalBox');
    final settingsBox = Hive.box('settingsBox');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: kwhite,
          ),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(profileBox),
              Divider(thickness: 1, color: Colors.grey[300]),
              SizedBox(height: 20.h),
              _buildSectionTitle('Profile Information'),
              SizedBox(height: 10.h),
              ..._buildProfileCards(profileBox),
              SizedBox(height: 20.h),
              _buildSectionTitle('Goals & Reminders'),
              SizedBox(height: 10.h),
              ..._buildGoalCards(goalBox),
              SizedBox(height: 30.h),
              _buildLogoutButton(
                  context, profileBox, goalBox, settingsBox,activityBox ),
              SizedBox(height: 40.h),
              kheight40,
              kheight40,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Box<ProfileModel> profileBox) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black26, blurRadius: 10.r, offset: Offset(0, 4)),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50.r, color: Colors.blueAccent),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                profileBox.get('userProfile')?.username ?? 'User',
                style: GoogleFonts.poppins(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                profileBox.get('userProfile')?.email ?? 'Email',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildProfileCards(Box<ProfileModel> profileBox) {
    return [
      _buildProfileCard('Username', profileBox.get('userProfile')?.username),
      _buildProfileCard('Email', profileBox.get('userProfile')?.email),
      _buildProfileCard('Age', profileBox.get('userProfile')?.age?.toString()),
      _buildProfileCard('Mobile', profileBox.get('userProfile')?.mobile),
      _buildProfileCard('NHS Number', profileBox.get('userProfile')?.nhsNumber),
      _buildProfileCard('Gender', profileBox.get('userProfile')?.gender),
      _buildProfileCard('Ethnicity', profileBox.get('userProfile')?.ethnicity),
      _buildProfileCard(
          'Water Intake Goal',
          profileBox.get('userProfile')?.waterIntakeGoal?.toString() ??
              'Not Set'),
      _buildProfileCard('Sleep Goal',
          profileBox.get('userProfile')?.sleepGoal?.toString() ?? 'Not Set'),
      _buildProfileCard('Walking Goal',
          profileBox.get('userProfile')?.walkingGoal?.toString() ?? 'Not Set'),
    ];
  }

  List<Widget> _buildGoalCards(Box goalBox) {
    return [
      _buildGoalCard('Medicine Times',
          goalBox.get('medicineTimes')?.toString() ?? 'Not Set'),
      _buildGoalCard('Medicine Frequency',
          goalBox.get('medicineFrequency')?.toString() ?? 'Not Set'),
      _buildGoalCard('Medicine Dosage',
          goalBox.get('medicineDosage')?.toString() ?? 'Not Set'),
      _buildGoalCard('Breakfast Enabled',
          goalBox.get('enableBreakfast') == true ? 'Yes' : 'No'),
      _buildGoalCard(
          'Lunch Enabled', goalBox.get('enableLunch') == true ? 'Yes' : 'No'),
      _buildGoalCard(
          'Dinner Enabled', goalBox.get('enableDinner') == true ? 'Yes' : 'No')
    ];
  }

  Widget _buildProfileCard(String label, String? value) {
    IconData iconData;
    switch (label) {
      case 'Username':
        iconData = Icons.person;
        break;
      case 'Email':
        iconData = Icons.email;
        break;
      case 'Age':
        iconData = Icons.cake;
        break;
      case 'Mobile':
        iconData = Icons.phone;
        break;
      case 'NHS Number':
        iconData = Icons.local_hospital;
        break;
      case 'Gender':
        iconData = Icons.transgender;
        break;
      case 'Ethnicity':
        iconData = Icons.people;
        break;
      case 'Water Intake Goal':
        iconData = Icons.local_drink;
        break;
      case 'Sleep Goal':
        iconData = Icons.bed;
        break;
      case 'Walking Goal':
        iconData = Icons.directions_walk;
        break;
      default:
        iconData = Icons.info; // Default icon for unassigned labels
        break;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 4,
      color: Colors.blue[50],
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(iconData, size: 28.r, color: Colors.blueAccent),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800])),
                  SizedBox(height: 4.h),
                  Text(value ?? 'Not Available',
                      style: GoogleFonts.poppins(
                          fontSize: 16.sp, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(String label, String value) {
    IconData iconData;
    switch (label) {
      case 'Medicine Times':
        iconData = Icons.access_time;
        break;
      case 'Medicine Frequency':
        iconData = Icons.repeat;
        break;
      case 'Medicine Dosage':
        iconData = Icons.healing;
        break;

      case 'Breakfast Enabled':
        iconData = Icons.breakfast_dining;
        break;
      case 'Lunch Enabled':
        iconData = Icons.lunch_dining;
        break;
      case 'Dinner Enabled':
        iconData = Icons.dinner_dining;
        break;
      default:
        iconData = Icons.check_circle_outline;
        break;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 4,
      color: Colors.green[50],
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(iconData, size: 28.r, color: Colors.blueAccent),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800])),
                  SizedBox(height: 4.h),
                  Text(value,
                      style: GoogleFonts.poppins(
                          fontSize: 16.sp, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent),
    );
  }

  Widget _buildLogoutButton(BuildContext context, Box profileBox, Box goalBox,Box settingsBox, Box activitybox) {
    return ElevatedButton(
      onPressed: () => _showLogoutConfirmation(
          context, profileBox, goalBox, settingsBox, activitybox),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        'Logout',
        style: GoogleFonts.poppins(
            fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, Box profileBox,
      Box goalBox, Box settingsBox, Box activitybox) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout and Clear Data'),
          content: Text(
              'Are you sure you want to log out and clear all data? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await profileBox.clear();
                await goalBox.clear();
                await settingsBox.clear();
                await activitybox.clear();
                Get.offAll(() => RegisterScreen());
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: Text('Logout and Clear Data',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
