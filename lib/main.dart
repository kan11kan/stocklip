import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'domain/record.dart';
import 'presentation/memo_page/memo_page.dart';
import 'presentation/record_page/record_page.dart';

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

class TabViewController extends GetxController {
  var selectedUrl = ''.obs;
  var selectedIndex1 = 0.obs;
  void onItemTapped1(int index) {
    selectedIndex1.value = index;
  }
}

//クラスわけで分割していく（ステートレスウィジェットにしながら）
class MyHomePage extends StatelessWidget {
  final List<Widget> childList = [
    MyHomePageContent(),
    MemoPage([]),
    RecordPage([]),
    WebContentPage(),
  ];
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
        onTap: tvc.onItemTapped1,
      ),
      // body: childList[GC.selectedIndex.value],
      body: Obx(() => childList[tvc.selectedIndex1.value]),
    );
  }
}

//ここからボディの中身（MyHomePageContent）を記載していく
class MyHomePageContent extends StatelessWidget {
  final tvc = Get.put(TabViewController());
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 30),
            child: GestureDetector(
                onTap: () {
                  tvc.selectedIndex1.value = 3;
                  tvc.selectedUrl.value = 'https://www.google.com/';
                  Get.to(WebPage());
                },
                child: Column(
                  children: const [
                    Image(
                      width: 80,
                      height: 80,
                      image: AssetImage('images/google_logo.png'),
                    ),
                    Text('google.com'),
                  ],
                )),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 30),
            child: GestureDetector(
                onTap: () {
                  tvc.selectedIndex1.value = 3;
                  tvc.selectedUrl.value = 'https://www.bloomberg.co.jp/';
                  Get.to(WebPage());
                },
                child: Column(
                  children: [
                    Image(
                      width: 80,
                      height: 80,
                      image: AssetImage('images/bloomberg.png'),
                    ),
                    Text('Bloomberg')
                  ],
                )),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 30),
            child: GestureDetector(
                onTap: () {
                  tvc.selectedIndex1.value = 3;
                  tvc.selectedUrl.value = 'https://finance.yahoo.co.jp/';
                  Get.to(WebPage());
                },
                child: Column(
                  children: [
                    Image(
                      width: 80,
                      height: 80,
                      image: AssetImage('images/yahoofinance_logo.jpeg'),
                    ),
                    Text('Yahoo Finance!')
                  ],
                )),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    tvc.selectedIndex1.value = 3;
                    tvc.selectedUrl.value = 'https://nikkei225jp.com/cme/';
                    Get.to(WebPage());
                  },
                  child: Image(
                    width: 80,
                    height: 80,
                    image: AssetImage('images/cme_logo.jpeg'),
                  ),
                ),
                Text('CME日経平均')
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}

//WebPageをStatelessWidgetに書き換え
class WebPage extends StatelessWidget {
  final List<Widget> childList = [
    MyHomePageContent(),
    MemoPage([]),
    RecordPage([]),
    WebContentPage(),
  ];
  final tvc = Get.put(TabViewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('今日'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
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
        currentIndex: tvc.selectedIndex1.toInt(),
        selectedItemColor: Colors.amber[800],
        onTap: tvc.onItemTapped1,
      ),
      // body: WebContentPage(),
      body: Obx(() => childList[tvc.selectedIndex1.value]),
    );
  }
}

class WebContentPage extends StatelessWidget {
  final tvc = Get.put(TabViewController());
  final day = ''; //仮で作成
  List<Record> records = <Record>[]; //仮で作成
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: tvc.selectedUrl.value.toString(),
      onPageFinished: (url) {
        final record = Record(url: url, day: day);
        records.add(record);
      },
    );
  }
}

//dateの書き方について念の為残す
//   final List<Record> records = <Record>[]; // setStateで状態を管理したいのでここで宣言をしている値
//   final String day =
//       DateFormat('yyyy-MM-dd').format(DateTime.now()); //一度だけ定義したい値
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now(); //ビルドするたびに代入される値。setstateでは変えることができない。
//     // DateFormat outputFormat = DateFormat('yyyy/MM/dd(E) HH:mm:ss');
//     DateFormat outputFormat = DateFormat('yyyy-MM-dd');
//     String day = outputFormat.format(now);
