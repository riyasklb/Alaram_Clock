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
  String? gender;  // Make nullable

  @HiveField(6)
  String? ethnicity;  // Make nullable

  // New field for profile image path
  @HiveField(16)
  String? imagePath;  // Add this field

  @HiveField(7)
  double? waterIntakeGoal;

  @HiveField(8)
  double? sleepGoal;

  @HiveField(9)
  double? walkingGoal;
 @HiveField(10)
  DateTime? registerdate;

}