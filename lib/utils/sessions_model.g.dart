// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessions_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionsModelAdapter extends TypeAdapter<SessionsModel> {
  @override
  final int typeId = 0;

  @override
  SessionsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionsModel(
      sessionId: fields[0] as String,
      userId: fields[1] as String,
      createdAt: fields[2] as DateTime,
      lastActiveAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SessionsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.lastActiveAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionsModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
