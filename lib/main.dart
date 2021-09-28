import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'memo_page.dart';
import 'record.dart';
import 'record_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'na',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class GlobalController extends GetxController {
  final List<Record> records = <Record>[].obs;
  final day = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  RxString lastUrl = ''.obs;
}

class MyHomePage extends StatelessWidget {
  final gc = Get.put(GlobalController());
  @override
  Widget build(context) => CupertinoTabScaffold(
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return CupertinoPageScaffold(
                    navigationBar: const CupertinoNavigationBar(
                      backgroundColor: Colors.blue,
                      middle: Text(
                        'Home',
                        style: TextStyle(color: Colors.white),
                      ), //ここがタイトル
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WebPage('https://www.google.com/'),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: const [
                                    Image(
                                      width: 80,
                                      height: 80,
                                      image:
                                          AssetImage('images/google_logo.png'),
                                    ),
                                    Material(
                                      child: Text('google.com'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 30),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebPage(
                                          'https://www.bloomberg.co.jp/'),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: const [
                                    Image(
                                      width: 80,
                                      height: 80,
                                      image: AssetImage('images/bloomberg.png'),
                                    ),
                                    Material(
                                      child: Text('Bloomberg'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 30),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebPage(
                                              'https://finance.yahoo.co.jp/')));
                                },
                                child: Column(
                                  children: const [
                                    Image(
                                      width: 80,
                                      height: 80,
                                      image: AssetImage(
                                          'images/yahoofinance_logo.jpeg'),
                                    ),
                                    Material(
                                      child: Text('Yahoo Finance!'),
                                    ),
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
                                      //url = 'https://'
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WebPage(
                                              'https://nikkei225jp.com/cme/'),
                                        ),
                                      );
                                    },
                                    child: const Image(
                                      width: 80,
                                      height: 80,
                                      image: AssetImage('images/cme_logo.jpeg'),
                                    ),
                                  ),
                                  const Material(
                                    child: Text('CME日経平均'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                  // }
                }, //builder(BuildContext Context)
              );
            case 1:
              return RecordPage(gc.records);
            case 2:
              return MemoPage(gc.records);
            case 3:
              return Obx(() => WebPage(gc.lastUrl.value));
            default:
              return Text('');
          }
        },
        tabBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              title: Text('archives'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_color_text),
              title: Text('daily news'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('web page'),
            ),
          ],
        ),
      );
}

class WebPage extends StatelessWidget {
  GlobalController gc = Get.find();
  WebPage(this.firstUrl);
  String firstUrl;
  @override
  Widget build(context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.blue,
          middle: Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ), //ここがタイトル
        ),
        child: WebView(
          initialUrl: firstUrl,
          onPageFinished: (url) {
            final record = Record(url: url, day: gc.day.value);
            gc.records.add(record);
            gc.lastUrl = record.url as RxString;
          },
        ),
      );
}
