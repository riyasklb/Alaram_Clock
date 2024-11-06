import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:alaram/tools/constans/model/activity_log.dart';

class ActivityLogScreen extends StatefulWidget {
  @override
  _ActivityLogScreenState createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  // Initialize _activityLogs as an empty list
  List<ActivityLog> _activityLogs = [];
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadActivityLogs();
  }

  // Load stored activity logs from Hive
  Future<void> _loadActivityLogs() async {
    var box = await Hive.openBox<ActivityLog>('activityLogs');
    setState(() {
      _activityLogs = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Activity Log',
          style: GoogleFonts.lato(fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          _buildCalendar(),
          Expanded(child: _buildActivityLogList()),
        ],
      ),
    );
  }

  // Build the calendar to show the dates with activity logs
  Widget _buildCalendar() {
    return Container(
      height: 300.h,
      child: SfCalendar(
        view: CalendarView.month,
        onSelectionChanged: (details) {
          setState(() {
            _selectedDate = details.date!; // Use 'details.date' instead of 'details.selectedDate'
          });
        },
      ),
    );
  }

  // Build the list of activity logs for the selected date
  Widget _buildActivityLogList() {
    final selectedLogs = _activityLogs
        .where((log) =>
            log.date.year == _selectedDate.year &&
            log.date.month == _selectedDate.month &&
            log.date.day == _selectedDate.day)
        .toList();

    if (selectedLogs.isEmpty) {
      return Center(
        child: Text(
          'No activities recorded for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
          style: GoogleFonts.roboto(fontSize: 18.sp, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: selectedLogs.length,
      itemBuilder: (context, index) {
        final activityLog = selectedLogs[index];
        return _buildActivityLogCard(activityLog);
      },
    );
  }

  // Build each activity log card
  Widget _buildActivityLogCard(ActivityLog activityLog) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${activityLog.date.day}/${activityLog.date.month}/${activityLog.date.year}',
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8.h),
            _buildLogDetail('Sleep', '${activityLog.sleepHours} hours'),
            _buildLogDetail('Walking', '${activityLog.walkingHours} hours'),
            _buildLogDetail('Water Intake', '${activityLog.waterIntake} liters'),
          ],
        ),
      ),
    );
  }

  // Build log details for each activity
  Widget _buildLogDetail(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
