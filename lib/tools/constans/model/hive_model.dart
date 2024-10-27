import 'package:hive/hive.dart';

part 'hive_model.g.dart'; // Make sure to run the build command after creating this file



@HiveType(typeId: 0)
class ActivityModel {
  @HiveField(0)
  final int minutesWalked;
  
  @HiveField(1)
  final int hoursSlept;
  
  @HiveField(2)
  final double waterIntake;
  
  @HiveField(3)
  final DateTime date; // Add a date field

  ActivityModel(this.minutesWalked, this.hoursSlept, this.waterIntake, this.date);
}
