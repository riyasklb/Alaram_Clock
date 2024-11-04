import 'package:alaram/tools/constans/model/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Saved Goals"),
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
                  final meal = goal.targetValue ?? Meal();

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text("Goal ID: ${goal.goalId}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Goal Type: ${goal.goalType}"),
                          Text("Date: ${goal.date.toLocal()}"),
                          SizedBox(height: 8),
                          Text("Meals:"),
                          Text("Breakfast: ${meal.morning == true ? "Enabled" : "Disabled"}"),
                          Text("Lunch: ${meal.afternoon == true ? "Enabled" : "Disabled"}"),
                          Text("Dinner: ${meal.evening == true ? "Enabled" : "Disabled"}"),
                          Text("Night: ${meal.night == true ? "Enabled" : "Disabled"}"),
                          SizedBox(height: 8),
                          Text("Medicines:"),
                          if (goal.medicines != null)
                            ...goal.medicines!.map((medicine) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name: ${medicine.name}"),
                                    Text("Frequency: ${medicine.frequencyType}"),
                                    Text("Dosage: ${medicine.dosage}"),
                                    Text("Quantity: ${medicine.quantity}"),
                                   Text('${medicine.selectedTimes}')
                                  ],
                                ),
                              );
                            }).toList(),
                          if (goal.medicines == null)
                            Text("No medicines found"),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(child: Text("You don't have goals")))
        : Center(child: CircularProgressIndicator()), // Show loading indicator while waiting
  );
}

    
  
}
