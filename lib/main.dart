import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/record.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'memo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Stock Clip'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Record> records = <Record>[]; // setStateで状態を管理したいのでここで宣言をしている値
  final String day =
      DateFormat('yyyy-MM-dd').format(DateTime.now()); //一度だけ定義したい値

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildText(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined), title: Text('')),
          BottomNavigationBarItem(
              icon: Icon(Icons.text_format), title: Text('Daily record'))
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: _selectedIndex == 0
          ? Text('aaa')
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        WebPage('https://www.google.com/')));
                          },
                          child: Column(
                            children: [
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebPage(
                                        'https://www.bloomberg.co.jp/')));
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebPage(
                                        'https://finance.yahoo.co.jp/')));
                          },
                          child: Column(
                            children: [
                              Image(
                                width: 80,
                                height: 80,
                                image:
                                    AssetImage('images/yahoofinance_logo.jpeg'),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebPage(
                                            'https://nikkei225jp.com/cme/')));
                              },
                              child: Image(
                                width: 80,
                                height: 80,
                                image: AssetImage('images/cme_logo.jpeg'),
                              )),
                          Text('CME日経平均')
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        WebPage('https://www.google.com/')));
                          },
                          child: Column(
                            children: [
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebPage(
                                        'https://www.bloomberg.co.jp/')));
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebPage(
                                        'https://finance.yahoo.co.jp/')));
                          },
                          child: Column(
                            children: [
                              Image(
                                width: 80,
                                height: 80,
                                image:
                                    AssetImage('images/yahoofinance_logo.jpeg'),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebPage(
                                            'https://nikkei225jp.com/cme/')));
                              },
                              child: Image(
                                width: 80,
                                height: 80,
                                image: AssetImage('images/cme_logo.jpeg'),
                              )),
                          Text('CME日経平均')
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => MemoPage(records)));
      //   },
      //   child: const Icon(Icons.article_outlined),
      // ),
    );
  }

  Text buildText() => Text(widget.title);
}

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
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String day = outputFormat.format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text(day),
      ),
      body: WebView(
        initialUrl: widget.firstUrl,
        onPageFinished: (url) {
          final record = Record(url: url, day: day); //コンストラクタを呼び出している
          // final record2 = record.copyWith(
          //     url: 'https://aaa.com'); //インスタンス化したクラスに対して値を差し替えたい時に使う

          records.add(record);
          // days.add('${date}');
          // print(records[0].url);
          // print(records[1].day);
          // records.forEach((element) => print(element.url));
          print(records.map((element) => (element.url)).toList());
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
