// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'island_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BuildingAdapter extends TypeAdapter<Building> {
  @override
  final int typeId = 4;

  @override
  Building read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Building(
      id: fields[0] as String?,
      type: fields[1] as BuildingType,
      positionX: fields[2] as double,
      positionY: fields[3] as double,
      level: fields[4] as int,
      isUnlocked: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Building obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.positionX)
      ..writeByte(3)
      ..write(obj.positionY)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.isUnlocked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuildingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DecorationAdapter extends TypeAdapter<Decoration> {
  @override
  final int typeId = 5;

  @override
  Decoration read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Decoration(
      id: fields[0] as String?,
      type: fields[1] as String,
      positionX: fields[2] as double,
      positionY: fields[3] as double,
      isUnlocked: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Decoration obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.positionX)
      ..writeByte(3)
      ..write(obj.positionY)
      ..writeByte(4)
      ..write(obj.isUnlocked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DecorationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IslandModelAdapter extends TypeAdapter<IslandModel> {
  @override
  final int typeId = 3;

  @override
  IslandModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IslandModel(
      id: fields[0] as String,
      ownerName: fields[1] as String,
      buildings: (fields[3] as List?)?.cast<Building>(),
      decorations: (fields[4] as List?)?.cast<Decoration>(),
      totalFocusTime: fields[5] as int,
      lastUpdated: fields[6] as DateTime?,
      themeIndex: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, IslandModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ownerName)
      ..writeByte(2)
      ..write(obj.themeIndex)
      ..writeByte(3)
      ..write(obj.buildings)
      ..writeByte(4)
      ..write(obj.decorations)
      ..writeByte(5)
      ..write(obj.totalFocusTime)
      ..writeByte(6)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IslandModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BuildingTypeAdapter extends TypeAdapter<BuildingType> {
  @override
  final int typeId = 13;

  @override
  BuildingType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BuildingType.tent;
      case 1:
        return BuildingType.cabin;
      case 2:
        return BuildingType.workshop;
      case 3:
        return BuildingType.lighthouse;
      case 4:
        return BuildingType.observatory;
      case 5:
        return BuildingType.castle;
      default:
        return BuildingType.tent;
    }
  }

  @override
  void write(BinaryWriter writer, BuildingType obj) {
    switch (obj) {
      case BuildingType.tent:
        writer.writeByte(0);
        break;
      case BuildingType.cabin:
        writer.writeByte(1);
        break;
      case BuildingType.workshop:
        writer.writeByte(2);
        break;
      case BuildingType.lighthouse:
        writer.writeByte(3);
        break;
      case BuildingType.observatory:
        writer.writeByte(4);
        break;
      case BuildingType.castle:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuildingTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
