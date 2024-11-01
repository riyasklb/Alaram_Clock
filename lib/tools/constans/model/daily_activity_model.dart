import 'package:hive/hive.dart';

part 'daily_activity_model.g.dart';

@HiveType(typeId: 5)
class DailyActivityModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final double waterIntake;

  @HiveField(3)
  final double sleepHours;

  @HiveField(4)
  final int walkingSteps;

  @HiveField(5)
  final String foodIntake;

  @HiveField(6)
  final String medicineIntake;

  DailyActivityModel({
    required this.userId,
    required this.date,
    required this.waterIntake,
    required this.sleepHours,
    required this.walkingSteps,
    required this.foodIntake,
    required this.medicineIntake,
  });

  // Converts the object into a map for saving
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date,
      'waterIntake': waterIntake,
      'sleepHours': sleepHours,
      'walkingSteps': walkingSteps,
      'foodIntake': foodIntake,
      'medicineIntake': medicineIntake,
    };
  }

  // Creates an object from a map
  factory DailyActivityModel.fromMap(Map<String, dynamic> map) {
    return DailyActivityModel(
      userId: map['userId'],
      date: map['date'],
      waterIntake: map['waterIntake'],
      sleepHours: map['sleepHours'],
      walkingSteps: map['walkingSteps'],
      foodIntake: map['foodIntake'],
      medicineIntake: map['medicineIntake'],
    );
  }
}
