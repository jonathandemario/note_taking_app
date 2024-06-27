import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/pages/pin_page.dart';
import 'package:note_taking_app/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(NoteAdapter());
  await Hive.initFlutter();
  await Hive.openBox('password');
  await Hive.openBox<Note>('notes');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Notes",
      home: PinPage(),
    );
  }
}
