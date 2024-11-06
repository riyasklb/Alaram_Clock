import 'package:alaram/tools/constans/color.dart';

import 'package:alaram/tools/constans/model/profile_model.dart';

import 'package:alaram/views/callender/callender_acreen.dart';
import 'package:alaram/views/daily_goals/daily_activity_overview_screen.dart';
import 'package:alaram/views/daily_goals/saved_callender.dart';
import 'package:alaram/views/daily_goals/saved_screen.dart';
import 'package:alaram/views/profile_screen.dart';



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
 // Calendar package


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              InkWell(onTap: (){
                Get.to( Get.to(SavedCallenderScreen()));
              },
                child: _buildDateTimeSection()), kheight10,
              InkWell(onTap:(){
              //  Get.to(DailyProgressScreen());
                } ,
                child: _buildProfileCard()),
              SizedBox(height: 20.h),_buildActivityGrid(),
              // ValueListenableBuilder(
              //   valueListenable: _activityBox.listenable(),
              //   builder: (context, Box<ActivityModel> box, _) {
              //     if (box.isEmpty) {
              //       return Center(
              //         child: Text(
              //           'No activities available.',
              //           style: TextStyle(fontSize: 18),
              //         ),
              //       );
              //     }
              //     return _buildActivityGrid(box);
              //   },
              // ),
               Row(
                 children: [
                   Text(
                   'Video Tutorial ',
                                 style: GoogleFonts.poppins(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: kblue,
                                 ),
                               ),
                 ],
               ),kheight10,kheight10,
              _buildVideoTutorialList(),
              kheight40, kheight40 // Enhanced Video Tutorial Button
            ],
          ),
        ),
      ),
    );
  }

// Enhanced Video Tutorial List Section
  Widget _buildVideoTutorialList() {
    // Sample data for tutorials (replace with real data)
    List<Map<String, String>> tutorials = [
      {
        "title": "Intro to Recovery",
        "thumbnail": "assets/logo/rb_19305.png",
        "description":
            "An introduction to the recovery process after thrombosis treatment, outlining essential steps and strategies."
      },
      {
        "title": "Exercise Tips",
        "thumbnail": "assets/logo/7942060_3794815.jpg",
        "description":
            "Learn about the best exercises that can help improve your mobility and overall health during recovery."
      },
      {
        "title": "Healthy Eating",
        "thumbnail": "assets/logo/rb_28533.png",
        "description":
            "Discover nutritious foods that support your recovery and contribute to your well-being."
      },
      {
        "title": "Mental Health",
        "thumbnail": "assets/logo/rb_2149044577.png",
        "description":
            "Understanding the importance of mental health in recovery, including tips for maintaining a positive mindset."
      },
    ];

    return ListView.builder(
      itemCount: tutorials.length, // Number of items in the list
      shrinkWrap: true, // Wraps the list to prevent overflow
      physics:
          NeverScrollableScrollPhysics(), // Disable scrolling for this list
      itemBuilder: (context, index) {
        // Construct each tutorial card using the helper method
        return _buildTutorialCard(
          title: tutorials[index]["title"]!, // Get title from the map
          thumbnail: tutorials[index]
              ["thumbnail"]!, // Get thumbnail path from the map
          description: tutorials[index]
              ["description"]!, // Get description from the map
        );
      },
    );
  }

// Define your _buildTutorialCard widget
  Widget _buildTutorialCard(
      {required String title,
      required String thumbnail,
      required String description}) {
    return Card(
      elevation: 3, // Increased elevation for better depth effect
      margin: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 8), // Increased vertical margin between cards
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15.0), // Rounded corners for the card
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the card content
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center, // Center the play button
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10.0), // Rounded corners for the image
                  child: Image.asset(
                    thumbnail, // Load the thumbnail image
                    fit: BoxFit.cover,
                    height: 100, // Fixed height for the image
                    width: 100, // Fixed width for the image
                  ),
                ),
                // Play button overlay
                IconButton(
                  icon: Icon(Icons.play_circle_fill,
                      size: 40, color: Colors.white), // Play button icon
                  onPressed: () {
                    // Add your onPressed logic here
                    print('Play video for: $title');
                  },
                ),
              ],
            ),
            SizedBox(width: 15.0), // Space between image and title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // Display the tutorial title
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Slightly larger title font size
                      color: Colors.black87,
                    ), // Style for the title
                    maxLines: 2, // Limit to 2 lines
                    overflow:
                        TextOverflow.ellipsis, // Handle overflow with ellipsis
                  ),
                  SizedBox(height: 5.0), // Space between title and description
                  Text(
                    description, // Display the tutorial description
                    style: TextStyle(
                      color: Colors.grey[700], // Grey color for description
                      fontSize: 14, // Font size for description
                    ), // Style for description
                    maxLines: 3, // Limit description to 3 lines
                    overflow:
                        TextOverflow.ellipsis, // Handle overflow with ellipsis
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSection() {
    String currentDate = DateFormat('EEEE, MMM d   ').format(DateTime.now());
    String currentTime = DateFormat('    hh:mm a   ').format(DateTime.now());

    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent.withOpacity(0.15),
              Colors.lightBlueAccent.withOpacity(0.15)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25.r),
          border:
              Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today,
                    color: Colors.blueAccent, size: 28.r),
                SizedBox(height: 8.h),
                Text(
                  currentDate,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            // Vertical Divider
            Container(
              width: 1.5,
              height: 50.h,
              color: Colors.grey[400],
              margin: EdgeInsets.symmetric(horizontal: 15.w),
            ),

            // Time Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.access_time, color: Colors.blueAccent, size: 28.r),
                SizedBox(height: 8.h),
                Text(
                  currentTime,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Modern Custom AppBar with Gradient and Icon Buttons
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
      actions: [
        IconButton(
          icon: Icon(
            Icons.local_activity_sharp,
            color: Colors.white,
            size: 28.r,
          ),
          onPressed: () {
Get.to(DailyActivityOverviewScreen()) ;

           
            // Notification functionality here
          },
        ),
        SizedBox(width: 10.w),
        IconButton(
          icon: Icon(
            Icons.view_agenda,
            color: Colors.white,
            size: 28.r,
          ),
          onPressed: () {
            Get.to(   DailyCallenderScreen());
         
          //  Get.to(GoalSummaryScreen());
          },
        ),
        SizedBox(width: 10.w),
      ],
      leading: Padding(
        padding: EdgeInsets.only(left: 12.w),
        child: InkWell(onTap: (){Get.to( ProfileScreen(),);},
          child: CircleAvatar(
            radius: 24.r,
            backgroundImage: NetworkImage(
              'https://www.w3schools.com/w3images/avatar2.png',
            ),
          ),
        ),
      ),
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
