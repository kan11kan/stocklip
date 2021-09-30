import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/domain/record.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'presentation/memo_page/memo_page.dart';
import 'presentation/record_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'nanannanana',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

//ここからステートフルウィジェットについて（念の為残している。）
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

//ここからgetXでタブビューをタップした時のコントローラーを記載
// class TabViewController extends GetxController {
//   // final onItemTapped = 0.obs;
//   var selectedIndex = 1.obs;
//   void onItemTapped(int index) {
//     selectedIndex = index as RxInt;
//   }
// }

//     int _selectedIndex = 0;
//         void _onItemTapped(int index) {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),

class TabViewController extends GetxController {
  var selectedIndex1 = 0.obs;
  void onItemTapped1(int index) {
    selectedIndex1.value = index;
    // update();
  }
}

//クラスわけで分割していく（ステートレスウィジェットにしながら）
class MyHomePage extends StatelessWidget {
  final List<Widget> childList = [WebPage('aaa'), RecordPage([])];
  final tvc = Get.put(TabViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            title: Text('archives'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_format),
            title: Text('Daily record'),
          ),
          BottomNavigationBarItem(
            title: Text('Web Page'),
            icon: Icon(Icons.add_box_rounded),
          ),
        ],
        currentIndex: tvc.selectedIndex1.toInt(),
        selectedItemColor: Colors.amber[800],
        // onTap: GC.onItemTapped,
        onTap: tvc.onItemTapped1,
      ),
      // body: childList[GC.selectedIndex.value],
      body: Obx(() => childList[tvc.selectedIndex1.value]),
    );
  }
}

//ここからボディの中身（MyHomePageContent）を記載していく
class MyHomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('aaa');
  }
}

