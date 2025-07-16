import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/cutomwidget/cutom_home_button.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:alaram/tools/model/activity_log.dart';

class ActivitySleeplog extends StatefulWidget {
  @override
  _ActivitySleeplogState createState() => _ActivitySleeplogState();
}

class _ActivitySleeplogState extends State<ActivitySleeplog> {
  List<ActivityLog> _activityLogs = [];
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadActivityLogs();
  }

  Future<void> _loadActivityLogs() async {
    var box = await Hive.openBox<ActivityLog>(sleepactivitys);
    setState(() {
      _activityLogs = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        title: Text(
          'Activity Log',
          style: GoogleFonts.lato(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: kblue,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildCalendar(),
          Expanded(child: _buildActivityLogList()),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: CustomHomeButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      height: 280.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color.fromARGB(123, 229, 221, 253), kwhite],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SfCalendar(
        view: CalendarView.month,
        backgroundColor: Colors.transparent,
        onSelectionChanged: (details) {
          setState(() {
            _selectedDate = details.date!;
          });
        },
      ),
    );
  }

  Widget _buildActivityLogList() {
    final selectedLogs = _activityLogs
        .where((log) =>
            log.date.year == _selectedDate.year &&
            log.date.month == _selectedDate.month &&
            log.date.day == _selectedDate.day)
        .toList();

    if (selectedLogs.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Text(
            'No activities recorded for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      itemCount: selectedLogs.length,
      itemBuilder: (context, index) {
        final activityLog = selectedLogs[index];
        return _buildActivityLogCard(activityLog);
      },
    );
  }

  Widget _buildActivityLogCard(ActivityLog activityLog) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      elevation: 8,
      color: Colors.deepPurple[50],
      shadowColor: Colors.purpleAccent.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${activityLog.date.day}/${activityLog.date.month}/${activityLog.date.year}',
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10.h),
            Divider(color: Colors.deepPurple[100], thickness: 1),
            SizedBox(height: 8.h),
            _buildLogDetail('💤 Sleep', '${activityLog.sleepHours} hours'),
            _buildLogDetail('🚶 Walking', '${activityLog.walkingHours} hours'),
            _buildLogDetail('💧 Water Intake', '${activityLog.waterIntake} liters'),
          ],
        ),
      ),
    );
  }

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
              color: Colors.deepPurple,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
