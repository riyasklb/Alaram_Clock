import 'package:alaram/tools/constans/model/goal_model.dart';
import 'package:alaram/views/callender/today/today_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SavedCallenderScreen extends StatefulWidget {
  @override
  _SavedCallenderScreenState createState() => _SavedCallenderScreenState();
}

class _SavedCallenderScreenState extends State<SavedCallenderScreen> {
  late Box<Goal> goalData;
  List<Appointment> _goalAppointments = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {print('-----------11---------------------');
    goalData = await Hive.openBox<Goal>('goals');
    print('--------------------22------------');
    _loadGoalAppointments();
    print('-----------------33---------------'); // Load appointments after opening the box
    setState(() {
      _isLoading = false; // Set loading to false after initialization
    });
    print('---------------44-----------------');
  }

 void _loadGoalAppointments() {
  List<Appointment> appointments = [];

  for (int i = 0; i < goalData.length; i++) {
    final goal = goalData.getAt(i) as Goal;
print('--------------1-----${goal.skipped}-------------');
  //  Check if the goal is skipped
    if (goal.skipped) {
      print('--------------2------------------');
      print("Goal  is skipped.");
      continue; 
     // Skip loading appointments for this goal
    } else {
      print("Goal  is not skipped.");
    }print('----------------3----------------');

    // Create appointments for medicines
    if (goal.medicines != null) {
      for (var medicine in goal.medicines!) {
        _addAppointmentsForMedicine(medicine, appointments);
      }
    }

    // Create appointments for food intake
    if (goal.targetValue != null) {
      _addAppointmentsForFoodIntake(goal.targetValue!, appointments);
    }
  }

  setState(() {
    _goalAppointments = appointments; // Update the appointments list
  });
}


  void _addAppointmentsForMedicine(Medicine medicine, List<Appointment> appointments) {
    DateTime startTime = DateTime.now(); // Starting from today
    for (int j = 0; j < 30; j++) { // Show appointments for the next 30 days
      DateTime appointmentDate = startTime.add(Duration(days: j));
      String frequency = medicine.frequencyType;

      switch (frequency) {
        case 'Daily':
          appointments.add(Appointment(
            startTime: appointmentDate,
            endTime: appointmentDate.add(Duration(hours: 1)), // Duration of the appointment
            subject: 'Take ${medicine.name}',
            color: Colors.blue,
          ));
          break;
        case 'Weekly':
          if (appointmentDate.weekday == 1) { // Assuming Monday as the frequency day
            appointments.add(Appointment(
              startTime: appointmentDate,
              endTime: appointmentDate.add(Duration(hours: 1)),
              subject: 'Take ${medicine.name}',
              color: Colors.blue,
            ));
          }
          break;
        case 'Every Other Day':
          if (j % 2 == 0) { // Every other day
            appointments.add(Appointment(
              startTime: appointmentDate,
              endTime: appointmentDate.add(Duration(hours: 1)),
              subject: 'Take ${medicine.name}',
              color: Colors.blue,
            ));
          }
          break;
        default:
          break;
      }
    }
  }




void _addAppointmentsForFoodIntake(Meal meal, List<Appointment> appointments) {
  DateTime startTime = DateTime(2024, 11, 1);
  DateFormat timeFormatter = DateFormat.jm();

  for (int j = 0; j < 30; j++) {
    // Set the appointmentDate to midnight of each day, ensuring accurate timing
    DateTime appointmentDate = DateTime(startTime.year, startTime.month, startTime.day).add(Duration(days: j));

    if ((meal.morning ?? false)) { // Morning appointment
      DateTime morningStart = appointmentDate.add(Duration(hours: 8)); // 8:00 AM
      DateTime morningEnd = appointmentDate.add(Duration(hours: 9)); // 9:00 AM
      appointments.add(Appointment(
        startTime: morningStart,
        endTime: morningEnd,
        subject: 'Breakfast (${timeFormatter.format(morningStart)} - ${timeFormatter.format(morningEnd)})',
        color: Colors.green,
      ));
    }
    if ((meal.afternoon ?? false)) { // Afternoon appointment
      DateTime afternoonStart = appointmentDate.add(Duration(hours: 12)); // 12:00 PM
      DateTime afternoonEnd = appointmentDate.add(Duration(hours: 13)); // 1:00 PM
      appointments.add(Appointment(
        startTime: afternoonStart,
        endTime: afternoonEnd,
        subject: 'Lunch (${timeFormatter.format(afternoonStart)} - ${timeFormatter.format(afternoonEnd)})',
        color: Colors.green,
      ));
    }
    if ((meal.night ?? false)) { // Night appointment
      DateTime nightStart = appointmentDate.add(Duration(hours: 20)); // 8:00 PM
      DateTime nightEnd = appointmentDate.add(Duration(hours: 21)); // 9:00 PM
      appointments.add(Appointment(
        startTime: nightStart,
        endTime: nightEnd,
        subject: 'Dinner (${timeFormatter.format(nightStart)} - ${timeFormatter.format(nightEnd)})',
        color: Colors.green,
      ));
    }
  }
}



