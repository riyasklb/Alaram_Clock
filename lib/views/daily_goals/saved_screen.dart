import 'package:alaram/tools/constans/model/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SavedGoalsScreen extends StatefulWidget {
  @override
  _SavedGoalsScreenState createState() => _SavedGoalsScreenState();
}

class _SavedGoalsScreenState extends State<SavedGoalsScreen> {
  late Box<Goal> _goaldata;
  bool isBoxOpened = false;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _goaldata = await Hive.openBox<Goal>('goals');
    setState(() {
      isBoxOpened = true; // Mark the box as opened
    });
  }

  @override
  void dispose() {
    if (_goaldata.isOpen) {
      _goaldata.close(); // Close the box when the screen is disposed
    }
    super.dispose();
  }

  void _toggleGoalStatus(int index) {
    final goal = _goaldata.getAt(index) as Goal?;
    if (goal != null) {
      setState(() {
        goal.skipped = !goal.skipped; // Toggle the skipped status
        _goaldata.putAt(index, goal); // Save the updated goal
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            title: Text("Saved Goals", style: GoogleFonts.lato(color: Colors.white),),
            backgroundColor: Colors.blue,
          ),
          body: isBoxOpened
              ? (_goaldata.values.any((goal) => goal.skipped == false)
                  ? ListView.builder(
                      itemCount: _goaldata.length,
                      itemBuilder: (context, index) {
                        final goal = _goaldata.getAt(index) as Goal?;

                        // Skip goals that are marked as skipped
                        if (goal == null || goal.skipped) {
                          return SizedBox.shrink(); // Don't display skipped goals
                        }

                        // Handle null check for targetValue (Meal type)
                        final meal = goal.MealValue ?? Meal();

                        return Card(
                          margin: EdgeInsets.all(8.0.w), // Responsive margin
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            side: BorderSide(color: Colors.teal.shade200, width: 1),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(15.0.w), // Responsive padding
                            leading: Icon(
                              Icons.assignment_turned_in,
                              color: Colors.teal,
                              size: 40.sp, // Responsive icon size
                            ),
                            title: Text(
                              "Goal ID: ${goal.goalId}",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp, // Responsive text size
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Goal Type: ${goal.goalType}", style: GoogleFonts.lato()),
                                Text("Date: ${goal.date.toLocal()}", style: GoogleFonts.lato()),
                                SizedBox(height: 8.h),
                                Text("Meals:", style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
                                Text("Breakfast: ${meal.morning == true ? "Enabled" : "Disabled"}", style: GoogleFonts.lato()),
                                Text("Lunch: ${meal.afternoon == true ? "Enabled" : "Disabled"}", style: GoogleFonts.lato()),
                             
                                Text("Night: ${meal.night == true ? "Enabled" : "Disabled"}", style: GoogleFonts.lato()),
                                SizedBox(height: 8.h),
                                Text("Medicines:", style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
                                if (goal.medicines != null && goal.medicines!.isNotEmpty)
                                  ...goal.medicines!.map((medicine) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Name: ${medicine.name}", style: GoogleFonts.lato()),
                                          Text("Frequency: ${medicine.frequencyType}", style: GoogleFonts.lato()),
                                          Text("Dosage: ${medicine.dosage}", style: GoogleFonts.lato()),
                                          Text("Quantity: ${medicine.quantity}", style: GoogleFonts.lato()),
                                          Text('Times: ${medicine.selectedTimes.join(", ")}', style: GoogleFonts.lato()),
                                        ],
                                      ),
                                    );
                                  }).toList()
                                else
                                  Text("No medicines found", style: GoogleFonts.lato()),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                goal.skipped ? Icons.check_circle : Icons.cancel,
                                color: goal.skipped ? Colors.green : Colors.red,
                                size: 24.sp, // Responsive icon size
                              ),
                              onPressed: () => _toggleGoalStatus(index),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: AnimatedTextKit(
                      animatedTexts: [
                        FadeAnimatedText("You don't have goals", textStyle: GoogleFonts.lato(fontSize: 24.sp, fontWeight: FontWeight.bold)),
                      ],
                      repeatForever: true,
                    )))
              : Center(child: CircularProgressIndicator()), // Show loading indicator while waiting
        );
      
    
  }
}
