import 'package:alaram/tools/constans/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:alaram/tools/constans/model/daily_activity_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DailyActivityOverviewScreen extends StatefulWidget {
  @override
  _DailyActivityOverviewScreenState createState() =>
      _DailyActivityOverviewScreenState();
}

class _DailyActivityOverviewScreenState
    extends State<DailyActivityOverviewScreen> {
  late Box<DailyActivityModel> activityBox;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    activityBox = Hive.box<DailyActivityModel>('dailyActivities');
  }

  // Filter activities by selected date
  List<DailyActivityModel> _getActivitiesForSelectedDate() {
    return activityBox.values.where((activity) {
      return DateFormat('yyyy-MM-dd').format(activity.date) ==
          DateFormat('yyyy-MM-dd').format(_selectedDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            child: ValueListenableBuilder(
              valueListenable: activityBox.listenable(),
              builder: (context, Box<DailyActivityModel> box, _) {
                final activities = _getActivitiesForSelectedDate();
                
                if (activities.isEmpty) {
                  return Center(
                    child: Text(
                      "No activity data available for the selected date.",
                      style: GoogleFonts.lato(fontSize: 16, color: Colors.blueGrey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
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
                                  color: activity.isActivityCompleted
                                      ? Colors.green
                                      : Colors.red,
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
                                color: activity.isActivityCompleted
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            if (activity.medicines != null &&
                                activity.medicines!.isNotEmpty)
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
                                              style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[700]),
                                            ),
                                            Text(
                                              "  Times: ${medicine.selectedTimes.join(', ')}",
                                              style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[700]),
                                            ),
                                            Text(
                                              "  Completion Status: ${medicine.taskCompletionStatus.toString()}",
                                              style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[700]),
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
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
