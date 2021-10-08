import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/domain/record_class.dart';
import 'package:one_app_everyday921/presentation/daily_page/daily_controller.dart';
import 'package:one_app_everyday921/presentation/web_page/web_controller.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

import 'archives_button_widget.dart';
import 'archives_controller.dart';

///検索が押されたら次のページ（SearchResult）に値を渡す処理を記　→Done
///（SearchResult）で()box（key=''）から日付が選択期間内にあるもの（ロジックを調べる）
///→配列作る方針で、、、
///URLのタイトル、とテキストが部分一致するものを取得
///（SearchResult）でsimpleURLpreviewで該当のURLを表示

///box管理
///box名：recordsGeneratedByUrl
///boxkey:records

final WebController wc = Get.find();

///アーカイブページ全体の記述
class ArchivesPage extends StatelessWidget {
  final skc = Get.put(SearchKeyController());
  final dc = Get.put(DailyDataController());
  final wc = Get.put(WebController());
  var searchKeywords = TextEditingController();
  RxList<Record> importantInfo = <Record>[].obs;
  @override

  ///box('mostImportantUrl')の(key='mostImportantUrl')を開いてdailyRecordに格納、監視
  void getRecords() async {
    final box = await Hive.openBox('recordsGeneratedByUrl');
    if (box.get('records') != null) {
      importantInfo.value = jsonDecode(box.get('records'))
          .map((el) => Record.fromJson(el))
          .toList()
          .cast<Record>() as List<Record>;
    }
  }

  ///※　build以下記載　※　メモがなければ日付配列[0]~[n]のmostImportantUrlを取得し、mostImportantInfoに格納
  ///この時、メモがあればメモを格納、なければURLを取得し格納する
  ///※保存ボタンを押した時に、dailyRecordsにurl='',memo='content'で保存
  ///※urlが更新された時に、dailyRecordsにurl='url',memo=''で保存している

