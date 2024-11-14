import 'dart:io';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:alaram/tools/model/daily_activity_model.dart';
import 'package:alaram/tools/model/activity_log.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
class ActivityController extends GetxController {
  var activityLogs = <ActivityLog>[].obs;
  var filteredActivityLogs = <ActivityLog>[].obs;
  var dailyActivities = <DailyActivityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadActivityLogs();
  }

  Future<void> loadActivityLogs() async {
    var activityBox = await Hive.openBox<ActivityLog>('activityLogs');
    var dailyActivityBox = await Hive.openBox<DailyActivityModel>('dailyActivities');

    activityLogs.assignAll(activityBox.values.toList());
    dailyActivities.assignAll(dailyActivityBox.values.toList());
    filteredActivityLogs.assignAll(activityLogs);
  }

  void filterByDateRange(int days) {
    DateTime startDate = DateTime.now().subtract(Duration(days: days));
    filteredActivityLogs.assignAll(
      activityLogs.where((log) => log.date.isAfter(startDate)).toList(),
    );
  }






}
