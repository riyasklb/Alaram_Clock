import 'package:alaram/tools/constans/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class EducationResourcesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        title: Text(
          'Education Resources',
        style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: kblue,
    
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore Resources',
              style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                children: [
                  _buildResourceCard('Courses', Icons.school, Colors.teal),
                  _buildResourceCard('Articles', Icons.article, Colors.orange),
                  _buildResourceCard('Videos', Icons.video_library, Colors.redAccent),
                  _buildResourceCard('Quizzes', Icons.quiz, Colors.blueAccent),
                  _buildResourceCard('E-books', Icons.book, Colors.green),
                  _buildResourceCard('Podcasts', Icons.podcasts, Colors.purple),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        // TODO: Handle navigation or action on card tap
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: color.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50.sp, color: color),
              SizedBox(height: 10.h),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
