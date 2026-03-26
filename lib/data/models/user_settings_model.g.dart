// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsModelAdapter extends TypeAdapter<UserSettingsModel> {
  @override
  final int typeId = 0;

  @override
  UserSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettingsModel(
      dailyTargetMl: fields[0] as int,
      remindersEnabled: fields[1] as bool,
      wakeTimeMinutes: fields[2] as int,
      sleepTimeMinutes: fields[3] as int,
      intervalMinutes: fields[4] as int,
      alarmEnabled: fields[5] as bool,
      isOnboarded: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettingsModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.dailyTargetMl)
      ..writeByte(1)
      ..write(obj.remindersEnabled)
      ..writeByte(2)
      ..write(obj.wakeTimeMinutes)
      ..writeByte(3)
      ..write(obj.sleepTimeMinutes)
      ..writeByte(4)
      ..write(obj.intervalMinutes)
      ..writeByte(5)
      ..write(obj.alarmEnabled)
      ..writeByte(6)
      ..write(obj.isOnboarded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
