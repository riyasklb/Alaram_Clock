import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Appointment> _appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  // Load sample data for Reminders, Activities, and Goals
  void _loadAppointments() {
    _appointments = <Appointment>[
      Appointment(
        startTime: DateTime.now().add(Duration(hours: 1)),
        endTime: DateTime.now().add(Duration(hours: 2)),
        subject: 'Morning Run (Goal)',
        color: Colors.green,
        notes: 'Complete 5K morning run',
      ),
      Appointment(
        startTime: DateTime.now().add(Duration(days: 1)),
        endTime: DateTime.now().add(Duration(days: 1, hours: 1)),
        subject: 'Team Meeting (Activity)',
        color: Colors.blue,
        notes: 'Discuss project updates',
      ),
      Appointment(
        startTime: DateTime.now().add(Duration(days: 2)),
        endTime: DateTime.now().add(Duration(days: 2, hours: 1)),
        subject: 'Doctor Appointment (Reminder)',
        color: Colors.red,
        notes: 'Monthly health checkup',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar - Reminders & Goals'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfCalendar(
            view: CalendarView.month,
            dataSource: AppointmentDataSource(_appointments),
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              showAgenda: true,
            ),
            appointmentBuilder: (context, details) {
              final Appointment appointment = details.appointments.first;
              return Container(
                padding: const EdgeInsets.all(8),
                color: appointment.color,
                child: Text(
                  appointment.subject,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Custom DataSource for Calendar Appointments
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}
