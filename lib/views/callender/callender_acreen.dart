import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalCalendarScreen extends StatefulWidget {
  @override
  _GoalCalendarScreenState createState() => _GoalCalendarScreenState();
}

class _GoalCalendarScreenState extends State<GoalCalendarScreen> {
  List<Appointment> _goalAppointments = [];
  final Map<String, String> timeMapping = {
    'Morning': '08:00',
    'Afternoon': '12:00',
    'Evening': '18:00',
    'Night': '20:00',
  };

  @override
  void initState() {
    super.initState();
    _loadGoalData();
  }

  // Method to load goal data from Hive
  Future<void> _loadGoalData() async {
    final box = await Hive.openBox('goalBox');
    List<Appointment> appointments = [];

    // Fetch medicine and injection times and other fields
    List<String> medicineTimes = List<String>.from(box.get('medicineTimes', defaultValue: []));
    String medicineFrequency = box.get('medicineFrequency', defaultValue: 'Daily');
    String medicineDosage = box.get('medicineDosage', defaultValue: '');

    List<String> injectionTimes = List<String>.from(box.get('injectionTimes', defaultValue: []));
    String injectionFrequency = box.get('injectionFrequency', defaultValue: 'Weekly');
    String injectionDosage = box.get('injectionDosage', defaultValue: '');

    // Map and add events for each medicine time
    for (String time in medicineTimes) {
      String mappedTime = timeMapping[time] ?? '08:00';
      DateTime startTime = _parseTime(mappedTime);

      appointments.add(Appointment(
        startTime: startTime,
        endTime: startTime.add(Duration(minutes: 30)),
        subject: 'Medicine: $medicineDosage',
        color: Colors.blue,
        recurrenceRule: _getRecurrenceRule(medicineFrequency),
      ));
    }

    // Map and add events for each injection time
    for (String time in injectionTimes) {
      String mappedTime = timeMapping[time] ?? '08:00';
      DateTime startTime = _parseTime(mappedTime);

      appointments.add(Appointment(
        startTime: startTime,
        endTime: startTime.add(Duration(minutes: 30)),
        subject: 'Injection: $injectionDosage',
        color: Colors.red,
        recurrenceRule: _getRecurrenceRule(injectionFrequency),
      ));
    }

    setState(() {
      _goalAppointments = appointments;
    });
  }

  // Helper method to parse the time from string to DateTime
  DateTime _parseTime(String time) {
    final now = DateTime.now();
    final splitTime = time.split(':');
    return DateTime(now.year, now.month, now.day, int.parse(splitTime[0]), int.parse(splitTime[1]));
  }

  // Helper method to get the recurrence rule based on frequency
  String _getRecurrenceRule(String frequency) {
    switch (frequency) {
      case 'Daily':
        return 'FREQ=DAILY';
      case 'Every Other Day':
        return 'FREQ=DAILY;INTERVAL=2';
      case 'Weekly':
        return 'FREQ=WEEKLY;BYDAY=MO,WE,FR';
      default:
        return ''; // No recurrence for other values
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Goals Calendar',
          style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w), // Responsive padding
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: GoalDataSource(_goalAppointments),
          monthViewSettings: MonthViewSettings(showAgenda: true),
        ),
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
