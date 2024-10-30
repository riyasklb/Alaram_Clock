// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive/hive.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class GoalCompletionScreen extends StatefulWidget {
//   @override
//   State<GoalCompletionScreen> createState() => _GoalCompletionScreenState();
// }

// class _GoalCompletionScreenState extends State<GoalCompletionScreen> {
//   Box? goalBox;
//   List<Map<String, dynamic>> medicinesData = [];
  
//   double waterProgress = 0.0;
//   double sleepProgress = 0.0;
//   double walkingProgress = 0.0;
//   bool hasTakenBreakfast = false;
//   bool hasTakenMorningMedicine = false;
//   bool hasTakenNightMedicine = false;
//   bool hasTakenAfternoonMedicine = false;
//   bool hasTakenEveningMedicine = false;

//   final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeDailyGoals();
//   }

//   Future<void> _initializeDailyGoals() async {
//     goalBox = await Hive.openBox('goalBox');

//     String lastSavedDate = goalBox?.get('lastSavedDate') ?? '';
//     if (lastSavedDate != currentDate) {
//       _resetDailyGoals();
//       await goalBox?.put('lastSavedDate', currentDate);
//     }

//     // Load daily progress and medicines data
//     setState(() {
//       hasTakenBreakfast = goalBox?.get('hasTakenBreakfast') ?? false;
//       hasTakenMorningMedicine = goalBox?.get('hasTakenMorningMedicine') ?? false;
//       hasTakenAfternoonMedicine = goalBox?.get('hasTakenAfternoonMedicine') ?? false;
//       hasTakenEveningMedicine = goalBox?.get('hasTakenEveningMedicine') ?? false;
//       hasTakenNightMedicine = goalBox?.get('hasTakenNightMedicine') ?? false;

//       waterProgress = goalBox?.get('waterProgress') ?? 0.0;
//       sleepProgress = goalBox?.get('sleepProgress') ?? 0.0;
//       walkingProgress = goalBox?.get('walkingProgress') ?? 0.0;
      
//       // Retrieve medicines data
//       medicinesData = (goalBox?.get('medicines') as List?)?.cast<Map<String, dynamic>>() ?? [];
//       _isLoading = false;
//     });
//   }

//   void _resetDailyGoals() {
//     setState(() {
//       hasTakenBreakfast = false;
//       hasTakenMorningMedicine = false;
//       hasTakenNightMedicine = false;
//       hasTakenAfternoonMedicine = false;
//       hasTakenEveningMedicine = false;
//       waterProgress = 0.0;
//       sleepProgress = 0.0;
//       walkingProgress = 0.0;
//     });
//   }

//   Future<void> _saveDailyProgress() async {
//     await goalBox?.put('hasTakenBreakfast', hasTakenBreakfast);
//     await goalBox?.put('hasTakenMorningMedicine', hasTakenMorningMedicine);
//     await goalBox?.put('hasTakenNightMedicine', hasTakenNightMedicine);
//     await goalBox?.put('hasTakenAfternoonMedicine', hasTakenAfternoonMedicine); 
//     await goalBox?.put('hasTakenEveningMedicine', hasTakenEveningMedicine);

//     await goalBox?.put('waterProgress', waterProgress);
//     await goalBox?.put('sleepProgress', sleepProgress);
//     await goalBox?.put('walkingProgress', walkingProgress);
//     await goalBox?.put('lastSavedDate', currentDate);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Goal Completion',
//           style: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: EdgeInsets.all(16.w),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Your Goals', style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 20.h),
//                     // Other progress widgets here...

//                     SizedBox(height: 20.h),
//                     Text('Medicine Details', style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold)),
//                     _buildMedicineList(),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildMedicineList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: medicinesData.map((medicine) {
//         return Padding(
//           padding: EdgeInsets.only(bottom: 10.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Name: ${medicine['name']}', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500)),
//               Text('Dosage: ${medicine['dosage']}', style: GoogleFonts.poppins(fontSize: 14.sp)),
//               Text('Quantity: ${medicine['quantity']}', style: GoogleFonts.poppins(fontSize: 14.sp)),
//               Text('Frequency: ${medicine['frequency']}', style: GoogleFonts.poppins(fontSize: 14.sp)),
//               Text('Times: ${medicine['times'].join(', ')}', style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.blueAccent)),
//               Divider(color: Colors.grey),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
