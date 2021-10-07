import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/domain/daily_class.dart';

import 'archives_button_widget.dart';

///アーカイブページ全体の記述
class ArchivesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            shadowColor: Colors.black54,
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                    child: Container(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'キーワード検索',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: DateRangePickerWidget(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //Archivesのページに検索履歴を表示する。戻るボタンでArchivesに戻る。
                      //Get.to()で記載
                      Get.to(SearchResult());
                    },
                    child: Text('検索'),
                  ),
                ],
              ),
            ),
          ),
          ShowCards(),
        ],
      ),
    );
  }
}

///ここから日付の範囲を指定するWidget
class DateRangePickerWidget extends StatefulWidget {
  @override
  _DateRangePickerWidgetState createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  DateTimeRange dateRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(hours: 24 * 3)));

  String getFrom() {
    if (dateRange == null) {
      return 'From';
    } else {
      return DateFormat('MM/dd/yyyy').format(dateRange.start);
    }
  }

  String getUntil() {
    if (dateRange == null) {
      return 'Until';
    } else {
      return DateFormat('MM/dd/yyyy').format(dateRange.end);
    }
  }

  @override
  Widget build(BuildContext context) => HeaderWidget(
        title: 'Date',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              child: ButtonWidget(
                text: getFrom(),
                onClicked: () => pickDateRange(context),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.blueGrey),
            const SizedBox(width: 8),
            SizedBox(
              width: 150,
              child: ButtonWidget(
                text: getUntil(),
                onClicked: () => pickDateRange(context),
              ),
            ),
          ],
        ),
      );

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 15),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: initialDateRange,
    );

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }
}

///ここからStatefullWidgetでリストビュー　＋　カードを試す
class ShowCards extends StatefulWidget {
  const ShowCards({
    Key? key,
  }) : super(key: key);
  @override
  ShowCardsState createState() => new ShowCardsState();
}

class ShowCardsState extends State<ShowCards> {
  ///DailyRecordクラスのオブジェクト配列の変化を監視
  RxList<Daily> dailyRecords = <Daily>[].obs;

  ///box('importantUrl',key='importantUrl')を開いてdailyRecordに格納、監視
  void getDailyRecords() async {
    final box = await Hive.openBox('importantUrl');
    dailyRecords.value = jsonDecode(box.get('importantUrl'))
        .map((el) => Daily.fromJson(el))
        .toList()
        .cast<Daily>() as List<Daily>;
  }

  ///memo, 日付のオブジェクト配列から日付を取得（順番は古い順になっている？）
  ///日経平均終値と日付を({日付:日付,日経:日経})オブジェクト配列に格納（とりあえずマニュアルで）
  final List nikkei = [];

  ///tagsの配列を作成（タグ　→　◯月◯日のタグNumber[1,2,5,6]など）
  final List tags = [
    '金利',
    '日経',
    '米国株',
    '個別株',
    'テクニカル',
    'FRB',
    'REIT',
    '債券',
    'その他'
  ];

  ///オブジェクト配列の長さを取得
  ///配列の長さ分のカードを作成
  ///Text（'日付'）を作成
  ///Text('日経平均終値')を作成
  ///Text('tags')を作成
  ///メモの有無を確認する
  ///メモがあればメモを表示、なければURLを表示　　isMemo ? showMemo() : showUrl();

  ///ここからリストビュー
  @override
  Widget build(BuildContext context) {
    ///box('importantUrl',key='importantUrl')を開く処理
    getDailyRecords();

    ///リストビュービルダー
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: dailyRecords.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Container(
                    child: Column(
                      children: [
                        Text('${dailyRecords[index].day}'),
                        Text('${nikkei[index]}'),
                        Row(
                          children: [
                            ElevatedButton(
                              ///例で記載
                              child: Text('${tags[3]}'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        Container(
                          child: dailyRecords[index].memo == ''
                              ? Card(
                                  child: Text('URLが表示されます'),
                                )
                              : Card(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child: SizedBox(
                                      width: 270,
                                      height: 140,
                                      child: Text('メモが表示されます'),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

///ここから検索結果のページ
class SearchResult extends StatefulWidget {
  const SearchResult({
    Key? key,
    // this.color = const Color(0xFFFFE306),
    // this.child,
  }) : super(key: key);

  // final Color color;
  // final Widget? child;

  @override
  SearchResultState createState() => new SearchResultState();
}

class SearchResultState extends State<SearchResult> {
  double _size = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('search result'),
      ),
      body: Text('〜〜の検索結果'),
    );
  }
}

///ここからカード形式で表示するテスト
// class ShowCards extends StatefulWidget {
//   @override
//   ShowCardsState createState() => ShowCardsState();
// }
//
// class ShowCardsState extends State<ShowCards> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         height: 420,
//         child: ListView(
//           children: [
//             Card(
//               child: SizedBox(
//                 width: 300,
//                 height: 200,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text('10月10日　'),
//                         Text('日経平均終値：30,200円'),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Text('タグ1'),
//                         Text('タグ2'),
//                         Text('タグ3'),
//                       ],
//                     ),
//                     ImportantContent(),
//                   ],
//                 ),
//               ),
//             ),
//             Card(
//               child: SizedBox(
//                 width: 300,
//                 height: 200,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text('10月9日　'),
//                         Text('日経平均終値：30,000円'),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Text('タグ1'),
//                         Text('タグ2'),
//                         Text('タグ3'),
//                       ],
//                     ),
//                     ImportantContent2(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//リストの作成は、recordの中に本日の日付と一致するものがあれば作成する？
//ImportantContentはメモがある場合とない場合で場合わけする。

// class ImportantContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       //onTap: ここにTapしたらDaily recordに画面遷移する（タップしたカードの日付を渡す）
//       child: Container(
//         width: 400,
//         child: SimpleUrlPreview(
//           url:
//           //ここにもっとも滞在時間が長いURLが表示される
//           //日付と開始時刻、終了時刻でフィルターをかけたURLを表示する
//           'https://www.bloomberg.co.jp/news/articles/2021-10-01/R0B7KODWRGG301?srnd=cojp-v2',
//           bgColor: Colors.white,
//           titleLines: 1,
//           descriptionLines: 2,
//           imageLoaderColor: Colors.white,
//           previewHeight: 150,
//           previewContainerPadding: EdgeInsets.all(5),
//           onTap: () {
//             Get.to(SearchResult());
//           },
//           titleStyle: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//           descriptionStyle: TextStyle(
//             fontSize: 14,
//             color: Colors.black,
//           ),
//           siteNameStyle: TextStyle(
//             fontSize: 14,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
///擬似的にメモがある場合を再現
// class ImportantContent2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 400,
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 2.0),
//           child: SizedBox(
//             width: 270,
//             height: 140,
//             child: Text(
//               //ここに日付でフィルターをかけたメモの内容が表示される
//               //recordsに保存した日付とメモの組み合わせから取得
//                 'メモの内容が入ります'),
//           ),
//         ),
//       ),
//     );
//   }
// }
