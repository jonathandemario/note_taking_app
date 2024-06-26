import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box<String>('mybox');

  Future checkPin() async {
    final keyList = _myBox.keys.toList();

    print('Cek Key:');
    if (keyList.isNotEmpty) {
      for (var key in keyList) {
        print('Key: ${key}; Value: ${_myBox.get(key)}');
        // _myBox.delete(key);
      }
    } else {
      print('List Empty');
    }
  }

  @override
  void initState() {
    checkPin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Note'),
      ),
    );
  }
}