  ///box('mostImportantUrl',key='importantUrl')を開く処理
  ///※※※※※※※　　　　dcは使わない方針に変更してロジック考えてみる　　※※※※※※※※
  ///※※※※※※※　　　　recordsにmemoを追加(dayとurlはある)　　　　　※※※※※※※※
  ///※※※※※※※　　　　dailyRecordへの記載を変更しないといけない、、　※※※※※※※※
  Widget build(BuildContext context) {
    getRecords();

    ///mostImportantUrlを取得する流れ
    ///重複なしの日付配列を作成
    var dateList = RxList(wc.records.map((el) => el.day).toSet().toList());

    ///dailyRecordsから日付でフィルターしてurlを取得

    for (int i = 0; i < dateList.length; i++) {
      var mostImoportantUrls = wc.records
          .where((el) =>
              el.day == dateList[i] &&
              el.url != null && //メモを入力した時はallurls==''
              el.memo != null)
          .toList()
        ..sort((a, b) => b.readTime.compareTo(a.readTime));
      var mostImportant = mostImoportantUrls[0];
      wc.mostImportantUrls.add(mostImportant);
    }

    // var todayUrls = RxList(wc.records
    //         .where((el) =>
    //             el.day == today &&
    //             el.hide == false &&
    //             el.url != 'https://www.bloomberg.co.jp/' &&
    //             el.url != 'https://finance.yahoo.co.jp/' &&
    //             el.url != 'https://nikkei225jp.com/cme' &&
    //             el.url != 'https://www.reuters.com/' &&
    //             el.url != '')
    //         .toList()
    //       ..sort((a, b) => b.readTime.compareTo(a.readTime)));

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
                          ///検索ボタン押下でフィールドをリセット
                          controller: searchKeywords,

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
                      // ///boxにdailyを保存できるかここで試す
                      // void putMostImportantUrl() async {
                      //   final box = await Hive.openBox('importantUrl');
                      //   box.put('importantUrl', jsonEncode(dc.dailyRecords));
                      // }
                      //
                      // DateTime yesterday =
                      //     DateTime.now().add(Duration(days: 1) * -1);
                      // DateFormat outputFormatDay = DateFormat('yyyy-MM-dd');
                      // String day = outputFormatDay.format(yesterday);
                      //
                      // Daily tmpDaily = Daily(
                      //     memo: 'test',
                      //     day: day, //日付が変わった1日前の履歴
                      //     allUrls:
                      //         'https://www.bloomberg.co.jp/news/articles/2021-10-06/R0KIVVT0AFB501?srnd=cojp-v2');
                      // dc.dailyRecords.add(tmpDaily);
                      //
                      // ///ここで1日に一回boxに保存
                      // putMostImportantUrl();

                      ///SearchResultに検索キーワード、検索期間を渡す
                      print('${skc.startDay.value}');
                      print('${skc.endDay.value}');
                      print(searchKeywords);
                      print('${"dc.dailyRecords"}');
                      searchKeywords.clear();

                      ///検索の開始と終了取得成功！！！
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

///表示する期間の状態管理
class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  final skc = Get.put(SearchKeyController());

  DateTimeRange dateRange = DateTimeRange(
      start: DateTime.now().add(Duration(days: 1) * -6), end: DateTime.now());

  ///ここで選択期間の開始の日付を取得！！！
  String getFrom() {
    if (dateRange == null) {
      return 'From';
    } else {
      skc.startDay.value = DateFormat('MM/dd/yyyy').format(dateRange.start);
      return skc.startDay.value;
    }
  }

  ///ここで選択期間の終了の日付を取得！！！
  String getUntil() {
    if (dateRange == null) {
      return 'Until';
    } else {
      skc.endDay.value = DateFormat('MM/dd/yyyy').format(dateRange.end);
      return skc.endDay.value;
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
                ///ここで開始の日付を表示！！！
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
                ///ここで終了の日付を表示！！！
                text: getUntil(),
                onClicked: () => pickDateRange(context),
              ),
            ),
          ],
        ),
      );

  ///ユーザーが実際に期間選択する画面
  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now().add(Duration(days: 1) * -6),
      end: DateTime.now(),
    );
    final newDateRange = await showDateRangePicker(
      ///showDateRangePickerはパッケージ
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
  final DailyDataController dc = Get.find();
  // final wc = Get.put(WebController());

  // ///DailyRecordクラスのオブジェクト配列の変化を監視
  // RxList<Daily> dailyRecords = <Daily>[].obs;
  //
  // ///box('mostImportantUrl')の(key='mostImportantUrl')を開いてdailyRecordに格納、監視
  // void getDailyRecords() async {
  //   final box = await Hive.openBox('mostImportantUrl');
  //   if (box.get('mostImportantUrl') != null) {
  //     dailyRecords.value = jsonDecode(box.get('mostImportantUrl'))
  //         .map((el) => Daily.fromJson(el))
  //         .toList()
  //         .cast<Daily>() as List<Daily>;
  //   }
  // }

  ///memo, 日付のオブジェクト配列から日付を取得（順番は古い順になっている？）
  ///日経平均終値と日付を({日付:日付,日経:日経})オブジェクト配列に格納（とりあえずマニュアルで）
  final List nikkei = [
    30000,
    29000,
    35000,
    399,
    333,
    444444,
    4442,
    2,
    3333,
    333,
    3333,
    22,
    4,
    4,
    5,
    5,
    6,
    6,
    7,
    78,
    8,
    86,
    5,
    43,
    3,
    2,
    2
  ];

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
    ///リストビュービルダー
    ///
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: wc.mostImportantUrls.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                            '${wc.mostImportantUrls[index].day}'), //('${dailyRecords[index].day}'),
                        // Text('${nikkei[index]}'),
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
                          child: wc.mostImportantUrls[index].memo == ''
                              ? Card(
                                  child: SimpleUrlPreview(
                                    url: wc.mostImportantUrls[index].url,
                                    bgColor: Colors.white,
                                    titleLines: 1,
                                    descriptionLines: 2,
                                    imageLoaderColor: Colors.white,
                                    previewHeight: 150,
                                    previewContainerPadding: EdgeInsets.all(5),
                                    onTap: () {
                                      // Get.to(WebContentPage());
                                    },
                                    titleStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    descriptionStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    siteNameStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : Card(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child: SizedBox(
                                      width: 270,
                                      height: 140,
                                      child: Text(
                                          '${wc.mostImportantUrls[index].memo}'),
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
  }) : super(key: key);

  ///開始日と終了日のDurationを取得？
  ///開始日＋差分　の日付配列を作成
  ///日付と一致するものをrecordsを取得
  ///キーワードと一致するものを表示

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
