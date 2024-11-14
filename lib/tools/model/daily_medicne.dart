import 'package:alaram/tools/model/goal_model.dart';

class DailyActivityModel {
  final String date;
  final double sleepHours;
  final double walkingHours;
  final double waterIntake;
  final List<Medicine>? medicines;
 // final MealValue? mealValue;

  // Constructor
  DailyActivityModel({
    required this.date,
    required this.sleepHours,
    required this.walkingHours,
    required this.waterIntake,
    this.medicines,
  //  this.mealValue,
  });

  // Override toString() to give a meaningful output
  @override
  String toString() {
    return 'Date: $date, Sleep: $sleepHours hrs, Walking: $walkingHours hrs, Water Intake: $waterIntake L';
  }
}
