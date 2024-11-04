import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TodaysGoalsComplitionScreen extends StatelessWidget {
  final List<Appointment> todaysGoals;

  TodaysGoalsComplitionScreen({required this.todaysGoals});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Goals"),
      ),
      body: ListView.builder(
        itemCount: todaysGoals.length,
        itemBuilder: (context, index) {
          final goal = todaysGoals[index];
          return ListTile(
            title: Text(goal.subject),
            subtitle: Text('From: ${goal.startTime} to ${goal.endTime}'),
          );
        },
      ),
    );
  }
}
