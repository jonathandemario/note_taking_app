import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/main.dart';
import 'package:note_taking_app/pages/home_page.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetailPage extends StatefulWidget {
  final int curr_index;
  final bool isCreateNew;

  DetailPage({
    super.key,
    required this.curr_index,
    required this.isCreateNew
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var _notes = Hive.box<Note>('notes');
  List<Note> noteList = [];

  // Future fetchNotes() async {
  //   final keyList = _notes.keys.toList();
  //   if (keyList.isNotEmpty) {
  //     for (var key in keyList) {
  //       print ('Key: ${key}');
  //       print(_notes.get(key)!.noteTitle);
  //       // _notes.delete(key);
  //       setState(() {
  //         noteList.add(_notes.get(key)!);
  //       });
  //     }
  //   } else {
  //     print('Notes Empty');
  //   }
  // }

  int checkIndex() {
    if (_notes.isEmpty) {
      return 0;
    }
    int maxKey = _notes.keys.reduce((a, b) => a > b ? a : b);
    return maxKey + 1;
  }

  String getTime() {
    DateTime curr_timestamp = DateTime.now();
    String curr_time = DateFormat('dd/MM/yyyy HH:mm:ss').format(curr_timestamp);
    return curr_time;
  }

  // Note this_data = Note(noteName: 'c', noteDetail: 'abcdefghij', noteCreatedDate: getTime(), noteUpdatedDate: getTime());
  // _notes.put(checkIndex(), this_data);

  
  Future createNote(data) async {
    _notes.put(checkIndex(), data);
  }

  Future editNote(index, title, detail, updatedTime) async {
    Note updated_note = _notes.get(index)!;

    updated_note.noteTitle = title;
    updated_note.noteDetail = detail;
    updated_note.noteUpdatedDate = updatedTime;

    _notes.put(index, updated_note);
  }

  Future deleteNote(index) async {
    _notes.delete(index);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Note'),
      ),
    );
  }
}
