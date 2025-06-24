import 'package:hive/hive.dart';

part 'clinical_visit_model.g.dart';

@HiveType(typeId: 50)
class ClinicalVisit extends HiveObject {
  @HiveField(0)
  late DateTime date;

  @HiveField(1)
  late String notes;

  @HiveField(2)
  late String appointmentType;

  @HiveField(3)
  late String history;
}
