// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_structure.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataAdapter extends TypeAdapter<Data> {
  @override
  final int typeId = 0;

  @override
  Data read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Data(
      (fields[0] as List).cast<int>(),
      (fields[1] as List).cast<int>(),
      (fields[2] as List).cast<int>(),
      (fields[3] as List).cast<int>(),
      (fields[4] as List).cast<String>(),
      (fields[5] as List).cast<String>(),
      (fields[6] as List)
          .map((dynamic e) => (e as List).cast<String>())
          .toList(),
      (fields[7] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, Data obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.text)
      ..writeByte(6)
      ..write(obj.image)
      ..writeByte(7)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
