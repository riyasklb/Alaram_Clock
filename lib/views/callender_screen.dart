import 'package:alaram/views/bottum_nav/bottum_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


import '../tools/constans/model/hive_model.dart';

class ActivityCalendarScreen extends StatelessWidget {
  final Box<ActivityModel> _activityBox;

  ActivityCalendarScreen({Key? key})
      : _activityBox = Hive.box<ActivityModel>('activityBox'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Activity Calendar',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white), // Leading arrow color
          onPressed: () {
            Get.to(BottumNavBar());
          },
        ),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        onTap: (details) {
          if (details.targetElement == CalendarElement.calendarCell) {
            _showActivitiesForDate(details.date!, context);
          }
        },
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
          showAgenda: true,
        ),
        dataSource: ActivityDataSource(getActivities()),
        headerStyle: CalendarHeaderStyle(
          textAlign: TextAlign.center,
          textStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          backgroundColor: Colors.blueAccent,
        ),
      ),
    );
  }

  // Fetch activities from Hive and convert them to appointments
  List<Appointment> getActivities() {
    final activities = _activityBox.values.toList();
    final appointments = <Appointment>[];

    for (var activity in activities) {
      appointments.add(
        Appointment(
          startTime: DateTime(
              activity.date.year, activity.date.month, activity.date.day),
          endTime: DateTime(activity.date.year, activity.date.month,
              activity.date.day, 23, 59, 59),
          subject: 'Activity Logged',
          notes:
              'Walked: ${activity.minutesWalked} min\nSlept: ${activity.hoursSlept} hr\nWater: ${activity.waterIntake} L',
          color: Colors.blue,
          isAllDay: true,
        ),
      );
    }

    return appointments;
  }

  void _showActivitiesForDate(DateTime date, BuildContext context) {
    final activitiesOnDate = _activityBox.values
        .where((activity) =>
            activity.date.year == date.year &&
            activity.date.month == date.month &&
            activity.date.day == date.day)
        .toList();

    final healthValidationResult = _validateHealth(activitiesOnDate);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Activities on ${date.toLocal().toString().split(' ')[0]}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (activitiesOnDate.isNotEmpty) ...[
                  ...activitiesOnDate.map((activity) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('Walked: ${activity.minutesWalked} min'),
                        subtitle: Text(
                            'Slept: ${activity.hoursSlept} hr, Water: ${activity.waterIntake} L'),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 10),
                ] else ...[
                  Text('No activities logged.',
                      style: TextStyle(color: Colors.grey)),
                ],
                Text(
                  'Health Validation Result: $healthValidationResult',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to validate health based on activity logs
  String _validateHealth(List<ActivityModel> activities) {
    int totalMinutesWalked = 0;
    int totalHoursSlept = 0;
    double totalWaterIntake = 0.0;

    for (var activity in activities) {
      totalMinutesWalked += activity.minutesWalked;
      totalHoursSlept += activity.hoursSlept;
      totalWaterIntake += activity.waterIntake;
    }

    // Define health criteria
    const int recommendedMinutesWalking = 30; // minutes
    const int recommendedHoursSleeping = 7; // hours
    const double recommendedWaterIntake = 2.0; // liters

    String validationResult = 'Good';

    if (totalMinutesWalked < recommendedMinutesWalking) {
      validationResult = 'Increase walking time.';
    }
    if (totalHoursSlept < recommendedHoursSleeping) {
      validationResult = 'Improve sleep duration.';
    }
    if (totalWaterIntake < recommendedWaterIntake) {
      validationResult = 'Increase water intake.';
    }

    return validationResult;
  }
}

// Data source for Syncfusion Calendar
class ActivityDataSource extends CalendarDataSource {
  ActivityDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}
