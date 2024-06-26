import 'package:flutter/material.dart';
import 'package:note_taking_app/pin_page.dart';
import 'package:note_taking_app/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  // await Hive.openBox('password');
  // await Hive.openBox('notes');
  await Hive.openBox<String>('myBox');
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
