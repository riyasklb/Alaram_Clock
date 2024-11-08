// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalAdapter extends TypeAdapter<Goal> {
  @override
  final int typeId = 11;

  @override
  Goal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Goal(
      goalId: fields[0] as int,
      goalType: fields[1] as String,
      date: fields[2] as DateTime,
      MealValue: fields[3] as Meal?,
      medicines: (fields[4] as List?)?.cast<Medicine>(),
      skipped: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Goal obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.goalId)
      ..writeByte(1)
      ..write(obj.goalType)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.MealValue)
      ..writeByte(4)
      ..write(obj.medicines)
      ..writeByte(5)
      ..write(obj.skipped);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 12;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meal(
      morning: fields[0] as bool?,
      afternoon: fields[1] as bool?,
      evening: fields[2] as bool?,
      night: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.morning)
      ..writeByte(1)
      ..write(obj.afternoon)
      ..writeByte(2)
      ..write(obj.evening)
      ..writeByte(3)
      ..write(obj.night);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicineAdapter extends TypeAdapter<Medicine> {
  @override
  final int typeId = 13;

  @override
  Medicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medicine(
      name: fields[0] as String,
      frequencyType: fields[1] as String,
      dosage: fields[2] as String,
      quantity: fields[3] as int,
      selectedTimes: (fields[5] as List).cast<String>(),
    )..nextIntakeDate = fields[4] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Medicine obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.frequencyType)
      ..writeByte(2)
      ..write(obj.dosage)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.nextIntakeDate)
      ..writeByte(5)
      ..write(obj.selectedTimes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
