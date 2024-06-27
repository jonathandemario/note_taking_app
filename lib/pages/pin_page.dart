import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/main.dart';
import 'package:note_taking_app/pages/home_page.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  var _pass = Hive.box('password');
  String enteredPass = '';
  late bool isNew;

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (enteredPass.length < 4) {
              enteredPass += number.toString();
            }
          });
        },
        child: Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future fetchPass() async {
    var currPass = _pass.get('pin');
    if (currPass == null) {
      isNew = true;
    } else {
      isNew = false;
    }
    print(currPass);
    print(isNew);
  }

  @override
  void initState() {
    super.initState();
    // _pass.put('pin', 1234);
    _pass.delete('pin');
    fetchPass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        // title: const Text(
        //   'Notes',
        //   style: TextStyle(
        //       fontFamily: 'SFBold', fontSize: 30, color: Colors.white),
        // ),
      ),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}