//ここからステートについての記述
// class _MyHomePageState extends State<MyHomePage> {
//   final List<Record> records = <Record>[]; // setStateで状態を管理したいのでここで宣言をしている値
//   final String day =
//       DateFormat('yyyy-MM-dd').format(DateTime.now()); //一度だけ定義したい値
//
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   final List<Widget> chiledList = [WebPage('aaa'), RecordPage([])];
// // @override dispose()//super.disposeと定義すると一回通る→datetime.nowで取れる。
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               title: Text('Home'),
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.article_outlined),
//               title: Text('archives'),
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.text_format),
//               title: Text('Daily record'),
//             ),
//             BottomNavigationBarItem(
//               title: Text('Web Page'),
//               icon: Icon(Icons.add_box_rounded),
//             ),
//           ],
//           currentIndex: _selectedIndex,
//           selectedItemColor: Colors.amber[800],
//           onTap: _onItemTapped,
//         ),
//         body: chiledList[_selectedIndex]
//         // void changeTab(context, _selectedIndex) {
//         //   switch (_selectedIndex) {
//         //     case 0:Text('aaaa');
//         //   }
//         // }
//         // _selectedIndex == 0
//         //     ? Column(
//         //         mainAxisAlignment: MainAxisAlignment.center,
//         //         children: [
//         //           Row(
//         //             mainAxisAlignment: MainAxisAlignment.spaceAround,
//         //             children: [
//         //               Container(
//         //                 padding: EdgeInsets.only(bottom: 30),
//         //                 child: GestureDetector(
//         //                     onTap: () {
//         //                       Navigator.push(
//         //                           context,
//         //                           MaterialPageRoute(
//         //                               builder: (context) =>
//         //                                   WebPage('https://www.google.com/')));
//         //                     },
//         //                     child: Column(
//         //                       children: const [
//         //                         Image(
//         //                           width: 80,
//         //                           height: 80,
//         //                           image: AssetImage('images/google_logo.png'),
//         //                         ),
//         //                         Text('google.com'),
//         //                       ],
//         //                     )),
//         //               ),
//         //               Container(
//         //                 padding: EdgeInsets.only(bottom: 30),
//         //                 child: GestureDetector(
//         //                     onTap: () {
//         //                       Navigator.push(
//         //                           context,
//         //                           MaterialPageRoute(
//         //                               builder: (context) => WebPage(
//         //                                   'https://www.bloomberg.co.jp/')));
//         //                     },
//         //                     child: Column(
//         //                       children: [
//         //                         Image(
//         //                           width: 80,
//         //                           height: 80,
//         //                           image: AssetImage('images/bloomberg.png'),
//         //                         ),
//         //                         Text('Bloomberg')
//         //                       ],
//         //                     )),
//         //               ),
//         //               Container(
//         //                 padding: EdgeInsets.only(bottom: 30),
//         //                 child: GestureDetector(
//         //                     onTap: () {
//         //                       Navigator.push(
//         //                           context,
//         //                           MaterialPageRoute(
//         //                               builder: (context) => WebPage(
//         //                                   'https://finance.yahoo.co.jp/')));
//         //                     },
//         //                     child: Column(
//         //                       children: [
//         //                         Image(
//         //                           width: 80,
//         //                           height: 80,
//         //                           image:
//         //                               AssetImage('images/yahoofinance_logo.jpeg'),
//         //                         ),
//         //                         Text('Yahoo Finance!')
//         //                       ],
//         //                     )),
//         //               ),
//         //               Container(
//         //                 padding: EdgeInsets.only(bottom: 30),
//         //                 child: Column(
//         //                   children: [
//         //                     GestureDetector(
//         //                       onTap: () {
//         //                         Navigator.push(
//         //                           context,
//         //                           MaterialPageRoute(
//         //                             builder: (context) =>
//         //                                 WebPage('https://nikkei225jp.com/cme/'),
//         //                           ),
//         //                         );
//         //                       },
//         //                       child: Image(
//         //                         width: 80,
//         //                         height: 80,
//         //                         image: AssetImage('images/cme_logo.jpeg'),
//         //                       ),
//         //                     ),
//         //                     Text('CME日経平均')
//         //                   ],
//         //                 ),
//         //               ),
//         //             ],
//         //           ),
//         //           Row(
//         //             mainAxisAlignment: MainAxisAlignment.spaceAround,
//         //             children: [
//         //               Container(
//         //                 padding: EdgeInsets.only(bottom: 30),
//         //                 child: GestureDetector(
//         //                   onTap: () {
//         //                     Navigator.push(
//         //                         context,
//         //                         MaterialPageRoute(
//         //                             builder: (context) =>
//         //                                 WebPage('https://www.google.com/')));
//         //                   },
//         //                   child: Column(
//         //                     children: [
//         //                       Image(
//         //                         width: 80,
//         //                         height: 80,
//         //                         image: AssetImage('images/google_logo.png'),
//         //                       ),
//         //                       Text('google.com'),
//         //                     ],
//         //                   ),
//         //                 ),
//         //               ),
//         //               Container(
//         //                 padding: EdgeInsets.only(bottom: 30),
//         //                 child: GestureDetector(
//         //                   onTap: () {
//         //                     Navigator.push(
//         //                         context,
//         //                         MaterialPageRoute(
//         //                             builder: (context) =>
//         //                                 WebPage('https://www.bloomberg.co.jp/')));
//         //                   },
//         //                   child: Column(
//         //                     children: [
//         //                       Image(
//         //                         width: 80,
//         //                         height: 80,
//         //                         image: AssetImage('images/bloomberg.png'),
//         //                       ),
//         //                       Text('Bloomberg')
//         //                     ],
//         //                   ),
//         //                 ),
//         //               ),
//         //               Container(
//         //                 padding: EdgeInsets.only(bottom: 30),
//         //                 child: GestureDetector(
//         //                   onTap: () {
//         //                     Navigator.push(
//         //                         context,
//         //                         MaterialPageRoute(
//         //                             builder: (context) =>
//         //                                 WebPage('https://finance.yahoo.co.jp/')));
//         //                   },
//         //                   child: Column(
//         //                     children: [
//         //                       Image(
//         //                         width: 80,
//         //                         height: 80,
//         //                         image:
//         //                             AssetImage('images/yahoofinance_logo.jpeg'),
//         //                       ),
//         //                       Text('Yahoo Finance!')
//         //                     ],
//         //                   ),
//         //                 ),
//         //               ),
//         //               Container(
//         //                 padding: EdgeInsets.only(bottom: 30),
//         //                 child: Column(
//         //                   children: [
//         //                     GestureDetector(
//         //                       onTap: () {
//         //                         Navigator.push(
//         //                             context,
//         //                             MaterialPageRoute(
//         //                                 builder: (context) => WebPage(
//         //                                     'https://nikkei225jp.com/cme/')));
//         //                       },
//         //                       child: Image(
//         //                         width: 80,
//         //                         height: 80,
//         //                         image: AssetImage('images/cme_logo.jpeg'),
//         //                       ),
//         //                     ),
//         //                     Text('CME日経平均')
//         //                   ],
//         //                 ),
//         //               ),
//         //             ],
//         //           )
//         //         ],
//         //       )
//         //     : Text('bbb'),
//         // floatingActionButton: FloatingActionButton(
//         //   onPressed: () {
//         //     Navigator.push(context,
//         //         MaterialPageRoute(builder: (context) => MemoPage(records)));
//         //   },
//         //   child: const Icon(Icons.article_outlined),
//         // ),
//         );
//   }
//
//   // Text buildText() => Text(widget.title);
// }

//ここからボタン押下後の遷移先ページ
class WebPage extends StatefulWidget {
  WebPage(this.firstUrl);
  final String firstUrl;

  @override
  State<WebPage> createState() => WebPageState();
}

class WebPageState extends State<WebPage> {
  List<Record> records = <Record>[]; // setStateで状態を管理したいのでここで宣言をしている値
  // final String day = DateFormat('yyyy-MM-dd').format(DateTime.now());

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); //ビルドするたびに代入される値。setstateでは変えることができない。
    // DateFormat outputFormat = DateFormat('yyyy/MM/dd(E) HH:mm:ss');
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String day = outputFormat.format(now);

    // DateTime now2 = DateTime.now();
    // String day2 = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    // DateTime day2 = DateTime.parse(day);

    return Scaffold(
      appBar: AppBar(
        title: Text(day),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            title: Text('Archives'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_format),
            title: Text('Daily News'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            title: Text('Web Page'),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: WebView(
        initialUrl: widget.firstUrl,
        onPageFinished: (url) {
          final record = Record(url: url, day: day);

          records.add(record);

          // days.add('${date}');
          // print(records[0].url);
          // print(records[1].day);
          // records.forEach((element) => print(element.url));
          // print(records.map((element) => (element.day)).toList());
          // print(now);
          // print(day2);
          // print(records.map((element) => (element.day)).toList());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MemoPage(records)));
          // print('item is List: ${items is List}');
        },
        child: const Icon(Icons.article_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
