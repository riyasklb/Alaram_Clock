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
        title: Text(
          'Video Tutorial ',
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: kblue,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [kheight10, kheight10, _buildVideoTutorialList()],
        ),
      ),
    );
  } // Enhanced Video Tutorial List Section

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
}
