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
    final days = widget.passedValue.map((element) => (element.day)).toList();
    final url = widget.passedValue.map((element) => (element.url)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('履歴一覧ページ'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(days[0] + url[0]),
          Text(days[1] + url[1]),
        ],
      ),
    );
  }
}
