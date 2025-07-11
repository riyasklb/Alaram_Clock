import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alaram/tools/controllers/activity_controller.dart';
import 'package:alaram/views/chart/widgets/line_chart_widget.dart';

class ActivityMetricDetailScreen extends StatelessWidget {
  final String metric; // 'sleep', 'walking', 'water'
  final String label;
  final Color color;

  const ActivityMetricDetailScreen({
    Key? key,
    required this.metric,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ActivityController controller = Get.find();
    final logs = List.of(controller.filteredActivityLogs);
    logs.sort((a, b) => a.date.compareTo(b.date));
    final dates = logs.map((log) => log.date).toList();
    List<double> data;
    switch (metric) {
      case 'sleep':
        data = logs.map((log) => log.sleepHours).toList();
        break;
      case 'walking':
        data = logs.map((log) => log.walkingHours).toList();
        break;
      case 'water':
        data = logs.map((log) => log.waterIntake).toList();
        break;
      default:
        data = [];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('$label Details'),
        backgroundColor: color,
      ),
      body: SingleMetricLineChart(
        data: data,
        dates: dates,
        color: color,
        label: label,
      ),
    );
  }
} 