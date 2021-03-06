import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/domain/record_class.dart';
import 'package:one_app_everyday921/presentation/web_page/web_controller.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

import '../../main.dart';
import 'archives_button_widget.dart';
import 'archives_controller.dart';

///対処すべき問題
///urlのtitleが空のとき、エラーが発生
///検索結果がきちんと出ているかわからない
///メモを保存したらメモのカード表示になるがメモの内容が出てこない
///Archivesを何度も開くと何回もカードが生成される

final WebController wc = Get.find();

///アーカイブページ全体の記述
class ArchivesPage extends StatefulWidget {
  const ArchivesPage({Key? key}) : super(key: key);

  @override
  State<ArchivesPage> createState() => _ArchivesPageState();
}

class _ArchivesPageState extends State<ArchivesPage> {
  final skc = Get.put(SearchKeyController());

  final wc = Get.put(WebController());

  var searchKeywords = TextEditingController();

  ///wc.recordsに変えてみる
  // RxList<Record> importantInfo = <Record>[].obs;

  ///box('recordsGeneratedByUrl')の(key='records')を開いてrecordsに格納、監視
  void getRecords() async {
    final box = await Hive.openBox('recordsGeneratedByUrl');
    if (box.get('records') != null) {
      wc.records.value = jsonDecode(box.get('records'))
          // importantInfo.value = jsonDecode(box.get('records'))
          .map((el) => Record.fromJson(el))
          .toList()
          .cast<Record>() as List<Record>;
    }
  }

  ///方針
  ///※　build以下記載　※　メモがなければ日付配列[0]~[n]のmostImportantUrlを取得し、mostImportantInfoに格納
  ///この時、メモがあればメモを格納、なければURLを取得し格納する
  ///※urlが更新された時に、dailyRecordsにurl='url',memo=''で保存している

