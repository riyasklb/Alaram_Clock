// import 'package:alaram/tools/constans/model/goal_model.dart';
// import 'package:alaram/views/daily_goals/controller.dart'; // Ensure this is correct
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:table_calendar/table_calendar.dart';

// class SavedGoalsScreen extends StatelessWidget {
//   final GoalController _goalController = Get.put(GoalController());
//   final Rx<DateTime> _selectedDate = DateTime.now().obs;

//   SavedGoalsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Saved Goals", style: GoogleFonts.lato(color: Colors.white)),
//         backgroundColor: Colors.blue,
//       ),
//       body: Column(
//         children: [
//           Obx(() => TableCalendar(
//                 focusedDay: _selectedDate.value,
//                 firstDay: DateTime.utc(2000),
//                 lastDay: DateTime.utc(2100),
//                 selectedDayPredicate: (day) => isSameDay(day, _selectedDate.value),
//                 onDaySelected: (selectedDay, focusedDay) {
//                   _selectedDate.value = selectedDay;
//                   _goalController.filterGoalsByDate(selectedDay); // Filter goals based on selected date
//                 },
//               )),
//           Expanded(
//             child: Obx(() {
//               final filteredGoals = _goalController.filteredGoals;
//               return filteredGoals.isNotEmpty
//                   ? ListView.builder(
//                       itemCount: filteredGoals.length,
//                       itemBuilder: (context, index) {
//                         final goal = filteredGoals[index];
//                         final meal = goal.MealValue ?? Meal(); // Ensure meal is not null

// return Card(
//   margin: EdgeInsets.all(8.0.w),
//   elevation: 4,
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.circular(15.r),
//     side: BorderSide(color: Colors.teal.shade200, width: 1),
//   ),
//   child: ListTile(
//     contentPadding: EdgeInsets.all(15.0.w),
//     leading: Icon(
//       Icons.assignment_turned_in,
//       color: Colors.teal,
//       size: 40.sp,
//     ),
//     title: Text(
//       "Goal ID: ${goal.goalId}",
//       style: GoogleFonts.lato(
//         fontWeight: FontWeight.bold,
//         fontSize: 16.sp,
//       ),
//     ),
//     subtitle: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Goal Type: ${goal.goalType}", style: GoogleFonts.lato()),
//         Text("Date: ${goal.date.toLocal()}", style: GoogleFonts.lato()),
//         SizedBox(height: 8.h),
//         Text("Meals:", style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
//         Text("Breakfast: ${meal.morning == true ? "Enabled" : "Disabled"}", style: GoogleFonts.lato()),
//         Text("Lunch: ${meal.afternoon == true ? "Enabled" : "Disabled"}", style: GoogleFonts.lato()),
//         Text("Night: ${meal.night == true ? "Enabled" : "Disabled"}", style: GoogleFonts.lato()),
//         SizedBox(height: 8.h),
//         Text("Medicines:", style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
//         if (goal.medicines != null && goal.medicines!.isNotEmpty) ...goal.medicines!.map((medicine) {
//           return Padding(
//             padding: const EdgeInsets.only(left: 16.0, top: 4.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Name: ${medicine.name}", style: GoogleFonts.lato()),
//                 Text("Frequency: ${medicine.frequencyType}", style: GoogleFonts.lato()),
//                 Text("Dosage: ${medicine.dosage}", style: GoogleFonts.lato()),
//                 Text("Quantity: ${medicine.quantity}", style: GoogleFonts.lato()),
//                 Text('Times: ${medicine.selectedTimes.join(", ")}', style: GoogleFonts.lato()),
//               ],
//             ),
//           );
//         }).toList()
//         else
//           Text("No medicines found", style: GoogleFonts.lato()),
//       ],
//     ),
//     trailing: IconButton(
//       icon: Icon(
//         goal.skipped ? Icons.check_circle : Icons.cancel,
//         color: goal.skipped ? Colors.green : Colors.red,
//         size: 24.sp,
//       ),
//       onPressed: () => _goalController.toggleGoalStatus(index),
//     ),
//   ),
// );

//                       },
//                     )
//                   : Center(
//                       child: AnimatedTextKit(
//                         animatedTexts: [
//                           FadeAnimatedText(
//                             "No goals for the selected date",
//                             textStyle: GoogleFonts.lato(fontSize: 24.sp, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                         repeatForever: true,
//                       ),
//                     );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
