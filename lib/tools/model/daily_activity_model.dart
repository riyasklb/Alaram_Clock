import 'package:hive/hive.dart';

part 'daily_activity_model.g.dart'; // This will be generated

@HiveType(typeId: 21)
class DailyActivityModel extends HiveObject {
  @HiveField(0)
  String activityName;

  @HiveField(1)
  bool isActivityCompleted;

  @HiveField(2)
  List<DailyMedicine>? medicines;

  @HiveField(3)
  DailyactivityMealValue? mealValue;

  @HiveField(4)
  int goalId; // Unique identifier for the goal

  @HiveField(5)
  String frequency; // Frequency of the goal (e.g., daily, weekly)

  @HiveField(6)
  DateTime date; // Date for the activity log

  DailyActivityModel({
    required this.activityName,
    this.isActivityCompleted = false,
    this.medicines,
    this.mealValue,
    required this.goalId,
    required this.frequency,
    required this.date,
  });
}

@HiveType(typeId: 22)
class DailyMedicine extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> selectedTimes;

  @HiveField(2)
  String frequency;

  @HiveField(3)
  Map<String, bool> taskCompletionStatus;

  DailyMedicine({
    required this.name,
    required this.selectedTimes,
    required this.frequency,
    required this.taskCompletionStatus,
  });
}

@HiveType(typeId: 23)
class DailyactivityMealValue extends HiveObject {
  @HiveField(0)
  bool morning;

  @HiveField(1)
  bool afternoon;

  @HiveField(2)
  bool night;

  @HiveField(3)
  Map<String, bool> mealCompletionStatus;

  DailyactivityMealValue({
    this.morning = false,
    this.afternoon = false,
    this.night = false,
    required this.mealCompletionStatus,
  });
}

@HiveType(typeId: 24)
class OverallCompletion extends HiveObject {
  @HiveField(0)
  int completedGoals;

  @HiveField(1)
  int totalGoals;

  @HiveField(2)
  double completionPercentage;

  OverallCompletion({
    required this.completedGoals,
    required this.totalGoals,
    required this.completionPercentage,
  });
}
