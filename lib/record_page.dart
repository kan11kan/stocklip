import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_app_everyday921/record.dart';

import 'main.dart';

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

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('履歴一覧ページ'),
    //   ),
    //   body: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       Text(days[0] + url[0]),
    //       Text(days[1] + url[1]),
    //     ],
    //   ),
    // );
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('home')),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_color_text),
            title: Text('daily archives'),
          )
        ],
        // onTap: _onItemTapped(0),
        // currentIndex: ,
      ),
      // tabBuilder: (context, int index) {
      //   switch (index) {
      //     case 0: // 1番左のタブが選ばれた時の画面
      //       return CupertinoTabView(builder: (context) {
      //         return CupertinoPageScaffold(
      //           navigationBar: CupertinoNavigationBar(
      //             leading: Icon(Icons.home), // ページのヘッダ左のアイコン
      //           ),
      //           child: Text('aaa'), // 表示したい画面のWidget
      //         );
      //       });
      //     case 1: // ほぼ同じなので割愛
      //       return CupertinoTabView(builder: (context) {
      //         return CupertinoPageScaffold(
      //           navigationBar: CupertinoNavigationBar(
      //             leading: Icon(Icons.home), // ページのヘッダ左のアイコン
      //           ),
      //           child: Text('bbb'), // 表示したい画面のWidget
      //         );
      //       });
      //   }
      // }

      //試しにコピペ
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text('Page 1 of tab $index'), //ここがタイトル
              ),
              child: Center(
                child: CupertinoButton(
                  child: const Text('Next page'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  title: 'Home',
                                )));
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
