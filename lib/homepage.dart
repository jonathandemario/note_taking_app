import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  final _key = TextEditingController();
  final _val = TextEditingController();
  final _aKey = TextEditingController();
  String data = "";
  void writeData() {
    _myBox.put(_key.text, _val.text);
  }

  void readData() {
    //debugPrint(_myBox.get(1));
    setState(() {
      data = _myBox.get(_aKey.text);
    });
  }

  void deleteData() {
    _myBox.delete(_aKey.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'new key',
              ),
              controller: _key,
            ),
          ),
          const SizedBox(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'value',
              ),
              controller: _val,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: writeData,
                color: Colors.blue,
                child: const Text('Write'),
              ),
              MaterialButton(
                onPressed: readData,
                color: Colors.blue,
                child: const Text('Read'),
              ),
              MaterialButton(
                onPressed: deleteData,
                color: Colors.blue,
                child: const Text('Delete'),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50,
            child: TextField(
              controller: _aKey,
              decoration: const InputDecoration(
                hintText: 'key',
              ),
            ),
          ),
          Text(data)
        ],
      ),
    ));
  }
}
