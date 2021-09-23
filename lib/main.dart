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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  List<Record> records = <Record>[]; // setStateで状態を管理したいのでここで宣言をしている値
  List<String> days = <String>[];
  final String day =
      DateFormat('yyyy-MM-dd').format(DateTime.now()); //一度だけ定義したい値

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // String now = DateTime.now();       //ビルドするたびに代入される値。setstateでは変えることができない。
    // String day = widget.outputFormat.format(widget.now);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebView(
        initialUrl: 'https://www.google.com/',
        onPageFinished: (url) {
          final record = Record(url: url, day: day); //コンストラクタを呼び出している
          final record2 = record.copyWith(
              url: 'https://aaa.com'); //インスタンス化したクラスに対して値を差し替えたい時に使う

          records.add(record);
          // days.add('${date}');
          // print(records[0].url);
          // print(records[1].day);
          // records.forEach((element) => print(element.url));
          print([records.map((element) => (element.url))]);
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

// class ViewAToBArguments extends _MyHomePageState {
//   final int hogeId;
//   final String fuga;
//   // List<String> hogeId = widget.items;
//   // List<String> fuga = widget.days;
//   ViewAToBArguments(this.hogeId, this.fuga);
// }
