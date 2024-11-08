

import 'package:alaram/tools/model/profile_model.dart';



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';


class ActivityMainPage extends StatefulWidget {
  @override
  State<ActivityMainPage> createState() => _ActivityMainPageState();
}

class _ActivityMainPageState extends State<ActivityMainPage> {
  // late Box<ActivityModel> _activityBox;

  @override
  void initState() {
    super.initState();
    //   _activityBox = Hive.box<ActivityModel>('activityBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(onTap: () {}, child: _buildProfileCard()),
              SizedBox(height: 20.h),
              _buildActivityGrid(),
            ],
          ),
        ),
      ),
    );
  }


  AppBar _buildCustomAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),
          ),
        ),
      ),
      toolbarHeight: 80.h,
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Activity ',
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: 'Overview',
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      elevation: 10,
      shadowColor: Colors.blueAccent.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
    );
  }

  // Profile Card at the top of the screen
  Widget _buildProfileCard() {
    final profileBox = Hive.box<ProfileModel>('profileBox');
    final ProfileModel? profileData = profileBox.get('userProfile');
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.r,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: Colors.blue,
                size: 50.r,
              ),
            ),
            SizedBox(width: 20.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileData?.username ?? 'Guest User',
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Height: 182 cm  |  Weight: 76 kg',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityGrid() {
    List<String> activities = [
      'Water Intake',
      'Walking',
      'Sleep',
      'Food Intake',
      'Medicine',
      'Injection', // Updated from Running to Injection
    ];

    List<Color> colors = [
      Colors.lightBlueAccent,
      Colors.greenAccent,
      Colors.deepPurpleAccent,
      Colors.orangeAccent,
      Colors.redAccent,
      Colors.pinkAccent,
    ];

    List<String> values = [
      '4 liters',
      '4 minutes',
      '7 hours',
      'Goal Achived',
      'Not yet',
      'injections Done Today ', // Update this line for injection count
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return _buildActivityCard(
          activities[index],
          values[index],
          colors[index],
        );
      },
    );
  }

  Widget _buildActivityCard(String activity, String value, Color iconColor) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [iconColor.withOpacity(0.2), iconColor.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _getActivityIcon(activity),
                color: iconColor,
                size: 40.r,
              ),
              SizedBox(height: 10.h),
              Text(
                activity,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getActivityIcon(String activity) {
    switch (activity) {
      case 'Water Intake':
        return Icons.local_drink; // Icon for water intake
      case 'Walking':
        return Icons.directions_walk; // Icon for walking
      case 'Sleep':
        return Icons.bedtime; // Icon for sleep
      case 'Food Intake':
        return Icons.fastfood; // Icon for food intake
      case 'Medicine':
        return Icons.medical_services; // Icon for medicine
      case 'Injection':
        return Icons.medication; // Custom icon for injection, change if needed
      default:
        return Icons.accessibility; // Default icon
    }
  }
}
