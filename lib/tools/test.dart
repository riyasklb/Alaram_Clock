import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:alaram/tools/model/goal_model.dart';  // Import your Goal model here
import 'package:google_fonts/google_fonts.dart';

class GoalOverviewScreen extends StatelessWidget {
  const GoalOverviewScreen({Key? key}) : super(key: key);

  Future<List<Goal>> _fetchGoals() async {
    final box = await Hive.openBox<Goal>('goals');
    final goals = box.values.toList();

    // Print each goal's data to the console
    for (var goal in goals) {
      print('Goal ID: ${goal.goalId}');
      print('Goal Type: ${goal.goalType}');
      print('Date: ${goal.date}');
      if (goal.MealValue != null) {
        print('Meals - Morning: ${goal.MealValue!.morning}, Afternoon: ${goal.MealValue!.afternoon}, Night: ${goal.MealValue!.night}');
      }
      if (goal.medicines != null) {
        for (var medicine in goal.medicines!) {
          print('Medicine: ${medicine.name}, Dosage: ${medicine.dosage}, Frequency: ${medicine.frequencyType}, Times: ${medicine.selectedTimes}');
        }
      }
    }

    return goals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Goals',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Goal>>(
        future: _fetchGoals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching goals'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No goals found'));
          } else {
            final goals = snapshot.data!;
            return ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return _buildGoalCard(goal);
              },
            );
          }
        },
      ),
    );
  }

Widget _buildGoalCard(Goal goal) {
  print('Building card for Goal ID: ${goal.goalId}');
  print('Goal Type: ${goal.goalType}');
  print('Date: ${goal.date}');
  
  // Check if MealValue is not null before accessing its properties
  if (goal.MealValue != null) {
    print('Meals - Morning: ${goal.MealValue!.morning}, Afternoon: ${goal.MealValue!.afternoon}, Night: ${goal.MealValue!.night}');
  }

  if (goal.medicines != null) {
    for (var medicine in goal.medicines!) {
      print('Medicine: ${medicine.name}, Dosage: ${medicine.dosage}, Frequency: ${medicine.frequencyType}, Times: ${medicine.selectedTimes}');
    }
  }

  return Card(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Goal ID: ${goal.goalId}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Goal Type: ${goal.goalType}'),
          Text('Date: ${goal.date}'),
          SizedBox(height: 8),
          Text('Meals:'),
          // if (goal.MealValue != null) ...[
          //   Text(' - Morning: ${goal.MealValue!.morning ? "Enabled" : "Disabled"}'),
          //   Text(' - Afternoon: ${goal.MealValue!.afternoon ? "Enabled" : "Disabled"}'),
          //   Text(' - Night: ${goal.MealValue!.night ? "Enabled" : "Disabled"}'),
          // ],
          SizedBox(height: 8),
          Text('Medicines:', style: TextStyle(fontWeight: FontWeight.bold)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: goal.medicines!.map((medicine) {
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '• ${medicine.name} - ${medicine.dosage}, Frequency: ${medicine.frequencyType}, Dosage: ${medicine.dosage}, Time: ${medicine.selectedTimes}',
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}

}
