// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      noteTitle: fields[0] as String,
      noteDetail: fields[1] as String,
      noteCreatedDate: fields[2] as dynamic,
      noteUpdatedDate: fields[3] as dynamic,
      noteId: fields[4] as dynamic,
      noteColor: fields[5] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.noteTitle)
      ..writeByte(1)
      ..write(obj.noteDetail)
      ..writeByte(2)
      ..write(obj.noteCreatedDate)
      ..writeByte(3)
      ..write(obj.noteUpdatedDate)
      ..writeByte(4)
      ..write(obj.noteId)
      ..writeByte(5)
      ..write(obj.noteColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
