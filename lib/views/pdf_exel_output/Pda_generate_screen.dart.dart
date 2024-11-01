// import 'package:alaram/tools/constans/color.dart';
// import 'package:alaram/tools/constans/model/hive_model.dart';
// import 'package:alaram/views/pdf_exel_output/controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';


// class PdfGenerateScreen extends StatelessWidget {
//   final PdfGenerateController controller = Get.put(PdfGenerateController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         leading: InkWell(
//           onTap: () => Get.back(),
//           child: Icon(
//             Icons.arrow_back,
//             color: kwhite,
//           ),
//         ),
//         title: Text(
//           'Export Activities',
//           style: GoogleFonts.poppins(
//             fontSize: 24.sp,
//             fontWeight: FontWeight.w600,
//             color: kwhite,
//           ),
//         ),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Obx(() => controller.isLoading.value
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: EdgeInsets.all(16.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Image.asset('assets/logo/rb_19305.png'),
//                   Text(
//                     'Export Reports',
//                     style: GoogleFonts.montserrat(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.bold,
//                         color: kblack),
//                   ),
//                   SizedBox(height: 10.h),
//                   _buildExportButton('Daily Report', controller.filterDailyData()),
//                   SizedBox(height: 10.h),
//                   _buildExportButton('Weekly Report', controller.filterWeeklyData()),
//                   SizedBox(height: 10.h),
//                   _buildExportButton('Monthly Report', controller.filterMonthlyData()),
//                   SizedBox(height: 10.h),
//                   _buildOverviewSection(),
//                 ],
//               ),
//             )),
//     );
//   }

//   Widget _buildExportButton(String label, List<ActivityModel> data) {
//     return ElevatedButton(
//       onPressed: data.isNotEmpty
//           ? () => controller.generateAndSharePdf(data)
//           : () {
//               Get.snackbar('Info', 'No data available for $label');
//             },
//       style: ElevatedButton.styleFrom(
//         elevation: 5,
//         padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
//         backgroundColor: Colors.red,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.r),
//         ),
//       ),
//       child: Text(
//         label,
//         style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16.sp),
//       ),
//     );
//   }

//   Widget _buildOverviewSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Activity Overview',
//           style: GoogleFonts.montserrat(fontSize: 22.sp, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10.h),
//         Text(
//           'Overview content goes here',  // Placeholder - you can expand with detailed info
//           style: GoogleFonts.montserrat(fontSize: 16.sp),
//         ),
//       ],
//     );
//   }
// }
