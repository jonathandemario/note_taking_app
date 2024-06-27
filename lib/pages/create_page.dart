import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/main.dart';
import 'package:note_taking_app/pages/home_page.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CreatePage extends StatefulWidget {
  CreatePage({
    super.key,
  });

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  var _notes = Hive.box<Note>('notes');
  List<Note> noteList = [];

  Color pickerColor = Colors.white54;
  Color currentColor = Colors.white54;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  showPicker() {
    return showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SizedBox(
          height: 150, // Adjust this value as needed
          child: BlockPicker(
            pickerColor: currentColor,
            onColorChanged: changeColor,
            availableColors: [
              Colors.red[100]!,
              Colors.orange[100]!,
              Colors.amber[100]!,
              Colors.green[100]!,
              Colors.blue[100]!,
              Colors.cyan[100]!,
              Colors.purple[100]!,
              Colors.white54,
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text(
              'Select',
              style: TextStyle(
                  fontFamily: 'SFBold', fontSize: 14, color: Colors.white),
            ),
            onPressed: () {
              print(pickerColor);
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber, // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Border radius
              ),
            ),
          ),
        ],
      ),
      context: context,
    );
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

  String title = '';
  String detail = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.color_lens_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              showPicker();
            },
          ),
        ],
      ),
      body: Container(
        color: currentColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                    expands: false,
                    maxLines: 1,
                    cursorColor: Colors.amber,
                    decoration: const InputDecoration(
                      hintText: 'Enter title...',
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 22),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        detail = value;
                      });
                    },
                    minLines: 26,
                    expands: false,
                    maxLines: null,
                    cursorColor: Colors.amber,
                    decoration: const InputDecoration(
                      hintText: 'Enter your notes...',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
