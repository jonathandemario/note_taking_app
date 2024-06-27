import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/main.dart';
import 'package:note_taking_app/pages/home_page.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetailPage extends StatefulWidget {
  var curr_title;
  var curr_detail;
  final curr_created_date;
  var curr_updated_date;
  final curr_id;
  final bool isCreateNew;

  DetailPage({
    super.key,
    required this.curr_title,
    required this.curr_detail,
    required this.curr_created_date,
    required this.curr_updated_date,
    required this.curr_id,
    required this.isCreateNew
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var _notes = Hive.box<Note>('notes');
  List<Note> noteList = [];

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
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.color_lens_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  // showPicker();
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        // color: currentColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      // title = value;
                    });
                  },
                  expands: false, 
                  maxLines: 1,
                  cursorColor: Colors.amber,
                  decoration: InputDecoration(
                    hintText: 'Enter title...',
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      // detail = value;
                    });
                  },
                  minLines: 23,
                  expands: false,
                  maxLines: null,
                  cursorColor: Colors.amber,
                  decoration: InputDecoration(
                    hintText: 'Enter your notes...',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Created: ',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
                Text(
                  'Last Updated: ',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
