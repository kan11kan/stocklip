// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:one_app_everyday921/presentation/archives_page/archives_page.dart';
import 'package:one_app_everyday921/presentation/daily_page/daily_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'domain/record.dart';
import 'model/transaction.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox('settings');
  final box = await Hive.openBox('settings');
  box.put('settings', 'kan');
  box.put('key', 'kankan');
  box.put('1', 'kankankan');
  // print('${box.get('settings')}');
  var x = box.get('settings');
  var y = box.get('key');
  var z = box.get('1');
  print(x);
  print(y);
  print(z);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
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
  final bbb = ''.obs;
  void aaa() async {
    await Hive.openBox('settings');
    final box = await Hive.openBox('settings');
    bbb.value = box.get('key');
  }

  var selectedUrl = ''.obs; //試しに書いているだけ
  var selectedIndex1 = 0.obs;
  void onItemTapped1(int index) {
    selectedIndex1.value = index;
  }
}

//クラスわけで分割していく（ステートレスウィジェットにしながら）
class MyHomePage extends StatelessWidget {
  final List<Widget> childList = [
    MyHomePageContent(),
    ArchivesPage(),
    DailyPage(),
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
      body: Obx(() => childList[tvc.selectedIndex1.value]),
      // ValueListenableBuilder(
      // Openされたbox('settings')をReadしている
      // valueListenable: Hive.box('settings').listenable(keys: ['key', '1']),
      // builder: (context, box, widget) {
      //   return Center(
      //     child:
      //         // child: Text('aaaa'),
      //         Obx(() => Text('${tvc.bbb.value}')),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     tvc.aaa();
      //   },
      //   child: const Icon(Icons.navigation),
      //   backgroundColor: Colors.green,
      // ),
    );
  }
}

//ここからボディの中身（MyHomePageContent）を記載していく
class MyHomePageContent extends StatelessWidget {
  final tvc = Get.put(TabViewController());
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                ),
              ),
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
      ],
    );
  }
}

//WebPageをStatelessWidgetに書き換え
class WebPage extends StatelessWidget {
  final List<Widget> childList = [
    MyHomePageContent(),
    ArchivesPage(),
    DailyPage(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
    );
  }
}

//ここからWebPageのURLを保存するモデル（コントローラーを記載）
class WebController extends GetxController {
  final List<Record> records = <Record>[].obs;
  List<String> todayUrls = <String>[];
}

//Webの中身だけ表示するページ
class WebContentPage extends StatelessWidget {
  final tvc = Get.put(TabViewController());
  final wc = Get.put(WebController());
  final day = ''; //仮で作成

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: tvc.selectedUrl.value.toString(),
      onPageFinished: (url) {
        final record = Record(url: url, day: day);
        wc.records.add(record);
        void saveUrl() async {
          await Hive.openBox('url');
          final box = await Hive.openBox('url');
          box.put('records', jsonEncode(wc.records));
          // print('${box.get('records')}');
        }

        saveUrl();
      },
    );
  }
}

//ここからfirestoreを試す（追加）
// class FirestoreController extends GetxController {
// FirebaseFirestore firestore = FirebaseFirestore.instance;
// addToFirestore(coll, docId, newData) {
//   final docRef = firestore.collection(coll).doc(docId);
//   return docRef.set(newData);
// }

//   getFromFirestore(coll, docID) {
//     //collにコレクションID、docIDにドキュメントIDを渡す
//     final docRef = firestore.collection(coll).doc(docID);
//     return docRef.get();
//   }
// }

//dateの書き方について念の為残す
//   final List<Record> records = <Record>[]; // setStateで状態を管理したいのでここで宣言をしている値
//   final String day =
//       DateFormat('yyyy-MM-dd').format(DateTime.now()); //一度だけ定義したい値
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now(); //ビルドするたびに代入される値。setstateでは変えることができない。
//     // DateFormat outputFormat = DateFormat('yyyy/MM/dd(E) HH:mm:ss');
//     DateFormat outputFormat = DateFormat('yyyy-MM-dd');
//     String day = outputFormat.format(now);
