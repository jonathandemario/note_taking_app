import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/main.dart';
import 'package:note_taking_app/pages/home_page.dart';
import 'package:note_taking_app/pages/detail_page.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:quickalert/quickalert.dart';

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

  String title = '';
  String detail = '';

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
            child: const Text(
              'Select',
              style: TextStyle(
                  fontFamily: 'SFBold', fontSize: 14, color: Colors.white),
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

  DateTime getTime() {
    DateTime curr_timestamp = DateTime.now();
    return curr_timestamp;
  }

  String getFormatTime(curr_timestamp) {
    String currTime =
        '${DateFormat('EEE, dd MMM yyyy').format(curr_timestamp)} (${DateFormat('hh:mm a').format(curr_timestamp)})';
    return currTime;
  }

  Future createNote(Note data) async {
    if (data.noteTitle == '' && data.noteDetail == '') {
      Navigator.pop(context, false);
    } else {
      if (data.noteTitle == '' && data.noteDetail != '') {
        data.noteTitle = 'New Note';
        _notes.put(checkIndex(), data);
        Navigator.pop(context, true);
      } else {
        _notes.put(checkIndex(), data);
        Navigator.pop(context, true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

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
            Note this_note = Note(
                noteTitle: title,
                noteDetail: detail,
                noteCreatedDate: getTime(),
                noteUpdatedDate: getTime(),
                noteId: checkIndex(),
                noteColor: currentColor.toString());
            createNote(this_note);
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
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
            ),
            onPressed: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: 'Note Not Saved',
                text: 'Do you want to discard this note?',
                animType: QuickAlertAnimType.scale,
                confirmBtnText: 'Yes',
                cancelBtnText: 'No',
                confirmBtnColor: Colors.green,
                onConfirmBtnTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context, false);
                },
              );
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
                    style: TextStyle(fontFamily: 'SFBold', fontSize: 20),
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
                    minLines: 24,
                    expands: false,
                    maxLines: null,
                    style: TextStyle(fontFamily: 'SFRegular', fontSize: 18),
                    cursorColor: Colors.amber,
                    decoration: const InputDecoration(
                      hintText: 'Enter your notes...',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(),
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
