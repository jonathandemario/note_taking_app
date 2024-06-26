import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String noteTitle;

  @HiveField(1)
  String noteDetail;

  @HiveField(2)
  final noteCreatedDate;

  @HiveField(3)
  var noteUpdatedDate;

  @HiveField(4)
  final noteId;

  Note({
    required this.noteTitle,
    required this.noteDetail,
    required this.noteCreatedDate,
    required this.noteUpdatedDate,
    required this.noteId
  });
}
