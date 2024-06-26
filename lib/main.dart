import 'package:flutter/material.dart';
import 'package:note_taking_app/note.dart';
import 'package:note_taking_app/pin_page.dart';
import 'package:note_taking_app/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(NoteAdapter());
  await Hive.initFlutter();
  // await Hive.openBox('password');
  await Hive.openBox<Note>('notes');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Notes",
      home: HomePage(),
    );
  }
}
