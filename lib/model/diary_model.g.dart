// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiaryModelAdapter extends TypeAdapter<DiaryModel> {
  @override
  final int typeId = 0;

  @override
  DiaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiaryModel(
      dateTime: fields[0] as DateTime,
      description: fields[1] as dynamic,
      rating: fields[2] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, DiaryModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
