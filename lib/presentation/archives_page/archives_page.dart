import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//StatelessWidgetで描き直し
class ArchivesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('aaa');
  }
}

// class RecordPage extends StatefulWidget {
//   //ここでイニシャライズする
//   RecordPage(this.passedValue);
//   final List<Record> passedValue;
//
//   @override
//   State<RecordPage> createState() => RecordPageState();
// }
//
// class RecordPageState extends State<RecordPage> {
//   int _selectedIndex = 0;
//   void _onItemTapped(int index) {
//     setState(
//       () {
//         _selectedIndex = index;
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Record> records = <Record>[];
//     final days = widget.passedValue.map((element) => (element.day)).toList();
//     final url = widget.passedValue.map((element) => (element.url)).toList();
//
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('aaaaa'),
//         ),
//         // bottomNavigationBar: BottomNavigationBar(
//         //   type: BottomNavigationBarType.fixed,
//         //   items: const [
//         //     BottomNavigationBarItem(
//         //       icon: Icon(Icons.home),
//         //       title: Text('Home'),
//         //     ),
//         //     BottomNavigationBarItem(
//         //       icon: Icon(Icons.article_outlined),
//         //       title: Text('archives'),
//         //     ),
//         //     BottomNavigationBarItem(
//         //       icon: Icon(Icons.text_format),
//         //       title: Text('Daily record'),
//         //     ),
//         //     BottomNavigationBarItem(
//         //       title: Text('Web Page'),
//         //       icon: Icon(Icons.add_box_rounded),
//         //     ),
//         //   ],
//         //   currentIndex: _selectedIndex,
//         //   selectedItemColor: Colors.amber[800],
//         //   onTap: _onItemTapped,
//         // ),
//         body: _selectedIndex == 0 ? Text('aaa') : Text('bbb'));
//     // return CupertinoTabScaffold(
//     //   tabBar: CupertinoTabBar(
//     //     items: const <BottomNavigationBarItem>[
//     //       BottomNavigationBarItem(
//     //         icon: Icon(Icons.home),
//     //         title: Text('home'),
//     //       ),
//     //       BottomNavigationBarItem(
//     //         icon: Icon(Icons.format_color_text),
//     //         title: Text('daily archives'),
//     //       )
//     //     ],
//     //     // onTap: ,
//     //     // currentIndex: ,
//     //   ),
//     //   tabBuilder: (BuildContext context, int index) {
//     //     return CupertinoTabView(
//     //       builder: (BuildContext context) {
//     //         return CupertinoPageScaffold(
//     //           navigationBar: CupertinoNavigationBar(
//     //             middle: Text('Page 1 of tab $index'), //ここがタイトル
//     //           ),
//     //           child: Center(
//     //             child: MemoPage(records),
//     //             // child: CupertinoButton(
//     //             //   child: const Text('Next page'),
//     //             //   onPressed: () {
//     //             //     Navigator.push(
//     //             //         context,
//     //             //         MaterialPageRoute(
//     //             //             builder: (context) => MyHomePage(
//     //             //                   title: 'Home',
//     //             //                 )));
//     //             //   },
//     //             // ),
//     //           ),
//     //         );
//     //       },
//     //     );
//     //   },
//     // );
//   }
// }
