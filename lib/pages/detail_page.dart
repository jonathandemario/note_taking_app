import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/pages/pin_page.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:quickalert/quickalert.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  final curr_title;
  final curr_detail;
  final curr_created_date;
  final curr_updated_date;
  final curr_id;
  final curr_color;

  DetailPage(
      {super.key,
      required this.curr_title,
      required this.curr_detail,
      required this.curr_created_date,
      required this.curr_updated_date,
      required this.curr_id,
      required this.curr_color});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with WidgetsBindingObserver {
  var _notes = Hive.box<Note>('notes');

  List<Note> noteList = [];

  Color pickerColor = Colors.white54;
  Color currentColor = Colors.white54;

  String title = '';
  String detail = '';

  Timer? _backgroundTimer;

  late TextEditingController _controllerTitle;
  late TextEditingController _controllerDetail;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Color parseColor(String colorString) {
    String hexString = colorString.replaceAll('Color(', '').replaceAll(')', '');
    int hexValue = int.parse(hexString);
    return Color(hexValue);
  }

  showPicker() {
    return showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SizedBox(
          height: 150,
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
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
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

  DateTime getTime() {
    DateTime curr_timestamp = DateTime.now();
    return curr_timestamp;
  }

  String getFormatTime(curr_timestamp) {
    String currTime =
        '${DateFormat('EEE, dd MMM yyyy').format(curr_timestamp)} (${DateFormat('hh:mm a').format(curr_timestamp)})';
    return currTime;
  }

  Future fetchData() async {
    _controllerTitle = TextEditingController(text: widget.curr_title);
    _controllerDetail = TextEditingController(text: widget.curr_detail);
    title = widget.curr_title;
    detail = widget.curr_detail;
    currentColor = parseColor(widget.curr_color);
    pickerColor = parseColor(widget.curr_color);
  }

  Future updateNote(Note data) async {
    if (data.noteTitle == widget.curr_title && data.noteDetail == widget.curr_detail && data.noteColor == widget.curr_color) {
      Navigator.pop(context, false);
    } else {
      if (data.noteTitle == '' && data.noteDetail == '') {
        _notes.delete(data.noteId);
        Navigator.pop(context, true);
      } else {
        if (data.noteTitle == '' && data.noteDetail != '') {
          data.noteTitle = 'New Note';
          _notes.put(data.noteId, data);
          Navigator.pop(context, true);
        } else {
          _notes.put(data.noteId, data);
          Navigator.pop(context, true);
        }
      }
    }
  }

  Future deleteNote(index) async {
    _notes.delete(index);
    if (mounted) {
      Navigator.pop(context);
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
        Note this_note = Note(
            noteTitle: title,
            noteDetail: detail,
            noteCreatedDate: widget.curr_created_date,
            noteUpdatedDate: getTime(),
            noteId: widget.curr_id,
            noteColor: currentColor.toString());
        updateNote(this_note);
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
    return WillPopScope(
      onWillPop: () async {
         Note this_note = Note(
            noteTitle: title,
            noteDetail: detail,
            noteCreatedDate: widget.curr_created_date,
            noteUpdatedDate: getTime(),
            noteId: widget.curr_id,
            noteColor: currentColor.toString());
        updateNote(this_note);
        return true;
      },
      child: Scaffold(
        backgroundColor: currentColor,
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
                  noteCreatedDate: widget.curr_created_date,
                  noteUpdatedDate: getTime(),
                  noteId: widget.curr_id,
                  noteColor: currentColor.toString());
              updateNote(this_note);
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
                  title: 'Note Delete',
                  text: 'Do you want to delete this note?',
                  animType: QuickAlertAnimType.scale,
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  confirmBtnColor: Colors.green,
                  onConfirmBtnTap: () {
                    deleteNote(widget.curr_id);
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
                      controller: _controllerTitle,
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
                      controller: _controllerDetail,
                      onChanged: (value) {
                        setState(() {
                          detail = value;
                        });
                      },
                      minLines: 22,
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
                    SizedBox(height: 20),
                    Text(
                      'Created: ${getFormatTime(widget.curr_created_date)}',
                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                    Text(
                      'Last Updated: ${getFormatTime(widget.curr_updated_date)}',
                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
