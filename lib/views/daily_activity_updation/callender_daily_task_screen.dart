import 'package:alaram/tools/model/goal_model.dart';
import 'package:alaram/views/auth/set_goals_scrrw.dart';
import 'package:alaram/views/auth/set_goals_with_remider_screen.dart';
import 'package:alaram/views/daily_activity_updation/dailyactivity_medicine_update_screen.dart';
import 'package:alaram/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';



class DailyMedicneTaskCallenderScreen extends StatefulWidget {
  @override
  _DailyMedicneTaskCallenderScreenState createState() => _DailyMedicneTaskCallenderScreenState();
}



class _DailyMedicneTaskCallenderScreenState extends State<DailyMedicneTaskCallenderScreen> {
  late Box<Goal> goalData;
  List<Appointment> _goalAppointments = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _openBox();
    printAllGoals();
  }

void printAllGoals() async {
  // Open the box
  var goalData = await Hive.openBox<Goal>('goals');

  // Iterate through all goals
  for (var goal in goalData.values) {
    print('--- Goal ---');
    print('Goal ID: ${goal.goalId}');
    print('Goal Type: ${goal.goalType}');
    print('Date: ${goal.date}');
    print('Skipped: ${goal.skipped}');

    // Print Meal info
    if (goal.MealValue != null) {
      print('Meal Details:');
      print('  Morning: ${goal.MealValue?.morning}');
      print('  Afternoon: ${goal.MealValue?.afternoon}');
      print('  Evening: ${goal.MealValue?.evening}');
      print('  Night: ${goal.MealValue?.night}');
    } else {
      print('Meal: None');
    }

    // Print Medicine info
    if (goal.medicines != null && goal.medicines!.isNotEmpty) {
      print('Medicines:');
      for (var med in goal.medicines!) {
        print('  Name: ${med.name}');
        print('  Frequency Type: ${med.frequencyType}');
        print('  Dosage: ${med.dosage}');
        print('  Quantity: ${med.quantity}');
        print('  Next Intake Date: ${med.nextIntakeDate}');
        print('  Selected Times: ${med.selectedTimes.join(', ')}');
      }
    } else {
      print('Medicines: None');
    }

    print('--------------\n');
  }
}

  Future<void> _openBox() async {
    goalData = await Hive.openBox<Goal>('goals');
    
    _loadGoalAppointments();
   
    setState(() {
      _isLoading = false; // Set loading to false after initialization
    });

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
      print('----------------4----------------');
      for (var medicine in goal.medicines!) {
        _addAppointmentsForMedicine(medicine, appointments);
      }
       print('----------------5----------------');
    }

    // Create appointments for food intake
    if (goal.MealValue != null) {
      _addAppointmentsForFoodIntake(goal.MealValue!, appointments);
    }
     print('----------------6----------------');
  }

  setState(() {
    _goalAppointments = appointments; // Update the appointments list
  });
}


void _addAppointmentsForMedicine(Medicine medicine, List<Appointment> appointments) {
  DateTime startTime = DateTime.now(); // Starting from today
  DateFormat timeFormatter = DateFormat.jm();

  for (int j = 0; j < 30; j++) { // Show appointments for the next 30 days
    // Set the appointment date to midnight for each day
    DateTime appointmentDate = DateTime(startTime.year, startTime.month, startTime.day).add(Duration(days: j));
    String frequency = medicine.frequencyType;

    // Determine which times of day the medicine should be taken
    for (String timeOfDay in medicine.selectedTimes) {
      DateTime time;
      
      switch (timeOfDay) {
        case 'Morning':
          time = appointmentDate.add(Duration(hours: 8)); // 8:00 AM
          break;
        case 'Afternoon':
          time = appointmentDate.add(Duration(hours: 12)); // 12:00 PM
          break;
        case 'Evening':
          time = appointmentDate.add(Duration(hours: 18)); // 6:00 PM
          break;
        case 'Night':
          time = appointmentDate.add(Duration(hours: 20)); // 8:00 PM
          break;
        default:
          continue;
      }

      if (_shouldAddAppointment(j, frequency)) {
        appointments.add(Appointment(
          startTime: time,
          endTime: time.add(Duration(hours: 1)),
          subject: 'Take ${medicine.name} (${timeFormatter.format(time)})',
          color: Colors.blue,
        ));
      }
    }
  }
}


// Helper method to determine if an appointment should be added based on frequency
bool _shouldAddAppointment(int dayIndex, String frequency) {
  switch (frequency) {
    case 'Daily':
      return true;
    case 'Weekly':
      return dayIndex % 7 == 0;
    case 'Every Other Day':
      return dayIndex % 2 == 0;
    default:
      return false;
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
    if (details.date != null && isSameDay(details.date!, DateTime.now())) {
      List<Goal> todaysGoals = _getTodaysGoals();
      List<Appointment> todaysAppointments = _convertGoalsToAppointments(todaysGoals);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DailyActivityUpdateMedicineScreen(
            todaysGoals: todaysGoals,
         //   todaysAppointments: todaysAppointments,
          ),
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
      if (goal.MealValue != null) {
        Meal meal = goal.MealValue!;
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
print('----------------------------1-------1--------------');
    for (var goal in goals) {
      print('------------------------2-------2------------------');
      // Assuming you can extract the necessary information from the Goal object
      // Example of creating an appointment:
      if (goal.medicines != null) {
        print('----------------------3---------3------------------');
        for (var medicine in goal.medicines!) {
          print('-------------------4-----------4-------------------');
          // Create appointments for medicines (you can customize this as needed)
          appointments.add(Appointment(
            startTime: DateTime.now(), // or some specific time
            endTime: DateTime.now().add(Duration(hours: 1)), // Example duration
            subject: 'Take ${medicine.name}',
            color: Colors.blue,
          ));
        }
        print('---------------------5-----------5-----------------');
      }print('-----------------------6------------6--------------');

      if (goal.MealValue != null) {
        print('-----------------------7-----------7---------------');
        // Handle food intake appointments similarly
        Meal meal = goal.MealValue!;
        print('----------------------8------------8---------------');
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
      appBar: AppBar(leading: IconButton(onPressed: (){Get.to(HomeScreen());}, icon: Icon(Icons.arrow_back)),
        title: Text("Saved Goals"),
          actions: [
    IconButton(
      icon: Icon(Icons.edit, size: 22.sp),
      tooltip: 'Edit Goals',
   onPressed: () {
  Get.to(
    OptionalGoalSettingScreen(),
    
  );
}
    ),
  ],
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
