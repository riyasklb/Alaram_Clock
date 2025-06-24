// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinical_visit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClinicalVisitAdapter extends TypeAdapter<ClinicalVisit> {
  @override
  final int typeId = 50;

  @override
  ClinicalVisit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClinicalVisit()
      ..date = fields[0] as DateTime
      ..notes = fields[1] as String
      ..appointmentType = fields[2] as String
      ..history = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, ClinicalVisit obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.notes)
      ..writeByte(2)
      ..write(obj.appointmentType)
      ..writeByte(3)
      ..write(obj.history);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClinicalVisitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
