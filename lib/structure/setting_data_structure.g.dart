// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_data_structure.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingDataAdapter extends TypeAdapter<SettingData> {
  @override
  final int typeId = 1;

  @override
  SettingData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingData(
      fields[6] as int,
      fields[9] as int,
      fields[4] as int,
      fields[5] as int,
      fields[8] as int,
      fields[11] as int,
      fields[3] as int,
      fields[15] as int,
      fields[14] as int,
      fields[13] as int,
      fields[12] as int,
      fields[10] as int,
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[7] as int,
      fields[16] as int,
      fields[17] as String,
      fields[18] as bool,
      fields[19] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SettingData obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.appBarTitleColorProvider)
      ..writeByte(1)
      ..write(obj.appBarImagePath)
      ..writeByte(2)
      ..write(obj.appBarImageDefaultPath)
      ..writeByte(3)
      ..write(obj.fontIndexProvider)
      ..writeByte(4)
      ..write(obj.theme1Provider)
      ..writeByte(5)
      ..write(obj.theme2Provider)
      ..writeByte(6)
      ..write(obj.theme3Provider)
      ..writeByte(7)
      ..write(obj.theme4Provider)
      ..writeByte(8)
      ..write(obj.theme5Provider)
      ..writeByte(9)
      ..write(obj.theme6Provider)
      ..writeByte(10)
      ..write(obj.fontSizeListProvider)
      ..writeByte(11)
      ..write(obj.fontSizeDiaryProvider)
      ..writeByte(12)
      ..write(obj.listMaxLinesProvider)
      ..writeByte(13)
      ..write(obj.listHeightProvider)
      ..writeByte(14)
      ..write(obj.weekFormatProvider)
      ..writeByte(15)
      ..write(obj.dateFormatProvider)
      ..writeByte(16)
      ..write(obj.dateUpdateTimeProvider)
      ..writeByte(17)
      ..write(obj.gptIntroduce)
      ..writeByte(18)
      ..write(obj.notificationEnabled)
      ..writeByte(19)
      ..write(obj.notificationTimeProvider);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
