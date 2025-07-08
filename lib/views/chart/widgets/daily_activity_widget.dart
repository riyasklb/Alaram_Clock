import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/controllers/activity_controller.dart';
import 'package:alaram/tools/model/activity_log.dart';
import 'package:alaram/tools/model/daily_activity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DailyActivitiesWidget extends StatefulWidget {
  //final ActivityController activityController;

  const DailyActivitiesWidget({
    Key? key,
  }) : super(key: key);

  @override
  _DailyActivitiesWidgetState createState() => _DailyActivitiesWidgetState();
}

class _DailyActivitiesWidgetState extends State<DailyActivitiesWidget> {
  final ActivityController activityController = Get.find();
  DateTime? _searchDate;
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  @override
  Widget build(BuildContext context) {
    final filteredActivities =
        activityController.dailyActivities.where((activity) {
      final date = DateTime.parse(activity.date.toString());

      // Filter by date
      if (_searchDate != null) {
        if (!(date.year == _searchDate!.year &&
            date.month == _searchDate!.month &&
            date.day == _searchDate!.day)) {
          return false;
        }
      }

      // Filter by additional notes
      if (_searchController.text.isNotEmpty) {
        final log = activityController.activityLogs.firstWhere(
          (log) =>
              log.date.year == date.year &&
              log.date.month == date.month &&
              log.date.day == date.day,
          orElse: () => ActivityLog(
              date: date, sleepHours: 0, walkingHours: 0, waterIntake: 0),
        );

        final notes = log.additionalInformation ?? '';
        if (!notes
            .toLowerCase()
            .contains(_searchController.text.toLowerCase())) {
          return false;
        }
      }

      return true;
    }).toList();

    return Scaffold(backgroundColor: kwhite,
      appBar: AppBar(
          title: Text(
          'All Activity Logs',
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600,color: kwhite),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
    
        actions: [
          IconButton(
            icon: Icon(_showSearchBar ? Icons.close : Icons.search,color: kwhite,),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
                if (!_showSearchBar) {
                  _searchDate = null;
                  _searchController.clear();
                }
              });
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              // Search toggle button
           

              // Search bar
              if (_showSearchBar) _buildSearchBar(),

              // Activities list
              if (filteredActivities.isEmpty)
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    "No matching activities found",
                    style: GoogleFonts.roboto(fontSize: 16.sp),
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: filteredActivities.map((activity) {
                      DateTime date = DateTime.parse(activity.date.toString());
                      String formattedDate =
                          DateFormat('MMMM d, yyyy').format(date);

                      ActivityLog? matchingLog =
                          activityController.activityLogs.firstWhere(
                        (log) =>
                            log.date.year == date.year &&
                            log.date.month == date.month &&
                            log.date.day == date.day,
                        orElse: () => ActivityLog(
                            date: date,
                            sleepHours: 0,
                            walkingHours: 0,
                            waterIntake: 0),
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

                              // Health metrics
                              _buildActivityRow(
                                icon: Icons.nightlight_round,
                                color: Colors.blue,
                                label: 'Sleep',
                                value:
                                    '${matchingLog.sleepHours.toStringAsFixed(1)} hrs',
                              ),
                              _buildActivityRow(
                                icon: Icons.directions_walk,
                                color: Colors.green,
                                label: 'Walking',
                                value:
                                    '${matchingLog.walkingHours.toStringAsFixed(1)} hrs',
                              ),
                              _buildActivityRow(
                                icon: Icons.local_drink,
                                color: Colors.teal,
                                label: 'Water Intake',
                                value:
                                    '${matchingLog.waterIntake.toStringAsFixed(1)} L',
                              ),

                              // Additional notes
                              if (matchingLog.additionalInformation != null &&
                                  matchingLog.additionalInformation!
                                      .trim()
                                      .isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Additional Notes:',
                                        style: GoogleFonts.roboto(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        matchingLog.additionalInformation!,
                                        style: GoogleFonts.roboto(
                                          fontSize: 16.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Medicines section
                              if (activity.medicines != null &&
                                  activity.medicines!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8.h),
                                    Text("Medicines:",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold)),
                                    ...activity.medicines!
                                        .map((medicine) => Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.h),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("  • ${medicine.name}",
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 14.sp)),
                                                  Text(
                                                      "    - Frequency: ${medicine.frequency}",
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 14.sp)),
                                                  Text(
                                                      "    - Times: ${medicine.selectedTimes.join(", ")}",
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 14.sp)),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Completion: ${medicine.taskCompletionStatus.values.every((status) => status) ? "Taken" : "Missed"}",
                                                        style: GoogleFonts.lato(
                                                          fontSize: 12.sp,
                                                          color: medicine
                                                                  .taskCompletionStatus
                                                                  .values
                                                                  .every(
                                                                      (status) =>
                                                                          status)
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                      ),
                                                      Icon(
                                                        medicine.taskCompletionStatus
                                                                .values
                                                                .every(
                                                                    (status) =>
                                                                        status)
                                                            ? Icons.check_circle
                                                            : Icons.cancel,
                                                        size: 16.sp,
                                                        color: medicine
                                                                .taskCompletionStatus
                                                                .values
                                                                .every(
                                                                    (status) =>
                                                                        status)
                                                            ? Colors.green
                                                            : Colors.red,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )),
                                  ],
                                ),

                              // Meal section
                              if (activity.mealValue != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8.h),
                                    Text("Meal Times:",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold)),
                                    ..._buildMealRows(activity.mealValue!),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🗓 Date picker row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 20.sp, color: Colors.deepPurple),
                    SizedBox(width: 8.w),
                    Text(
                      _searchDate == null
                          ? "Select a date"
                          : DateFormat('MMMM d, yyyy').format(_searchDate!),
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      setState(() => _searchDate = selectedDate);
                    }
                  },
                  icon: Icon(Icons.date_range),
                  label: Text("Pick Date"),
                  style:
                      TextButton.styleFrom(foregroundColor: Colors.deepPurple),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // 📝 Additional notes search
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search additional notes',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _searchController.clear());
                        },
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 12.h),

            // 🧹 Clear filters
            if (_searchDate != null || _searchController.text.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _searchDate = null;
                      _searchController.clear();
                    });
                  },
                  icon: Icon(Icons.refresh),
                  label: Text("Clear Filters"),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMealRows(DailyactivityMealValue meal) {
    return [
      _buildMealRow("Morning", meal.morning),
      _buildMealRow("Afternoon", meal.afternoon),
      _buildMealRow("Night", meal.night),
      SizedBox(height: 10.h),
      Row(
        children: [
          Icon(
            meal.morning && meal.afternoon && meal.night
                ? Icons.check_circle
                : Icons.cancel,
            color: meal.morning && meal.afternoon && meal.night
                ? Colors.green
                : Colors.red,
          ),
          SizedBox(width: 8.w),
          Text(
            "All meals taken",
            style: GoogleFonts.lato(
              fontSize: 14.sp,
              color: meal.morning && meal.afternoon && meal.night
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildMealRow(String label, bool status) {
    return Row(
      children: [
        Icon(
          status ? Icons.check_circle : Icons.cancel,
          color: status ? Colors.green : Colors.red,
          size: 16.sp,
        ),
        SizedBox(width: 8.w),
        Text(label, style: GoogleFonts.roboto(fontSize: 14.sp)),
      ],
    );
  }

  Widget _buildActivityRow(
      {required IconData icon,
      required Color color,
      required String label,
      required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(width: 8.w),
          Text("$label: $value", style: GoogleFonts.roboto(fontSize: 14.sp)),
        ],
      ),
    );
  }
}
