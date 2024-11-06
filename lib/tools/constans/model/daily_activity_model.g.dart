// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_activity_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyActivityModelAdapter extends TypeAdapter<DailyActivityModel> {
  @override
  final int typeId = 21;

  @override
  DailyActivityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyActivityModel(
      activityName: fields[0] as String,
      isActivityCompleted: fields[1] as bool,
      medicines: (fields[2] as List?)?.cast<DailyMedicine>(),
      mealValue: fields[3] as DailyactivityMealValue?,
      goalId: fields[4] as int,
      frequency: fields[5] as String,
      date: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DailyActivityModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.activityName)
      ..writeByte(1)
      ..write(obj.isActivityCompleted)
      ..writeByte(2)
      ..write(obj.medicines)
      ..writeByte(3)
      ..write(obj.mealValue)
      ..writeByte(4)
      ..write(obj.goalId)
      ..writeByte(5)
      ..write(obj.frequency)
      ..writeByte(6)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyActivityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyMedicineAdapter extends TypeAdapter<DailyMedicine> {
  @override
  final int typeId = 22;

  @override
  DailyMedicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyMedicine(
      name: fields[0] as String,
      selectedTimes: (fields[1] as List).cast<String>(),
      frequency: fields[2] as String,
      taskCompletionStatus: (fields[3] as Map).cast<String, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, DailyMedicine obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.selectedTimes)
      ..writeByte(2)
      ..write(obj.frequency)
      ..writeByte(3)
      ..write(obj.taskCompletionStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyMedicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyactivityMealValueAdapter
    extends TypeAdapter<DailyactivityMealValue> {
  @override
  final int typeId = 23;

  @override
  DailyactivityMealValue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyactivityMealValue(
      morning: fields[0] as bool,
      afternoon: fields[1] as bool,
      night: fields[2] as bool,
      mealCompletionStatus: (fields[3] as Map).cast<String, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, DailyactivityMealValue obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.morning)
      ..writeByte(1)
      ..write(obj.afternoon)
      ..writeByte(2)
      ..write(obj.night)
      ..writeByte(3)
      ..write(obj.mealCompletionStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyactivityMealValueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OverallCompletionAdapter extends TypeAdapter<OverallCompletion> {
  @override
  final int typeId = 24;

  @override
  OverallCompletion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OverallCompletion(
      completedGoals: fields[0] as int,
      totalGoals: fields[1] as int,
      completionPercentage: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, OverallCompletion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.completedGoals)
      ..writeByte(1)
      ..write(obj.totalGoals)
      ..writeByte(2)
      ..write(obj.completionPercentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OverallCompletionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
