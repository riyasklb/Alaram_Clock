// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileModelAdapter extends TypeAdapter<ProfileModel> {
  @override
  final int typeId = 1;

  @override
  ProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileModel()
      ..username = fields[0] as String
      ..email = fields[1] as String
      ..age = fields[2] as int
      ..mobile = fields[3] as String
      ..nhsNumber = fields[4] as String
      ..gender = fields[5] as String
      ..ethnicity = fields[6] as String
      ..waterIntakeGoal = fields[7] as double?
      ..sleepGoal = fields[8] as double?
      ..walkingGoal = fields[9] as double?
      ..medicineGoal = fields[10] as String?
      ..foodGoal = fields[11] as String?
      ..injectionGoal = fields[12] as String?;
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.mobile)
      ..writeByte(4)
      ..write(obj.nhsNumber)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.ethnicity)
      ..writeByte(7)
      ..write(obj.waterIntakeGoal)
      ..writeByte(8)
      ..write(obj.sleepGoal)
      ..writeByte(9)
      ..write(obj.walkingGoal)
      ..writeByte(10)
      ..write(obj.medicineGoal)
      ..writeByte(11)
      ..write(obj.foodGoal)
      ..writeByte(12)
      ..write(obj.injectionGoal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
