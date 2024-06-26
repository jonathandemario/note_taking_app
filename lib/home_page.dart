import 'package:flutter/material.dart';
import 'package:note_taking_app/note.dart';
import 'package:note_taking_app/main.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _notes = Hive.box<Note>('notes');

  Future fetchNotes() async {
    final keyList = _notes.keys.toList();

    print('This all notes:');
    if (keyList.isNotEmpty) {
      for (var key in keyList) {
        print ('Key: ${key}');
        print(_notes.get(key)!.noteTitle);
        _notes.delete(key);
      }
    } else {
      print('Notes Empty');
    }
  }

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
  void createNote(data) {
    _notes.put(checkIndex(), data);
  }

  void editNote(index, title, detail, updatedTime) {
    Note updated_note = _notes.get(index)!;

    updated_note.noteTitle = title;
    updated_note.noteDetail = detail;
    updated_note.noteUpdatedDate = updatedTime;

    _notes.put(index, updated_note);
  }

  void deleteNote(index) {
    _notes.delete(index);
  }

  @override
  void initState() {
    fetchNotes();
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
