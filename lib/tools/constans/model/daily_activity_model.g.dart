// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_activity_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyActivityModelAdapter extends TypeAdapter<DailyActivityModel> {
  @override
  final int typeId = 5;

  @override
  DailyActivityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyActivityModel(
      userId: fields[0] as String,
      date: fields[1] as String,
      waterIntake: fields[2] as double,
      sleepHours: fields[3] as double,
      walkingSteps: fields[4] as int,
      foodIntake: fields[5] as String,
      medicineIntake: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DailyActivityModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.waterIntake)
      ..writeByte(3)
      ..write(obj.sleepHours)
      ..writeByte(4)
      ..write(obj.walkingSteps)
      ..writeByte(5)
      ..write(obj.foodIntake)
      ..writeByte(6)
      ..write(obj.medicineIntake);
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
