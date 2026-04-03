// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionModelAdapter extends TypeAdapter<SessionModel> {
  @override
  final int typeId = 1;

  @override
  SessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionModel(
      id: fields[0] as String,
      type: fields[1] as SessionType,
      startTime: fields[2] as DateTime,
      plannedDuration: fields[3] as Duration,
      endTime: fields[4] as DateTime?,
      actualDuration: fields[5] as Duration?,
      wasCompleted: fields[6] as bool,
      xpEarned: fields[7] as int,
      taskDescription: fields[8] as String?,
      pauseCount: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SessionModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.plannedDuration)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.actualDuration)
      ..writeByte(6)
      ..write(obj.wasCompleted)
      ..writeByte(7)
      ..write(obj.xpEarned)
      ..writeByte(8)
      ..write(obj.taskDescription)
      ..writeByte(9)
      ..write(obj.pauseCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionTypeAdapter extends TypeAdapter<SessionType> {
  @override
  final int typeId = 11;

  @override
  SessionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SessionType.focus;
      case 1:
        return SessionType.shortBreak;
      case 2:
        return SessionType.longBreak;
      case 3:
        return SessionType.deepWork;
      default:
        return SessionType.focus;
    }
  }

  @override
  void write(BinaryWriter writer, SessionType obj) {
    switch (obj) {
      case SessionType.focus:
        writer.writeByte(0);
        break;
      case SessionType.shortBreak:
        writer.writeByte(1);
        break;
      case SessionType.longBreak:
        writer.writeByte(2);
        break;
      case SessionType.deepWork:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
