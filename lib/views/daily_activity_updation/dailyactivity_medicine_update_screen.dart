import 'package:alaram/tools/model/daily_activity_model.dart';
import 'package:alaram/tools/model/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';



class DailyActivityUpdateMedicineScreen extends StatefulWidget {
  final List<Goal> todaysGoals;

  DailyActivityUpdateMedicineScreen({required this.todaysGoals});

  @override
  _DailyActivityUpdateMedicineScreenState createState() =>
      _DailyActivityUpdateMedicineScreenState();
}

class _DailyActivityUpdateMedicineScreenState extends State<DailyActivityUpdateMedicineScreen> {
  late List<bool> goalCompletionStatus;
  late Map<int, List<bool>> medicineCompletionStatus;
  late Map<int, Map<int, Map<int, bool>>> medicineTimingCompletionStatus;
  late Map<int, Map<String, bool>> mealCompletionStatus;

  @override
  void initState() {
    super.initState();
    goalCompletionStatus = List<bool>.filled(widget.todaysGoals.length, false);
    medicineCompletionStatus = {
      for (var i = 0; i < widget.todaysGoals.length; i++)
        i: List<bool>.filled(widget.todaysGoals[i].medicines?.length ?? 0, false)
    };
    medicineTimingCompletionStatus = {
      for (var i = 0; i < widget.todaysGoals.length; i++)
        i: {
          for (var j = 0; j < (widget.todaysGoals[i].medicines?.length ?? 0); j++)
            j: {
              for (var k = 0; k < (widget.todaysGoals[i].medicines![j].selectedTimes.length); k++)
                k: false
            }
        }
    };
    mealCompletionStatus = {
      for (var i = 0; i < widget.todaysGoals.length; i++)
        i: {
          'morning': false,
          'afternoon': false,
          'night': false,
        }
    };
  }

  void markGoalAsComplete(int index, bool value) {
    setState(() {
      goalCompletionStatus[index] = value;
    });
  }

  void toggleMedicineCompletion(int goalIndex, int medicineIndex, bool value) {
    setState(() {
      medicineCompletionStatus[goalIndex]![medicineIndex] = value;
    });
  }

  void toggleMedicineTimingCompletion(int goalIndex, int medicineIndex, int timeIndex, bool value) {
    setState(() {
      medicineTimingCompletionStatus[goalIndex]![medicineIndex]![timeIndex] = value;
    });
  }

  void toggleMealCompletion(int goalIndex, String meal, bool value) {
    setState(() {
      mealCompletionStatus[goalIndex]![meal] = value;
    });
  }

Future<void> submitGoals() async {
  final box = await Hive.openBox<DailyActivityModel>('dailyActivities');

  List<DailyActivityModel> activities = [];
  for (int i = 0; i < widget.todaysGoals.length; i++) {
    final goal = widget.todaysGoals[i];
    final medicines = goal.medicines?.asMap().entries.map((entry) {
      int medicineIndex = entry.key;
      var medicine = entry.value;

      return DailyMedicine(
        name: medicine.name,
        selectedTimes: medicine.selectedTimes,
        frequency: medicine.frequencyType,
        taskCompletionStatus: {
          for (int timeIndex = 0; timeIndex < medicine.selectedTimes.length; timeIndex++)
            medicine.selectedTimes[timeIndex]: medicineTimingCompletionStatus[i]![medicineIndex]![timeIndex] ?? false
        },
      );
    }).toList();

    final mealValue = DailyactivityMealValue(
      morning: mealCompletionStatus[i]!['morning'] ?? false,
      afternoon: mealCompletionStatus[i]!['afternoon'] ?? false,
      night: mealCompletionStatus[i]!['night'] ?? false,
      mealCompletionStatus: mealCompletionStatus[i]!, // Pass the whole map if required
    );

    activities.add(
      DailyActivityModel(
        activityName: 'daily tasks',
        isActivityCompleted: true,
        medicines: medicines,
        mealValue: mealValue,
        goalId: goal.goalId,
        frequency:'daily' ,
        date: DateTime.now(),
      ),
    );
  }

  // Save activities to Hive
 // await box.clear(); // Clear previous day's goals (optional)
  await box.addAll(activities);

  // Display success message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Today's goals saved successfully!")),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Goals", style: GoogleFonts.lato()),
      ),
      body: ListView.builder(
        itemCount: widget.todaysGoals.length,
        itemBuilder: (context, index) {
          final goal = widget.todaysGoals[index];
          final isGoalCompleted = goalCompletionStatus[index];

          return Card(
            color: isGoalCompleted ? Colors.green.shade50 : Colors.white,
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isGoalCompleted ? Colors.green : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Medicine Information Section
                  if (goal.medicines != null && goal.medicines!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Medicine Information:",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                        ...goal.medicines!.asMap().entries.map((entry) {
                          int medicineIndex = entry.key;
                          var medicine = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  "Medicine: ${medicine.name}",
                                  style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Times:',
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ...medicine.selectedTimes.asMap().entries.map(
                                    (entry) {
                                      int timeIndex = entry.key;
                                      String time = entry.value;

                                      return Row(
                                        children: [
                                          Checkbox(
                                            value: medicineTimingCompletionStatus[index]![medicineIndex]![timeIndex] ?? false,
                                            onChanged: (value) =>
                                                toggleMedicineTimingCompletion(
                                                    index, medicineIndex, timeIndex, value!),
                                            activeColor: Colors.green,
                                          ),
                                          Text(time, style: GoogleFonts.lato()),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),

                  // Meal Timing Section
                  if (goal.MealValue != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          "Meal Timings:",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                        if (goal.MealValue!.morning == true)
                          Row(
                            children: [
                              Checkbox(
                                value: mealCompletionStatus[index]!['morning'],
                                onChanged: (value) =>
                                    toggleMealCompletion(index, 'morning', value!),
                                activeColor: Colors.green,
                              ),
                              Text("Breakfast: 8:00 - 9:00 AM",
                                  style: GoogleFonts.lato()),
                            ],
                          ),
                        if (goal.MealValue!.afternoon == true)
                          Row(
                            children: [
                              Checkbox(
                                value: mealCompletionStatus[index]!['afternoon'],
                                onChanged: (value) => toggleMealCompletion(
                                    index, 'afternoon', value!),
                                activeColor: Colors.green,
                              ),
                              Text("Lunch: 12:00 - 1:00 PM",
                                  style: GoogleFonts.lato()),
                            ],
                          ),
                        if (goal.MealValue!.night == true)
                          Row(
                            children: [
                              Checkbox(
                                value: mealCompletionStatus[index]!['night'],
                                onChanged: (value) =>
                                    toggleMealCompletion(index, 'night', value!),
                                activeColor: Colors.green,
                              ),
                              Text("Dinner: 8:00 - 9:00 PM",
                                  style: GoogleFonts.lato()),
                            ],
                          ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: submitGoals,
        child: Text("Submit", style: GoogleFonts.lato()),
      ),
    );
  }
}