  @override
  Widget build(BuildContext context) {
    ///recordsGeneratedByUrlボックス(key=records)を開く
    getRecords();

    ///mostImportantUrlを取得する流れ
    ///重複なしの日付配列を作成
    var dateList = RxList(wc.records.map((el) => el.day).toSet().toList());
    List<Record> importantInfoList = [];

    ///dailyRecordsから日付でフィルターしてurlを取得
    for (int i = 0; i < dateList.length; i++) {
      ///wc.recordsの値の中で日付一致　かつメモがない　かつ　URLがある　または
      ///日付一致　かつ　メモあり　かつ　URLなしのrecordsを取得して配列にいれる
      var mostImportantUrls = wc.records
          .where((el) =>
              (el.day == dateList[i] //&& el.memo == null
                  &&
                  el.url != '' &&
                  el.url != 'https://www.bloomberg.co.jp/' &&
                  el.url != 'https://www.traders.co.jp/' &&
                  el.url != 'https://finance.yahoo.co.jp/' &&
                  el.url != 'https://nikkei225jp.com/cme/' &&
                  el.url != 'https://www.jpx.co.jp/' &&
                  el.url != 'https://newspicks.com/' &&
                  el.url != 'https://www.reuters.com/' &&
                  el.url != 'https://www.nikkei.com/') ||
              (el.day == dateList[i] && el.memo != null && el.url == ''))
          .toList()

        ///そのなかでリードタイムが長い順に並び替える
        ..sort((a, b) => b.readTime.compareTo(a.readTime));

      ///→　もっともreadTimeが長いものを取得してmostImportantに格納
      var mostImportantRecord = mostImportantUrls[0];

      ///日付の存在する期間の数のrecordをmostImportantUrlsに格納
      importantInfoList.add(mostImportantRecord);
    }
    wc.mostImportantUrls = importantInfoList;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Column(
          children: [
            Card(
              shadowColor: Colors.black54,
              child: Column(
                children: [
                  const ShowCards(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.93,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              ///検索ボタン押下でフィールドをリセット
                              controller: searchKeywords,
                              textAlign: TextAlign.center,

                              decoration: InputDecoration(
                                hintText: 'search word',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const DateRangePickerWidget(),
                        ElevatedButton(
                          onPressed: () {
                            ///SearchResultに検索キーワード、検索期間を渡す
                            ///String　→　DateTimeへの変換処理
                            DateFormat outputFormatDay =
                                DateFormat('dd-MM-yyyy');
                            DateTime tmpStartTime =
                                outputFormatDay.parse(skc.startDay.value);
                            DateTime tmpEndTime =
                                outputFormatDay.parse(skc.endDay.value);
                            skc.searchKeywords.value = searchKeywords.text;

                            ///日付の差分を計算（型はint）
                            var duration =
                                tmpEndTime.difference(tmpStartTime).inDays;
                            skc.duration.value = duration;
                            searchKeywords.clear();

                            ///検索の開始と終了取得成功！！！
                            Get.to(const SearchResultTop());
                          },
                          child: const Text('検索'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///ここから日付の範囲を指定するWidget
class DateRangePickerWidget extends StatefulWidget {
  const DateRangePickerWidget({Key? key}) : super(key: key);

  @override
  _DateRangePickerWidgetState createState() => _DateRangePickerWidgetState();
}

///表示する期間の状態管理
class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  final skc = Get.put(SearchKeyController());

  DateTimeRange dateRange = DateTimeRange(
      start: DateTime.now().add(const Duration(days: 1) * -6),
      end: DateTime.now());

  ///ここで選択期間の開始の日付を取得！！！
  String getFrom() {
    skc.startDay.value = DateFormat('dd-MM-yyyy').format(dateRange.start);
    return skc.startDay.value;
  }

  ///ここで選択期間の終了の日付を取得！！！
  String getUntil() {
    skc.endDay.value = DateFormat('dd-MM-yyyy').format(dateRange.end);
    return skc.endDay.value;
  }

  @override
  Widget build(BuildContext context) => HeaderWidget(
        title: 'Date',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: ButtonWidget(
                ///ここで開始の日付を表示！！！
                text: getFrom(),
                onClicked: () => pickDateRange(context),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Colors.blueGrey),
            const SizedBox(width: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
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
      start: DateTime.now().add(const Duration(days: 1) * -6),
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
  const ShowCards({Key? key}) : super(key: key);
  @override
  ShowCardsState createState() => ShowCardsState();
}

class ShowCardsState extends State<ShowCards> {
  ///memo, 日付のオブジェクト配列から日付を取得（順番は古い順になっている？）
  ///日経平均終値と日付を({日付:日付,日経:日経})オブジェクト配列に格納（とりあえずマニュアルで）
  final List nikkei = [
    30000,
    29000,
    35000,
  ];

  ///tagsの配列を作成（タグ　→　◯月◯日のタグNumber[1,2,5,6]など）
  final List tags = [
    '金利',
    '債券',
    '米国株',
    '日本株',
    '中国株',
    'FRB',
    'テクニカル',
    'REIT',
    'その他'
  ];
  var selectedTagList = [];
  var selectedTagList1 = [];
  var selectedTagList2 = [];
  var selectedTagList3 = [];
  var selectedTagList4 = [];
  var selectedTagList5 = [];
  var selectedTagList6 = [];
  var selectedTagList7 = [];
  var selectedTagList8 = [];
  var selectedTagList9 = [];

  ///ここからリストビュー
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    for (int i = 0; i < wc.mostImportantUrls.length; i++) {
      int tmp = wc.records
          .where(
              (el) => el.day == wc.mostImportantUrls[i].day && el.tag == true)
          .toList()
          .length;
      tmp == 0 ? selectedTagList.add(false) : selectedTagList.add(true);
    }
    for (int i = 0; i < wc.mostImportantUrls.length; i++) {
      int tmp = wc.records
          .where(
              (el) => el.day == wc.mostImportantUrls[i].day && el.tag1 == true)
          .toList()
          .length;
      tmp == 0 ? selectedTagList1.add(false) : selectedTagList1.add(true);
    }
    for (int i = 0; i < wc.mostImportantUrls.length; i++) {
      int tmp = wc.records
          .where(
              (el) => el.day == wc.mostImportantUrls[i].day && el.tag2 == true)
          .toList()
          .length;
      tmp == 0 ? selectedTagList2.add(false) : selectedTagList2.add(true);
    }
    for (int i = 0; i < wc.mostImportantUrls.length; i++) {
      int tmp = wc.records
          .where(
              (el) => el.day == wc.mostImportantUrls[i].day && el.tag3 == true)
          .toList()
          .length;
      tmp == 0 ? selectedTagList3.add(false) : selectedTagList3.add(true);
    }
    for (int i = 0; i < wc.mostImportantUrls.length; i++) {
      int tmp = wc.records
          .where(
              (el) => el.day == wc.mostImportantUrls[i].day && el.tag4 == true)
          .toList()
          .length;
      tmp == 0 ? selectedTagList4.add(false) : selectedTagList4.add(true);
    }
    for (int i = 0; i < wc.mostImportantUrls.length; i++) {
      int tmp = wc.records
          .where(
              (el) => el.day == wc.mostImportantUrls[i].day && el.tag5 == true)
          .toList()
          .length;
      tmp == 0 ? selectedTagList5.add(false) : selectedTagList5.add(true);
    }
    for (int i = 0; i < wc.mostImportantUrls.length; i++) {
      int tmp = wc.records
          .where(
              (el) => el.day == wc.mostImportantUrls[i].day && el.tag6 == true)
          .toList()
          .length;
      tmp == 0 ? selectedTagList6.add(false) : selectedTagList6.add(true);
    }
    for (int i = 0; i < wc.mostImportantUrls.length; i++) {
      int tmp = wc.records
          .where(
              (el) => el.day == wc.mostImportantUrls[i].day && el.tag7 == true)
          .toList()
          .length;
      tmp == 0 ? selectedTagList7.add(false) : selectedTagList7.add(true);
    }
    for (int i = 0; i < wc.mostImportantUrls.length; i++) {
      int tmp = wc.records
          .where(
              (el) => el.day == wc.mostImportantUrls[i].day && el.tag8 == true)
          .toList()
          .length;
      tmp == 0 ? selectedTagList8.add(false) : selectedTagList8.add(true);
    }
    for (int i = 0; i < wc.mostImportantUrls.length; i++) {
      int tmp = wc.records
          .where(
              (el) => el.day == wc.mostImportantUrls[i].day && el.tag9 == true)
          .toList()
          .length;
      tmp == 0 ? selectedTagList9.add(false) : selectedTagList9.add(true);
    }

    ///リストビュービルダー
    return Container(
      height: MediaQuery.of(context).size.height * 0.54,
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: wc.mostImportantUrls.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    child: Card(
                      child: Column(
                        children: [
                          Text(
                            '${wc.mostImportantUrls[wc.mostImportantUrls.length - index - 1].day}',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ), //('${dailyRecords[index].day}'),
                          // Text('${nikkei[index]}'),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Visibility(
                                    visible: selectedTagList[
                                        wc.mostImportantUrls.length -
                                            index -
                                            1],
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(minWidth: 5),
                                      child: ElevatedButton(
                                        child: Text('${tags[0]}',
                                            style: TextStyle(fontSize: 12)),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blueAccent,
                                          onPrimary: Colors.white,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: selectedTagList1[
                                        wc.mostImportantUrls.length -
                                            index -
                                            1],
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(minWidth: 5),
                                      child: ElevatedButton(
                                        child: Text('${tags[1]}',
                                            style: TextStyle(fontSize: 12)),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blueAccent,
                                          onPrimary: Colors.white,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: selectedTagList2[
                                        wc.mostImportantUrls.length -
                                            index -
                                            1],
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(minWidth: 5),
                                      child: ElevatedButton(
                                        child: Text('${tags[2]}',
                                            style: TextStyle(fontSize: 12)),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blueAccent,
                                          onPrimary: Colors.white,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: selectedTagList3[
                                        wc.mostImportantUrls.length -
                                            index -
                                            1],
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(minWidth: 5),
                                      child: ElevatedButton(
                                        child: Text('${tags[3]}',
                                            style: TextStyle(fontSize: 12)),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blueAccent,
                                          onPrimary: Colors.white,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: selectedTagList4[
                                        wc.mostImportantUrls.length -
                                            index -
                                            1],
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(minWidth: 5),
                                      child: ElevatedButton(
                                        child: Text('${tags[4]}',
                                            style: TextStyle(fontSize: 12)),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blueAccent,
                                          onPrimary: Colors.white,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Visibility(
                              //       visible: selectedTagList5[index],
                              //       child: ConstrainedBox(
                              //         constraints: BoxConstraints(minWidth: 5),
                              //         child: ElevatedButton(
                              //           child: Text('${tags[5]}',
                              //               style: TextStyle(fontSize: 12)),
                              //           style: ElevatedButton.styleFrom(
                              //             primary: Colors.white,
                              //             onPrimary: Colors.black,
                              //             shape: const StadiumBorder(),
                              //           ),
                              //           onPressed: () {},
                              //         ),
                              //       ),
                              //     ),
                              //     Visibility(
                              //       visible: selectedTagList6[index],
                              //       child: ConstrainedBox(
                              //         constraints: BoxConstraints(minWidth: 5),
                              //         child: ElevatedButton(
                              //           child: Text('${tags[6]}',
                              //               style: TextStyle(fontSize: 12)),
                              //           style: ElevatedButton.styleFrom(
                              //             primary: Colors.white,
                              //             onPrimary: Colors.black,
                              //             shape: const StadiumBorder(),
                              //           ),
                              //           onPressed: () {},
                              //         ),
                              //       ),
                              //     ),
                              //     Visibility(
                              //       visible: selectedTagList7[index],
                              //       child: ConstrainedBox(
                              //         constraints: BoxConstraints(minWidth: 5),
                              //         child: ElevatedButton(
                              //           child: Text('${tags[7]}',
                              //               style: TextStyle(fontSize: 12)),
                              //           style: ElevatedButton.styleFrom(
                              //             primary: Colors.white,
                              //             onPrimary: Colors.black,
                              //             shape: const StadiumBorder(),
                              //           ),
                              //           onPressed: () {},
                              //         ),
                              //       ),
                              //     ),
                              //     Visibility(
                              //       visible: selectedTagList8[index],
                              //       child: ConstrainedBox(
                              //         constraints: BoxConstraints(minWidth: 5),
                              //         child: ElevatedButton(
                              //           child: Text('${tags[8]}',
                              //               style: TextStyle(fontSize: 12)),
                              //           style: ElevatedButton.styleFrom(
                              //             primary: Colors.white,
                              //             onPrimary: Colors.black,
                              //             shape: const StadiumBorder(),
                              //           ),
                              //           onPressed: () {},
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                          Container(
                            child: wc
                                        .mostImportantUrls[
                                            wc.mostImportantUrls.length -
                                                index -
                                                1]
                                        .url ==
                                    ''
                                ? Card(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 2.0),
                                      child: SizedBox(
                                        width: deviceWidth * 0.85,
                                        height: 150,
                                        child: Text(
                                          '${wc.mostImportantUrls[wc.mostImportantUrls.length - index - 1].memo}',
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    child: SimpleUrlPreview(
                                      url: wc
                                          .mostImportantUrls[
                                              wc.mostImportantUrls.length -
                                                  index -
                                                  1]
                                          .url,
                                      bgColor: Colors.white,
                                      titleLines: 1,
                                      descriptionLines: 2,
                                      imageLoaderColor: Colors.white,
                                      previewHeight: 150,
                                      previewContainerPadding:
                                          const EdgeInsets.all(5),
                                      onTap: () {},
                                      titleStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      descriptionStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      siteNameStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
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
            ],
          ),
        ),
      ),
    );
  }
}

///ここから検索結果のページ
class SearchResultTop extends StatefulWidget {
  const SearchResultTop({
    Key? key,
  }) : super(key: key);
  @override
  SearchResultTopState createState() => SearchResultTopState();
}

///Stateを記載
class SearchResultTopState extends State<SearchResultTop> {
  final skc = Get.put(SearchKeyController());
  final wc = Get.put(WebController());
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    ///⓪検索結果を表示するページを記載
    ///①startDayをDateTime型に変換
    DateFormat outputFormatDay = DateFormat('dd-MM-yyyy');
    DateTime startDateTime = outputFormatDay.parse(skc.startDay.value);
    // print(startDateTime);

    ///②開始日と終了日のDurationを取得（int型）
    ///③開始日＋差分　の日付配列(DateTime型)を作成
    // final List researchDateArray = [skc.startDay];
    final List<DateTime> researchDateArray = [];
    for (int i = 0; i < skc.duration.value + 1; i++) {
      DateTime tmp = startDateTime.add((Duration(days: 1) * i));
      // outputFormatDay.format(startDateTime.add((Duration(days: 1) * i)));
      researchDateArray.add(tmp);
    }

    final searchResultArray =
        [].map((e) => e.url).toSet().toList(); //これは<Record>型

    //検索元はyyyy-MM-dd
    ///④日付と一致するものをrecordsから取得
    for (int i = 1; i < researchDateArray.length; i++) {
      var tmpMonth = '';
      var tmpDay = '';
      researchDateArray[i].month > 9
          ? tmpMonth = '${researchDateArray[i].month}'
          : tmpMonth = '0${researchDateArray[i].month}';
      researchDateArray[i].day > 9
          ? tmpDay = '${researchDateArray[i].day}'
          : tmpDay = '0${researchDateArray[i].day}';
      var tmpStringDay = '${researchDateArray[i].year}-${tmpMonth}-${tmpDay}';
      print(tmpStringDay);
      wc.records
          .where(
            (el) =>
                el.day == tmpStringDay &&
                el.hide == false &&
                el.url != '' &&
                searchResultArray.map((x) => x.url).contains(el.url) == false &&
                el.newsTitle!.contains('${skc.searchKeywords}'),
          )
          // // .toList()
          .forEach((el) => searchResultArray.contains(el)
              ? print(el)
              : searchResultArray.add(el));
      // print(tmpStringDay);
    }
    // var finalSearchResultArray = searchResultArray.toSet().toList();

    ///⑤キーワードと一致するものを表示
    final tvc = Get.put(TabViewController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('search result'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 15, top: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '検索期間：${skc.startDay}~${skc.endDay}',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '検索ワード:${skc.searchKeywords}',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: deviceWidth * 0.9,
                child: Column(
                  children: [
                    searchResultArray.isEmpty
                        ? const Text('該当する履歴がありません',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 20))
                        : const Visibility(visible: false, child: Text('')),
                    for (int index = 1;
                        index < searchResultArray.length + 1;
                        index++)
                      Container(
                        child: GestureDetector(
                          onDoubleTap: () {
                            tvc.selectedTabIndex.value = 3;
                            tvc.selectedUrl.value =
                                searchResultArray[index - 1].url;
                            Get.to(MyHomePage());
                          },
                          child: SimpleUrlPreview(
                            url: searchResultArray[index - 1].url,
                            bgColor: Colors.white,
                            titleLines: 1,
                            descriptionLines: 2,
                            imageLoaderColor: Colors.white,
                            previewHeight: 150,
                            previewContainerPadding: const EdgeInsets.all(5),
                            onTap: () {
                              // Get.to(WebContentPage());
                            },
                            titleStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            descriptionStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            siteNameStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
