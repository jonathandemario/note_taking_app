import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/main.dart';
import 'package:note_taking_app/pages/detail_page.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _notes = Hive.box<Note>('notes');
  final _search = TextEditingController();

  List<Note> noteList = [];

  Future fetchNotes(keyword) async {
    List keys = _notes.keys.toList();
    noteList = [];

    if (keys.isNotEmpty) {
      for (var key in keys) {
        if (_notes
            .get(key)!
            .noteTitle
            .toLowerCase()
            .contains(keyword.toLowerCase())) {
          setState(() {
            noteList.add(_notes.get(key)!);
          });
        }
      }
      if (noteList.length == 0) {
        setState(() {
          noteList = [];
        });
      }
    } else {
      print('Notes Empty');
      setState(() {
        noteList = [];
      });
    }
    setState(() {
      noteList.sort((a, b) => b.noteUpdatedDate.compareTo(a.noteUpdatedDate));
    });
  }

  Future deleteNote(index) async {
    _notes.delete(index);
    fetchNotes('');
  }

  int checkIndex() {
    if (_notes.isEmpty) {
      return 0;
    }
    int maxKey = _notes.keys.reduce((a, b) => a > b ? a : b);
    return maxKey + 1;
  }

  DateTime getTime() {
    DateTime curr_timestamp = DateTime.now();
    return curr_timestamp;
  }

  String getFormatTime(curr_timestamp) {
    String curr_time = DateFormat('dd/MM/yyyy HH:mm:ss').format(curr_timestamp);
    return curr_time;
  }

  @override
  void initState() {
    super.initState();
    fetchNotes('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.amber,
            title: const Text(
              'Notes',
              style: TextStyle(
                fontFamily: 'SFBold',
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: TextField(
              controller: _search,
              style: const TextStyle(
                fontFamily: 'SFRegular',
                fontSize: 16,
              ),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (text) {
                fetchNotes(text);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                var note = noteList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        print('Card tapped: ${note.noteTitle}');
                        
                      },
                      title: Text(
                        note.noteTitle,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontFamily: 'SFBold',
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Last updated at ${note.noteUpdatedDate}',
                        style: const TextStyle(
                            fontFamily: 'SFReguler',
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          print('Delete icon tapped for: ${note.noteTitle}');
                          deleteNote(note.noteId);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Add button pressed');
        },
        backgroundColor: Colors.amber,
        shape: CircleBorder(),
        child: Icon(
          Icons.edit_note_rounded,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
