import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/pages/pin_page.dart';
import 'package:note_taking_app/pages/create_page.dart';
import 'package:note_taking_app/pages/detail_page.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickalert/quickalert.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var _notes = Hive.box<Note>('notes');
  final _search = TextEditingController();

  List<Note> noteList = [];
  String msg = '';

  Timer? _backgroundTimer;

  Color parseColor(String colorString) {
    String hexString = colorString.replaceAll('Color(', '').replaceAll(')', '');
    int hexValue = int.parse(hexString);
    return Color(hexValue);
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
          if (keyword == '')
            msg = 'There is no notes.';
          else
            msg = 'No result found.';
        });
      }
    } else {
      print('Notes Empty');
      setState(() {
        noteList = [];
        if (keyword == '')
          msg = 'There is no notes.';
        else
          msg = 'No result found.';
      });
    }
    setState(() {
      noteList.sort((a, b) => b.noteUpdatedDate.compareTo(a.noteUpdatedDate));
    });
  }

  Future deleteNote(index) async {
    _notes.delete(index);
    if (mounted) {
      Navigator.pop(context);
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          showConfirmBtn: false,
          text: 'Note Deleted!',
          autoCloseDuration: Duration(seconds: 1));
      fetchNotes('');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotes('');
    WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundTimer = Timer(Duration(minutes: 5), () {
        print('Reset to PIN Page');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => PinPage()),
          (Route<dynamic> route) => false,
        );
      });
    } else if (state == AppLifecycleState.resumed) {
      _backgroundTimer?.cancel();
      print('Reset to PIN Page Canceled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          'Notes',
          style: TextStyle(
              fontFamily: 'SFBold', fontSize: 30, color: Colors.white),
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
            child: noteList.isEmpty
                ? Center(
                    child: Text(
                      msg,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: noteList.length,
                    itemBuilder: (context, index) {
                      var note = noteList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Card(
                          color: parseColor(note.noteColor),
                          child: ListTile(
                            onTap: () {
                              print('Card tapped: ${note.noteTitle}');
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                              curr_title: note.noteTitle,
                                              curr_detail: note.noteDetail,
                                              curr_created_date:
                                                  note.noteCreatedDate,
                                              curr_updated_date:
                                                  note.noteUpdatedDate,
                                              curr_id: note.noteId,
                                              curr_color: note.noteColor)))
                                  .then((value) {
                                if (value == true) {
                                  fetchNotes('');
                                }
                              });
                            },
                            title: Text(
                              note.noteTitle,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'SFBold',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Last updated: ${getFormatTime(note.noteUpdatedDate)}',
                              style: const TextStyle(
                                fontFamily: 'SFRegular',
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                print(
                                    'Delete icon tapped for: ${note.noteTitle}');
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  title: 'Note Delete',
                                  text: 'Do you want to delete this note?',
                                  animType: QuickAlertAnimType.scale,
                                  confirmBtnText: 'Yes',
                                  cancelBtnText: 'No',
                                  confirmBtnColor: Colors.green,
                                  onConfirmBtnTap: () {
                                    deleteNote(note.noteId);
                                  },
                                );
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
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreatePage()))
              .then((value) {
            if (value == true) fetchNotes('');
          });
        },
        backgroundColor: Colors.amber,
        shape: CircleBorder(),
        child: const Icon(
          Icons.edit_note_rounded,
          size: 30,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
