import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 11)
class Goal extends HiveObject {
  @HiveField(0)
  late int goalId;

  @HiveField(1)
  late String goalType;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  Meal? targetValue;

  @HiveField(4)
  List<Medicine>? medicines;

  Goal({
    required this.goalId,
    required this.goalType,
    required this.date,
    this.targetValue,
    this.medicines,
  });
}

@HiveType(typeId: 12)
class Meal extends HiveObject {
  @HiveField(0)
  bool? morning;

  @HiveField(1)
  bool? afternoon;

  @HiveField(2)
  bool? evening;

  @HiveField(3)
  bool? night;



  Meal({
    this.morning,
    this.afternoon,
    this.evening,
    this.night,
  
  });
}

@HiveType(typeId: 13)
class Medicine extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String frequencyType;

  @HiveField(2)
  late String dosage;

  @HiveField(3)
  late int quantity;

  @HiveField(4)
  DateTime? nextIntakeDate;

  Medicine({
    required this.name,
    required this.frequencyType,
    required this.dosage,
    required this.quantity,
  }) {
    // Set the nextIntakeDate based on the frequencyType
    nextIntakeDate = calculateNextIntakeDate(frequencyType);
  }

  DateTime calculateNextIntakeDate(String frequencyType) {
    DateTime now = DateTime.now();
    switch (frequencyType.toLowerCase()) {
      case 'daily':
        return now.add(Duration(days: 1));
      case 'weekly':
        return now.add(Duration(days: 7));
      default:
        // If frequencyType is a number or not recognized, assume daily intake
        int days = int.tryParse(frequencyType.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
        return now.add(Duration(days: days));
    }
  }
}
