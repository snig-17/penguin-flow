// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      avatarPath: fields[3] as String,
      level: fields[4] as int,
      totalXP: fields[5] as int,
      currentStreak: fields[6] as int,
      longestStreak: fields[7] as int,
      completedSessions: fields[8] as int,
      totalFocusTime: fields[9] as int,
      joinDate: fields[10] as DateTime?,
      lastActivityDate: fields[11] as DateTime?,
      friendsCount: fields[12] as int,
      islandTheme: fields[13] as IslandTheme,
      notificationsEnabled: fields[14] as bool,
      soundEnabled: fields[15] as bool,
      darkModeEnabled: fields[16] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.avatarPath)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.totalXP)
      ..writeByte(6)
      ..write(obj.currentStreak)
      ..writeByte(7)
      ..write(obj.longestStreak)
      ..writeByte(8)
      ..write(obj.completedSessions)
      ..writeByte(9)
      ..write(obj.totalFocusTime)
      ..writeByte(10)
      ..write(obj.joinDate)
      ..writeByte(11)
      ..write(obj.lastActivityDate)
      ..writeByte(12)
      ..write(obj.friendsCount)
      ..writeByte(13)
      ..write(obj.islandTheme)
      ..writeByte(14)
      ..write(obj.notificationsEnabled)
      ..writeByte(15)
      ..write(obj.soundEnabled)
      ..writeByte(16)
      ..write(obj.darkModeEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IslandThemeAdapter extends TypeAdapter<IslandTheme> {
  @override
  final int typeId = 10;

  @override
  IslandTheme read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IslandTheme.arctic;
      case 1:
        return IslandTheme.tropical;
      case 2:
        return IslandTheme.forest;
      case 3:
        return IslandTheme.desert;
      case 4:
        return IslandTheme.volcanic;
      case 5:
        return IslandTheme.crystal;
      default:
        return IslandTheme.arctic;
    }
  }

  @override
  void write(BinaryWriter writer, IslandTheme obj) {
    switch (obj) {
      case IslandTheme.arctic:
        writer.writeByte(0);
        break;
      case IslandTheme.tropical:
        writer.writeByte(1);
        break;
      case IslandTheme.forest:
        writer.writeByte(2);
        break;
      case IslandTheme.desert:
        writer.writeByte(3);
        break;
      case IslandTheme.volcanic:
        writer.writeByte(4);
        break;
      case IslandTheme.crystal:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IslandThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
