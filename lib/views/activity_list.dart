import 'package:alaram/tools/constans/model/daily_activity_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class DailyProgressScreen extends StatelessWidget {
  final Box<DailyActivityModel> activityBox = Hive.box('dailyactivities');

  // Method to retrieve and print saved progress data
  Future<List<DailyActivityModel>> _getAndPrintDailyActivities() async {
    final activities = activityBox.values.cast<DailyActivityModel>().toList();

    // Print each activity to the console
    for (var activity in activities) {
      print('--- Daily Activity ---');
      print('User ID: ${activity.userId}');
      print('Date: ${activity.date}');
      print('Water Intake: ${activity.waterIntake} L');
      print('Sleep Hours: ${activity.sleepHours} hrs');
      print('Walking Steps: ${activity.walkingSteps}');
      print('Food Intake: ${activity.foodIntake}');
      print('Medicine Intake: ${activity.medicineIntake}');
    }

    return activities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Progress'),
      ),
      body: FutureBuilder<List<DailyActivityModel>>(
        future: _getAndPrintDailyActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No progress data found.'));
          }

          final activities = snapshot.data!;
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Date: ${activity.date}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User ID: ${activity.userId}'),
                      Text('Water Intake: ${activity.waterIntake} L'),
                      Text('Sleep Hours: ${activity.sleepHours} hrs'),
                      Text('Walking Steps: ${activity.walkingSteps}'),
                      Text('Food Intake: ${activity.foodIntake}'),
                      Text('Medicine Intake: ${activity.medicineIntake}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}