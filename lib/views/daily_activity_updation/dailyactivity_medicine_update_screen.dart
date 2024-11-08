import 'package:alaram/tools/constans/color.dart';
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
  bool isAlreadyUpdated = false;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyUpdated();
  }

  Future<void> checkIfAlreadyUpdated() async {
    final box = await Hive.openBox<DailyActivityModel>('dailyActivities');
    final today = DateTime.now();
    isAlreadyUpdated = box.values.any((activity) =>
        activity.date.year == today.year &&
        activity.date.month == today.month &&
        activity.date.day == today.day);

    if (!isAlreadyUpdated) {
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

    setState(() {});
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
          frequency: 'daily',
          date: DateTime.now(),
        ),
      );
    }

    await box.addAll(activities);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Today's goals saved successfully!")),
    );
    setState(() {
      isAlreadyUpdated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Goals", style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold,color: kwhite)),
        backgroundColor: kblue,
      ),
      body: isAlreadyUpdated
          ? Center(
              child: Text(
                "You have already updated your tasks for today!",
                style: GoogleFonts.lato(fontSize: 18, color: Colors.redAccent),
              ),
            )
          : buildGoalsList(),
      floatingActionButton: isAlreadyUpdated
          ? null
          : FloatingActionButton(
              onPressed: submitGoals,
              backgroundColor: Colors.teal,
              child: Icon(Icons.check, color: Colors.white),
            ),
    );
  }

  Widget buildGoalsList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: widget.todaysGoals.length,
        itemBuilder: (context, index) {
          final goal = widget.todaysGoals[index];
          final isGoalCompleted = goalCompletionStatus[index];

          return Card(
            color: isGoalCompleted ? Colors.teal.shade50 : Colors.white,
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isGoalCompleted ? Colors.teal : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Goal ${index + 1}",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 8),
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
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Text(
                                  "${medicine.name} (Frequency: ${medicine.frequencyType})",
                                  style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...medicine.selectedTimes.asMap().entries.map(
                                    (entry) {
                                      int timeIndex = entry.key;
                                      String time = entry.value;

                                      return Row(
                                        children: [
                                          Checkbox(
                                            value: medicineTimingCompletionStatus[index]![medicineIndex]![timeIndex] ?? false,
                                            onChanged: (value) =>
                                                toggleMedicineTimingCompletion(index, medicineIndex, timeIndex, value!),
                                            activeColor: Colors.teal,
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
                  if (goal.MealValue != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          "Meal Timings:",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(height: 8),
                        buildMealRow(index, 'morning', "Breakfast: 8:00 - 9:00 AM"),
                        buildMealRow(index, 'afternoon', "Lunch: 12:30 - 1:30 PM"),
                        buildMealRow(index, 'night', "Dinner: 8:00 - 9:00 PM"),
                      ],
                    ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: isGoalCompleted,
                        onChanged: (value) => markGoalAsComplete(index, value!),
                        activeColor: Colors.teal,
                      ),
                      Text(
                        "Goal Completed",
                        style: GoogleFonts.lato(fontSize: 16, color: Colors.teal),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildMealRow(int goalIndex, String meal, String timingText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: mealCompletionStatus[goalIndex]![meal],
              onChanged: (value) => toggleMealCompletion(goalIndex, meal, value!),
              activeColor: Colors.teal,
            ),
            Text(timingText, style: GoogleFonts.lato()),
          ],
        ),
      ],
    );
  }
}
