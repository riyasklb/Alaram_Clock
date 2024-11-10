import 'package:alaram/tools/constans/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoTutorial extends StatelessWidget {
  const VideoTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Video Tutorial',
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: kblue,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            _buildVideoTutorialList(),
          ],
        ),
      ),
    );
  }

  // Video tutorial list section with sample data
  Widget _buildVideoTutorialList() {
    List<Map<String, String>> tutorials = [
      {
        "title": "Intro to Recovery",
        "thumbnail": "assets/logo/rb_19305.png",
        "description": "An introduction to the recovery process after thrombosis treatment, outlining essential steps and strategies."
      },
      {
        "title": "Exercise Tips",
        "thumbnail": "assets/logo/7942060_3794815.jpg",
        "description": "Learn about the best exercises that can help improve your mobility and overall health during recovery."
      },
      {
        "title": "Healthy Eating",
        "thumbnail": "assets/logo/rb_28533.png",
        "description": "Discover nutritious foods that support your recovery and contribute to your well-being."
      },
      {
        "title": "Mental Health",
        "thumbnail": "assets/logo/rb_2149044577.png",
        "description": "Understanding the importance of mental health in recovery, including tips for maintaining a positive mindset."
      },
    ];

    return ListView.builder(
      itemCount: tutorials.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildTutorialCard(
          title: tutorials[index]["title"]!,
          thumbnail: tutorials[index]["thumbnail"]!,
          description: tutorials[index]["description"]!,
        );
      },
    );
  }

  // Updated card design for a more engaging UI
  Widget _buildTutorialCard({
    required String title,
    required String thumbnail,
    required String description,
  }) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                    child: Image.asset(
                      thumbnail,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                // Animated play button overlay
                AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: 1.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.play_circle_fill,
                      size: 40,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    onPressed: () {
                      print('Play video for: $title');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontSize: 13.sp,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
