import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:alaram/tools/constans/model/daily_activity_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DailyCallenderScreen extends StatefulWidget {
  @override
  _DailyCallenderScreenState createState() => _DailyCallenderScreenState();
}

class _DailyCallenderScreenState extends State<DailyCallenderScreen> {
  late Box<DailyActivityModel> activityBox;
  DailyActivityModel? selectedActivity;

  @override
  void initState() {
    super.initState();
    activityBox = Hive.box<DailyActivityModel>('dailyActivities');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Activities Overview", style: GoogleFonts.lato()),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: ValueListenableBuilder(
              valueListenable: activityBox.listenable(),
              builder: (context, Box<DailyActivityModel> box, _) {
                if (box.isEmpty) {
                  return Center(
                    child: Text(
                      "No activity data available.",
                      style: GoogleFonts.lato(fontSize: 16),
                    ),
                  );
                }

                final activities = box.values.toList();
                final activityDataSource = ActivityDataSource(activities);

                return SfCalendar(
                  view: CalendarView.month,
                  dataSource: activityDataSource,
                  monthViewSettings: MonthViewSettings(showAgenda: true),
                  onTap: (CalendarTapDetails details) {
                    if (details.targetElement == CalendarElement.appointment) {
                      final activity = details.appointments![0] as DailyActivityModel;
                      setState(() {
                        selectedActivity = activity;
                      });
                    }
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: selectedActivity != null
                ? ActivityDetailView(activity: selectedActivity!)
                : Center(
                    child: Text(
                      "Select an activity to see details",
                      style: GoogleFonts.lato(fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class ActivityDetailView extends StatelessWidget {
  final DailyActivityModel activity;

  ActivityDetailView({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity.activityName,
              style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Date: ${DateFormat('yyyy-MM-dd').format(activity.date)}", style: GoogleFonts.lato()),
            Text("Frequency: ${activity.frequency}", style: GoogleFonts.lato()),
            Text("Completed: ${activity.isActivityCompleted ? "Yes" : "No"}", style: GoogleFonts.lato()),
            if (activity.medicines != null && activity.medicines!.isNotEmpty) ...[
              SizedBox(height: 8),
              Text("Medicines:", style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
              for (var medicine in activity.medicines!)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• ${medicine.name}", style: GoogleFonts.lato()),
                      Text("  Frequency: ${medicine.frequency}", style: GoogleFonts.lato()),
                      Text("  Times: ${medicine.selectedTimes.join(', ')}", style: GoogleFonts.lato()),
                      Text("  Completion Status: ${medicine.taskCompletionStatus}", style: GoogleFonts.lato()),
                    ],
                  ),
                ),
            ],
            if (activity.mealValue != null) ...[
              SizedBox(height: 8),
              Text("Meal Timings:", style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
              if (activity.mealValue!.morning) Text("• Breakfast: 8:00 - 9:00 AM", style: GoogleFonts.lato()),
              if (activity.mealValue!.afternoon) Text("• Lunch: 12:00 - 1:00 PM", style: GoogleFonts.lato()),
              if (activity.mealValue!.night) Text("• Dinner: 8:00 - 9:00 PM", style: GoogleFonts.lato()),
            ],
          ],
        ),
      ),
    );
  }
}

class ActivityDataSource extends CalendarDataSource {
  ActivityDataSource(List<DailyActivityModel> activities) {
    appointments = activities;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].date;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].date.add(Duration(hours: 1));
  }

  @override
  String getSubject(int index) {
    return appointments![index].activityName;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }
}
