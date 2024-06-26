import 'package:flutter/material.dart';
import 'package:note_taking_app/note.dart';
import 'package:note_taking_app/main.dart';
import 'package:note_taking_app/detail_page.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _notes = Hive.box<Note>('notes');
  List<Note> noteList = [];

  Future fetchNotes() async {
    final keyList = _notes.keys.toList();
    if (keyList.isNotEmpty) {
      for (var key in keyList) {
        print ('Key: ${key}\n${_notes.get(key)!.noteTitle}');
        setState(() {
          noteList.add(_notes.get(key)!);
        });
      }
    } else {
      print('Notes Empty');
    }
  }

  @override
  void initState() {
    super.initState();
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
