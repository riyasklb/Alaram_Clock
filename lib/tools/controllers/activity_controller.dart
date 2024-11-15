import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:alaram/tools/model/daily_activity_model.dart';
import 'package:alaram/tools/model/activity_log.dart';

class ActivityController extends GetxController {
  // Observables
  var activityLogs = <ActivityLog>[].obs;
  var filteredActivityLogs = <ActivityLog>[].obs;
  var dailyActivities = <DailyActivityModel>[].obs;

  // Current filter days
  var currentFilterDays = 0.obs;

  // Totals for sleep, walking, and water intake
  double get totalSleep =>
      filteredActivityLogs.fold(0, (sum, log) => sum + log.sleepHours);
  double get totalWalking =>
      filteredActivityLogs.fold(0, (sum, log) => sum + log.walkingHours);
  double get totalWaterIntake =>
      filteredActivityLogs.fold(0, (sum, log) => sum + log.waterIntake);

  @override
  void onInit() {
    super.onInit();
    loadActivityLogs();
    _listenToHiveChanges();
  }

  /// Adds a new activity and updates the observable
  Future<void> addActivity(ActivityLog newActivity) async {
    var activityBox = await Hive.openBox<ActivityLog>('activityLogs');
    await activityBox.add(newActivity);

    // Update the reactive list
    activityLogs.add(newActivity);

    // Reapply the filter to update filteredActivityLogs
    setFilter(currentFilterDays.value);
  }

  /// Loads all activity logs from Hive
  Future<void> loadActivityLogs() async {
    var activityBox = await Hive.openBox<ActivityLog>('activityLogs');
    var dailyActivityBox = await Hive.openBox<DailyActivityModel>('dailyActivities');

    activityLogs.assignAll(activityBox.values.toList());
    dailyActivities.assignAll(dailyActivityBox.values.toList());

    setFilter(currentFilterDays.value); // Apply the default filter
  }

  /// Sets the filter for the logs based on the number of days
  void setFilter(int days) {
    currentFilterDays.value = days;
    if (days == 0) {
      filteredActivityLogs.assignAll(activityLogs);
    } else {
      filterByDateRange(days);
    }
  }

  /// Filters logs by date range
  void filterByDateRange(int days) {
    DateTime startDate = DateTime.now().subtract(Duration(days: days));
    filteredActivityLogs.assignAll(
      activityLogs.where((log) => log.date.isAfter(startDate)).toList(),
    );
  }

  /// Listens for changes in the Hive box and updates observables
  void _listenToHiveChanges() async {
    var activityBox = await Hive.openBox<ActivityLog>('activityLogs');

    activityBox.watch().listen((event) {
      activityLogs.assignAll(activityBox.values.toList());
      setFilter(currentFilterDays.value); // Reapply the filter
    });
  }
}
