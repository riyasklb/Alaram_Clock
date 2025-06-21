import 'package:hive/hive.dart';

part 'activity_log.g.dart';

@HiveType(typeId: 0) // Keep the type ID the same as previously registered
class ActivityLog extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double sleepHours;

  @HiveField(2)
  final double walkingHours;

  @HiveField(3)
  final double waterIntake;
  @HiveField(4)
  final String? additionalInformation;
  ActivityLog({
    required this.date,
    required this.sleepHours,
    required this.walkingHours,
    required this.waterIntake,
    this.additionalInformation,
  });
}
