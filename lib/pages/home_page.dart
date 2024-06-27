import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/main.dart';
import 'package:note_taking_app/pages/create_page.dart';
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
    // String curr_time = DateFormat('dd/MM/yyyy HH:mm:ss').format(curr_timestamp);
    String curr_time = DateFormat('EEE, dd MMM yyyy').format(curr_timestamp) +
        ' (' +
        DateFormat('hh:mm a').format(curr_timestamp) +
        ')';
    return curr_time;
  }

  @override
  void initState() {
    super.initState();
    // Note this_data = Note(noteTitle: 'b', noteDetail: 'a', noteCreatedDate: getTime(), noteUpdatedDate: getTime(), noteId: checkIndex(), noteColor: 'Colors.yellow');
    // _notes.put(checkIndex(), this_data);
    fetchNotes('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          'Notes',
          style: TextStyle(
            fontFamily: 'SFBold',
            fontSize: 30,
            color: Colors.white
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
              cursorColor: Colors.amber,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
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
                    // color: getColor(note.noteColor),
                    color: Colors.white,
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
                        'Last updated: ${getFormatTime(note.noteUpdatedDate)}',
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => CreatePage()
          //   )
          // );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePage(
              )
            ),
          );
        },
        backgroundColor: Colors.amber,
        shape: CircleBorder(),
        child: Icon(
          Icons.edit_note_rounded,
          size: 30,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
