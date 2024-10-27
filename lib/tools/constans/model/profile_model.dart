import 'package:hive/hive.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 1)
class ProfileModel extends HiveObject {
  @HiveField(0)
  late String username;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late int age;

  @HiveField(3)
  late String mobile;

  @HiveField(4)
  late String nhsNumber;

  @HiveField(5)
  late String gender;

  @HiveField(6) // New field for ethnicity
  late String ethnicity;

  @HiveField(7)
  double? waterIntakeGoal; // Liters

  @HiveField(8)
  double? sleepGoal; // Hours

  @HiveField(9)
  double? walkingGoal;
    @HiveField(10)
  String? medicineGoal; // Morning, Afternoon, Night

  @HiveField(11)
  String? foodGoal; // Breakfast, Lunch, Dinner

  @HiveField(12)
  String? injectionGoal;
}
