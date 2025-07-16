import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/cutomwidget/cutom_home_button.dart';
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  SizedBox(height: 10.h),
                  _buildVideoCategoryList(),
                  SizedBox(height: 20.h),
                  _buildVideoTutorialList(),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: CustomHomeButton(),
          ),
        ],
      ),
    );
  }

  // Horizontal list of categories like "Trending", "Recommended", etc.
Widget _buildVideoCategoryList() {
  List<String> categories = ["Trending", "Recommended", "Health", "Exercise"];

  return SizedBox(
    height: 40.h,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: GestureDetector(
            onTap: () {
              print('Clicked on category: ${categories[index]}');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: kblue, // background color
                borderRadius: BorderRadius.circular(20.0), // rounded corners
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}


  // Video tutorial list section with sample data
  Widget _buildVideoTutorialList() {
    List<Map<String, String>> tutorials = [
      {
        "title": "Intro to Recovery",
        "thumbnail": "assets/logo/rb_19305.png",
        "description": "An introduction to the recovery process after thrombosis treatment."
      },
      {
        "title": "Exercise Tips",
        "thumbnail": "assets/logo/7942060_3794815.jpg",
        "description": "Learn about the best exercises that can help improve your mobility."
      },
      {
        "title": "Healthy Eating",
        "thumbnail": "assets/logo/rb_28533.png",
        "description": "Discover nutritious foods that support your recovery."
      },
      {
        "title": "Mental Health",
        "thumbnail": "assets/logo/rb_2149044577.png",
        "description": "Understanding the importance of mental health in recovery."
      },
    ];

    return GridView.builder(
      itemCount: tutorials.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two videos per row
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.75, // Aspect ratio for the grid items
      ),
      itemBuilder: (context, index) {
        return _buildTutorialCard(
          title: tutorials[index]["title"]!,
          thumbnail: tutorials[index]["thumbnail"]!,
          description: tutorials[index]["description"]!,
        );
      },
    );
  }

  // Updated card design resembling YouTube video tiles
  Widget _buildTutorialCard({
    required String title,
    required String thumbnail,
    required String description,
  }) {
    return GestureDetector(
      onTap: () {
        print('Play video for: $title');
      },
      child: Card(
        elevation: 5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail section
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                thumbnail,
                fit: BoxFit.cover,
                height: 120.h,
                width: double.infinity,  // Full-width thumbnail
              ),
            ),
            SizedBox(height: 8.0),
            // Title section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Description section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                description,
                style: GoogleFonts.poppins(
                  color: Colors.grey[700],
                  fontSize: 12.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