  @override
  void dispose() {
    goalData.close(); // Close the box when the screen is disposed
    super.dispose();
  }

  void _onTapCalendar(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.calendarCell) {
      // Check if the tapped date is today
      if (details.date != null && isSameDay(details.date!, DateTime.now())) {
        // Filter today's goals
        List<Goal> todaysGoals = _getTodaysGoals();

        // Convert today's goals to appointments
        List<Appointment> todaysAppointments = _convertGoalsToAppointments(todaysGoals);

        // Navigate to today's goals screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodaysGoalsComplitionScreen(todaysGoals: todaysAppointments),
          ),
        );
      }
    }
  }

  List<Goal> _getTodaysGoals() {
    List<Goal> todaysGoals = [];

    for (int i = 0; i < goalData.length; i++) {
      final goal = goalData.getAt(i) as Goal;

      // Check if the goal has meals for today
      if (goal.targetValue != null) {
        Meal meal = goal.targetValue!;
        if ((meal.morning == true) || (meal.afternoon == true) || 
            (meal.evening == true) || (meal.night == true)) {
          todaysGoals.add(goal);
        }
      }
    }

    return todaysGoals;
  }

  List<Appointment> _convertGoalsToAppointments(List<Goal> goals) {
    List<Appointment> appointments = [];
print('----------------------------1---------------------');
    for (var goal in goals) {
      print('------------------------2-------------------------');
      // Assuming you can extract the necessary information from the Goal object
      // Example of creating an appointment:
      if (goal.medicines != null) {
        print('----------------------3---------------------------');
        for (var medicine in goal.medicines!) {
          print('-------------------4------------------------------');
          // Create appointments for medicines (you can customize this as needed)
          appointments.add(Appointment(
            startTime: DateTime.now(), // or some specific time
            endTime: DateTime.now().add(Duration(hours: 1)), // Example duration
            subject: 'Take ${medicine.name}',
            color: Colors.blue,
          ));
        }
        print('---------------------5----------------------------');
      }print('-----------------------6--------------------------');

      if (goal.targetValue != null) {
        print('-----------------------7--------------------------');
        // Handle food intake appointments similarly
        Meal meal = goal.targetValue!;
        print('----------------------8---------------------------');
        if (meal.morning == true) {
          appointments.add(Appointment(
            startTime: DateTime.now().add(Duration(hours: 8)), // Example time
            endTime: DateTime.now().add(Duration(hours: 9)),
            subject: 'Breakfast',
            color: Colors.green,
          ));
        }
        print('-----------------------9--------------------------');
        if (meal.afternoon == true) {
          print('----------------------10---------------------------');
          appointments.add(Appointment(
            startTime: DateTime.now().add(Duration(hours: 12)),
            endTime: DateTime.now().add(Duration(hours: 13)),
            subject: 'Lunch',
            color: Colors.green,
          ));
        }
        print('-------------------------11------------------------');
  
        print('-------------------------12------------------------');
        if (meal.night == true) {
          appointments.add(Appointment(
            startTime: DateTime.now().add(Duration(hours: 18)),
            endTime: DateTime.now().add(Duration(hours: 19)),
            subject: 'Dinner',
            color: Colors.green,
          ));
        }
        print('-------------------------13------------------------');
      }
    }

    return appointments;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Goals"),
      ),
      body:_isLoading
          ? Center(child: CircularProgressIndicator())
          : goalData.isOpen && goalData.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: SfCalendar(
                        view: CalendarView.month,
                        dataSource: GoalDataSource(_goalAppointments),
                        monthViewSettings: MonthViewSettings(showAgenda: true),
                        onTap: _onTapCalendar,
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text("No saved goals found"),
                ),
    );
  }
}

// DataSource class for SfCalendar
class GoalDataSource extends CalendarDataSource {
  GoalDataSource(List<Appointment> source) {
    appointments = source;
  }
}
