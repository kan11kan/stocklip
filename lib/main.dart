import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/record.dart';
import 'package:one_app_everyday921/record_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'memo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'na',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Stock Clip'), //ここのtitleは変数？
    );
  }
}

//ここからステートフルウィジェットについて
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//ここからステートについての記述
class _MyHomePageState extends State<MyHomePage> {
  final List<Record> records = <Record>[]; // setStateで状態を管理したいのでここで宣言をしている値
  final String day =
      DateFormat('yyyy-MM-dd').format(DateTime.now()); //一度だけ定義したい値
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }
// @override dispose()//super.disposeと定義すると一回通る→datetime.nowで取れる。

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
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
                                    image: AssetImage('images/google_logo.png'),
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
                                    builder: (context) =>
                                        WebPage('https://www.bloomberg.co.jp/'),
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
                          )
                        ],
                      ),
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
                                    image: AssetImage('images/google_logo.png'),
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
                                    builder: (context) =>
                                        WebPage('https://www.bloomberg.co.jp/'),
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
                                  Material(child: Text('Bloomberg')),
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
                                          'https://finance.yahoo.co.jp/'),
                                    ),
                                  );
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
                                )),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 30),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
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
                          )
                        ],
                      ),
                    ],
                  ),
                );
                // }
              }, //builder(BuildContext Context)
            );
          case 1:
            return RecordPage(records);
          case 2:
            return MemoPage(records);
          default:
            return Text('');
        } //ここに　caseの場合わけの　}　挿入予定
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
          )
        ],
      ),
    );
  } //ここまでWidgetbuild
} //ここまでMyHomePageState

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

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); //ビルドするたびに代入される値。setstateでは変えることができない。
    // DateFormat outputFormat = DateFormat('yyyy/MM/dd(E) HH:mm:ss');
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String day = outputFormat.format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text(day),
      ),
      body: WebView(
        initialUrl: widget.firstUrl,
        onPageFinished: (url) {
          final record = Record(url: url, day: day);

          records.add(record);
        },
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MemoPage(records),
              ),
            );
            // print('item is List: ${items is List}');
          },
          child: const Icon(Icons.article_outlined),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
