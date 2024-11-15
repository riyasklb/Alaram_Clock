import 'package:alaram/tools/controllers/activity_controller.dart';
import 'package:alaram/tools/model/activity_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DailyActivitiesWidget extends StatefulWidget {
  final ActivityController activityController;

  const DailyActivitiesWidget({Key? key, required this.activityController}) : super(key: key);

  @override
  _DailyActivitiesWidgetState createState() => _DailyActivitiesWidgetState();
}

class _DailyActivitiesWidgetState extends State<DailyActivitiesWidget> {
  @override
  Widget build(BuildContext context) {
    // Use widget.activityController to access activityController data
    if (widget.activityController.dailyActivities.isEmpty) {
      return Center(child: Text("No daily activities recorded."));
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: widget.activityController.dailyActivities.map((activity) {
          DateTime date = DateTime.parse(activity.date.toString());
          String formattedDate = DateFormat('MMMM d, yyyy').format(date);

          // Find the matching ActivityLog entry by date
          ActivityLog? matchingLog = widget.activityController.activityLogs.firstWhere(
            (log) =>
                log.date.year == date.year &&
                log.date.month == date.month &&
                log.date.day == date.day,
            orElse: () => ActivityLog(date: date, sleepHours: 0, walkingHours: 0, waterIntake: 0),
          );

          return Card(
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'Task Date: $formattedDate',
                      style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Display sleep, walking, and water intake from matching ActivityLog
                  SizedBox(height: 8.h),
                  _buildActivityRow(
                    icon: Icons.nightlight_round,
                    color: Colors.blue,
                    label: 'Sleep',
                    value: '${matchingLog.sleepHours.toStringAsFixed(1)} hrs',
                  ),
                  _buildActivityRow(
                    icon: Icons.directions_walk,
                    color: Colors.green,
                    label: 'Walking',
                    value: '${matchingLog.walkingHours.toStringAsFixed(1)} hrs',
                  ),
                  _buildActivityRow(
                    icon: Icons.local_drink,
                    color: Colors.teal,
                    label: 'Water Intake',
                    value: '${matchingLog.waterIntake.toStringAsFixed(1)} L',
                  ),

                  // Medicines Section
                  if (activity.medicines != null && activity.medicines!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        Text("Medicines:", style: GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        ...activity.medicines!.map((medicine) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("  • ${medicine.name}", style: GoogleFonts.roboto(fontSize: 14.sp)),
                                  Text("    - Frequency: ${medicine.frequency}", style: GoogleFonts.roboto(fontSize: 14.sp)),
                                  Text("    - Times: ${medicine.selectedTimes.join(", ")}", style: GoogleFonts.roboto(fontSize: 14.sp)),
                                  Row(
                                    children: [
                                      Text(
                                        "  Completion Status: ${medicine.taskCompletionStatus.values.every((status) => status) ? "Taken Properly" : "Not Taken"}",
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: medicine.taskCompletionStatus.values.every((status) => status)
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                      Icon(
                                        medicine.taskCompletionStatus.values.every((status) => status)
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: medicine.taskCompletionStatus.values.every((status) => status)
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ],
                                  ),
                                  if (medicine.taskCompletionStatus.values.any((status) => !status))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Skipped Times:",
                                            style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                          ),
                                          ...medicine.taskCompletionStatus.entries
                                              .where((entry) => !entry.value)
                                              .map((entry) => Text(
                                                    "• ${entry.key}",
                                                    style: GoogleFonts.lato(fontSize: 12, color: Colors.red[700]),
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

                  // Meal Section
                  if (activity.mealValue != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        Text("Meal Times:", style: GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(
                              activity.mealValue!.morning ? Icons.check_circle : Icons.cancel,
                              color: activity.mealValue!.morning ? Colors.green : Colors.red,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text("Morning", style: GoogleFonts.roboto(fontSize: 14.sp)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              activity.mealValue!.afternoon ? Icons.check_circle : Icons.cancel,
                              color: activity.mealValue!.afternoon ? Colors.green : Colors.red,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text("Afternoon", style: GoogleFonts.roboto(fontSize: 14.sp)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              activity.mealValue!.night ? Icons.check_circle : Icons.cancel,
                              color: activity.mealValue!.night ? Colors.green : Colors.red,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text("Night", style: GoogleFonts.roboto(fontSize: 14.sp)),
                          ],
                        ),
                        SizedBox(height: 10),
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
        }).toList(),
      ),
    );
  }

  Widget _buildActivityRow({required IconData icon, required Color color, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20.sp),
        SizedBox(width: 8.w),
        Text("$label: $value", style: GoogleFonts.roboto(fontSize: 14.sp)),
      ],
    );
  }
}
