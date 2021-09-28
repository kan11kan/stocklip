import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_app_everyday921/record.dart';

import 'memo_page.dart';

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
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_color_text),
            title: Text('daily archives'),
          )
        ],
        // onTap: ,
        // currentIndex: ,
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text('Page 1 of tab $index'), //ここがタイトル
              ),
              child: Center(
                child: MemoPage(records),
                // child: CupertinoButton(
                //   child: const Text('Next page'),
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => MyHomePage(
                //                   title: 'Home',
                //                 )));
                //   },
                // ),
              ),
            );
          },
        );
      },
    );
  }
}
