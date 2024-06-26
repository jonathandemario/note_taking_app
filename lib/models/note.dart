import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String noteTitle;

  @HiveField(1)
  String noteDetail;

  @HiveField(2)
  final String noteCreatedDate;

  @HiveField(3)
  String noteUpdatedDate;

  Note({
    required this.noteTitle,
    required this.noteDetail,
    required this.noteCreatedDate,
    required this.noteUpdatedDate,
  });
}
