import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/model/activity_log.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:alaram/tools/model/daily_activity_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DailyMedicineActivityLog extends StatefulWidget {
  @override
  _DailyMedicineActivityLogState createState() =>
      _DailyMedicineActivityLogState();
}

class _DailyMedicineActivityLogState extends State<DailyMedicineActivityLog> {
  Box<DailyActivityModel>? activityMedicineBox;
  Box<ActivityLog>? activitySleepBox;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Initialize Hive boxes and ensure they are opened before accessing
    Hive.openBox<DailyActivityModel>('dailyActivities').then((box) {
      setState(() {
        activityMedicineBox = box;
      });
    });
    Hive.openBox<ActivityLog>('activityLogs').then((box) {
      setState(() {
        activitySleepBox = box;
      });
    });
  }

  // Filter activities by selected date
  List<DailyActivityModel> _getActivitiesForSelectedDate() {
    if (activityMedicineBox == null) return [];
    return activityMedicineBox!.values.where((activity) {
      return DateFormat('yyyy-MM-dd').format(activity.date) ==
          DateFormat('yyyy-MM-dd').format(_selectedDate);
    }).toList();
  }

// Fetch ActivityLog data for the selected date
  ActivityLog? _getActivityLogForSelectedDate() {
    if (activitySleepBox == null) return null;
    try {
      return activitySleepBox!.values.firstWhere(
        (log) =>
            DateFormat('yyyy-MM-dd').format(log.date) ==
            DateFormat('yyyy-MM-dd').format(_selectedDate),
      );
    } catch (e) {
      return null; // Return null if no matching log is found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Daily Activities Overview",
          style: GoogleFonts.lato(color: kwhite),
        ),
        backgroundColor: kblue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Calendar Widget
          TableCalendar(
            focusedDay: _selectedDate,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: CalendarFormat.week,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
          ),
   Expanded(
  child: activityMedicineBox == null || activitySleepBox == null
      ? Center(child: CircularProgressIndicator())
      : ValueListenableBuilder(
          valueListenable: activityMedicineBox!.listenable(),
          builder: (context, Box<DailyActivityModel> box, _) {
            final activities = _getActivitiesForSelectedDate();
            final activityLog = _getActivityLogForSelectedDate();

            print('activities: $activities');
            print('activityLog: $activityLog');

            // Checking for the scenario where activityLog is not empty but activities is empty or null
            if ((activities.isEmpty || activities == null) && activityLog == null) {
              print('-------------------------1-------------');
              return Center(
                child: Text(
                  "No activity data available for the selected date.",
                  style: GoogleFonts.lato(
                      fontSize: 16, color: Colors.blueGrey),
                ),
              );
            } else if (activities.isNotEmpty && activityLog == null) {
              print('----------------------2----------------');
              return ListView(
                children: [
                  Text(
                    "You didn’t update your activity for this day.",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ...activities
                      .map((activity) => _buildActivityCard(activity))
                      .toList(),
                ],
              );
            } else if (activityLog != null && (activities.isEmpty || activities == null)) {
              print('---------------------3-----------------');
              return ListView(
                children: [
                  Text(
                    "You have activity logs but no updated activities.",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Display the activity log here, if activityLog is a single object.
                  _buildActivityLogCard(activityLog),
                ],
              );
            } else {
              print('------------------------------4-------------');
              return ListView(
                children: [
                  if (activityLog != null)
                    _buildActivityLogCard(activityLog),
                  ...activities
                      .map((activity) => _buildActivityCard(activity))
                      .toList(),
                ],
              );
            }
          },
        ),
)



        ],
      ),
    );
  }

  Widget _buildActivityLogCard(ActivityLog activityLog) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daily Summary",
              style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800]),
            ),
            Divider(color: Colors.blueGrey[200]),
            Text(
              "Sleep Hours: ${activityLog.sleepHours} hrs",
              style: GoogleFonts.lato(fontSize: 16),
            ),
            Text(
              "Walking Hours: ${activityLog.walkingHours} hrs",
              style: GoogleFonts.lato(fontSize: 16),
            ),
            Text(
              "Water Intake: ${activityLog.waterIntake} liters",
              style: GoogleFonts.lato(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(DailyActivityModel activity) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  activity.activityName,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blueGrey[800],
                  ),
                ),
                Icon(
                  activity.isActivityCompleted
                      ? Icons.check_circle
                      : Icons.cancel,
                  color:
                      activity.isActivityCompleted ? Colors.green : Colors.red,
                ),
              ],
            ),
            SizedBox(height: 6),
            Divider(color: Colors.blueGrey[200]),
            SizedBox(height: 6),
            Text(
              "Date: ${DateFormat('yyyy-MM-dd').format(activity.date)}",
              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Text(
              "Goal Status: ${activity.isActivityCompleted ? "Completed" : "Not Completed"}",
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: activity.isActivityCompleted ? Colors.green : Colors.red,
              ),
            ),
            if (activity.medicines != null && activity.medicines!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Text(
                    "Medicines",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  ...activity.medicines!.map((medicine) => Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ${medicine.name}",
                                style: GoogleFonts.lato(fontSize: 14)),
                            Text(
                              "  Frequency: ${medicine.frequency}",
                              style: GoogleFonts.lato(
                                  fontSize: 12, color: Colors.grey[700]),
                            ),
                            Text(
                              "  Times: ${medicine.selectedTimes.join(', ')}",
                              style: GoogleFonts.lato(
                                  fontSize: 12, color: Colors.grey[700]),
                            ),
                            Row(
                              children: [
                                Text(
                                  "  Completion Status: ${medicine.taskCompletionStatus.values.every((status) => status) ? "Taken Properly" : "Not Taken"}",
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: medicine.taskCompletionStatus.values
                                            .every((status) => status)
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                Icon(
                                  medicine.taskCompletionStatus.values
                                          .every((status) => status)
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: medicine.taskCompletionStatus.values
                                          .every((status) => status)
                                      ? Colors.green
                                      : Colors.red,
                                  size: 16,
                                ),
                              ],
                            ),
                            if (medicine.taskCompletionStatus.values
                                .any((status) => !status))
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Skipped Times:",
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    ...medicine.taskCompletionStatus.entries
                                        .where((entry) => !entry
                                            .value) // Filter for skipped times
                                        .map((entry) => Text(
                                              "• ${entry.key}", // Display each skipped time
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Colors.red[700],
                                              ),
                                            ))
                                        .toList(),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      )),
                ],
              ),
            if (activity.mealValue != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Text(
                    "Meal Timings",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  if (activity.mealValue!.morning)
                    Text("• Breakfast: 8:00 - 9:00 AM",
                        style: GoogleFonts.lato(fontSize: 14)),
                  if (activity.mealValue!.afternoon)
                    Text("• Lunch: 12:00 - 1:00 PM",
                        style: GoogleFonts.lato(fontSize: 14)),
                  if (activity.mealValue!.night)
                    Text("• Dinner: 8:00 - 9:00 PM",
                        style: GoogleFonts.lato(fontSize: 14)),
                  SizedBox(height: 12),
                  // Show food intake status
                  Row(
                    children: [
                      Icon(
                        activity.mealValue!.morning &&
                                activity.mealValue!.afternoon &&
                                activity.mealValue!.night
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: activity.mealValue!.morning &&
                                activity.mealValue!.afternoon &&
                                activity.mealValue!.night
                            ? Colors.green
                            : Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Food taken properly",
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: activity.mealValue!.morning &&
                                  activity.mealValue!.afternoon &&
                                  activity.mealValue!.night
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
