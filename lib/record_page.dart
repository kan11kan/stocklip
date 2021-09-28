import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_app_everyday921/record.dart';

class RecordPage extends StatefulWidget {
  //ここでイニシャライズする
  RecordPage(this.passedValue);
  final List<Record> passedValue;

  @override
  State<RecordPage> createState() => RecordPageState();
}

class RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    List<Record> records = <Record>[];
    final days = widget.passedValue.map((element) => (element.day)).toList();
    final url = widget.passedValue.map((element) => (element.url)).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('archives'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('アーカイブ'),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today_rounded)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
