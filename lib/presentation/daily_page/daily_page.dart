import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/domain/daily_class.dart';
import 'package:one_app_everyday921/domain/record_class.dart';
import 'package:one_app_everyday921/presentation/daily_page/daily_controller.dart';
import 'package:one_app_everyday921/presentation/web_page/web_controller.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

import '../../main_button_widget.dart';

String memoContent = '';

///Dailyの中身を記載
class DailyPage extends StatelessWidget {
  final wc = Get.put(WebController());
  final dc = Get.put(DailyDataController());
  final muc = Get.put(MainUrlsController());

  ///しんじさんのコード
  ///Recordクラスのオブジェクト配列の変化を監視
  RxList<Record> urls = <Record>[].obs;

  ///getUrls()を定義　=> 'recordsGeneratedByUrl'ボックスからkey='records'を取得
  ///空のurlsにboxから取得した値を全て入れ直している
  void getUrls() async {
    await Hive.openBox('recordsGeneratedByUrl');
    final box = await Hive.openBox('recordsGeneratedByUrl');
    urls.value = jsonDecode(box.get('records'))
        .map((el) => Record.fromJson(el))
        .toList()
        .cast<Record>() as List<Record>;
    // print(urls.value[0].url);
    // print(urls.value[1].url);
    // print(urls.value[2].url);
    // print(urls.value[3].url);
    // print(urls.value.length);
    // final list = [];
  }

  ///getXと同じ？？？
  var memoController = TextEditingController();

  ///（importantUrl）boxにDailyクラスのインスタンスを(key = 'importantUrl')保存するメソッドを定義（呼び出しは後で）
  void putMostImportantUrl() async {
    final box = await Hive.openBox('importantUrl');
    box.put('importantUrl', jsonEncode(dc.dailyRecords));
  }

  @override
  Widget build(BuildContext context) {
    ///ここでRecordクラスの全てのrecordsを取得し、url,day,hideをurlsに格納。
    getUrls();

    ///処理が走った日付（String）と時刻（DateTime）を取得
    final now = DateTime.now();
    DateFormat outputFormatDay = DateFormat('yyyy-MM-dd HH:mm');
    String today = outputFormatDay.format(now);

    ///urlsのうち、日付が一致するものをだけを抽出して変数に格納する。
    ///トップに記載しているURLは履歴から除外したい。（なぜかコントローラーから取得すると反映されないので直書き）
    ///今後は+タグの数×100min,星×1000とかで優先度をつける？？
    var todayUrls = RxList(wc.records
        .where((el) =>
            el.day == today &&
            el.hide == false &&
            el.url != 'https://www.bloomberg.co.jp/' &&
            el.url != 'https://finance.yahoo.co.jp/' &&
            el.url != 'https://nikkei225jp.com/cme' &&
            el.url != 'https://www.reuters.com/' &&
            el.url != '')
        .toList()
      ..sort((a, b) => b.readTime.compareTo(a.readTime)));

    // .toList().filter((e) => e == "https://finance.yahoo.co.jp/")
    // list.sort((a,b) => a.id.compareTo(b.id))

    ///ここからmostImportantUrlを取得する記述
    ///recordsから日付一致、hide=falseの配列を取得　→　滞在時間が長いもの順に並べる
    String mostImportantUrl = RxList(wc.records
            .where((el) => el.day == today && el.hide == false)
            .toList()
          ..sort((a, b) => a.readTime.compareTo(b.readTime)))[0]
        .url;

    ///managementDateの変更を監視し、日付が変わったタイミングでboxにdailyRecordsをプットする
    ///version①
    // RxString managementDate = outputFormatDay.format(now).obs;
    // ever(managementDate, (_) {
    //   var day = now.add(Duration(days: 1) * -1);
    //   dc.dailyRecords.last.mostImportantUrl = mostImportantUrl as String;
    //   dc.dailyRecords.last.day = day as String;

    ///managementDateの変更を監視、日付変更を検知し、ever以降の処理を走らせる。
    ///version②
    RxString observeDate = outputFormatDay.format(now).obs;
    ever(observeDate, (_) {
      ///メモは監視できているのか要確認。日付更新のタイミングでインスタンス作成→boxに保存
      String day = now.add(Duration(days: 1) * -1) as String;
      Daily tmpDaily = Daily(
          memo: memoController.text,
          day: day, //日付が変わった1日前の履歴
          mostImportantUrl: mostImportantUrl);
      dc.dailyRecords.add(tmpDaily);

      ///日付変更とともにメモフィールドを初期化
      memoController.text = '';

      ///ここで1日に一回boxに保存
      putMostImportantUrl();
    });

    ///itemsを作成し、インデックスを管理
    RxList items =
        List<int>.generate(todayUrls.length, (int index) => index).obs;

    ///ここからページ内容
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: items.length == 0
                ? Text('今日の履歴はありません')
                : Row(
                    children: [
                      SizedBox(
                        width: 320,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: TextField(
                            // onChanged: (string) {
                            //   memoContent = string;
                            ///コントローラーで管理してみる
                            controller: memoController,

                            // print(name);
                            // },
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white60,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ///ここにデータの保存について記載
                          // void saveDailyData() async {
                          //   final box = await Hive.openBox('recordsByDay');
                          //   final DateTime now = DateTime.now();
                          //   DateFormat outputFormatDay =
                          //       DateFormat('yyyy-MM-dd'); //DateTime→Stringへの変換方法を記載
                          //   String day = outputFormatDay.format(now);
                          ///一旦全てのメモ（更新は配列の最後から取得）を保存する記載（残す）
                          // Daily dailyTmpRecord = Daily(memo: memoContent, day: day);
                          // dc.dailyRecords.add(dailyTmpRecord);
                          // box.put('dailyRecords', jsonEncode(dc.dailyRecords));
                          // print('${box.get("dailyRecords")}');
                          // print(memos);
                          //saveDailyData();

                          ///確認用
                          void confirmDailyBox() async {
                            final box = await Hive.openBox('importantUrl');
                            print('${box.get("importantUrl")}');
                          }

                          confirmDailyBox();
                        },
                        child: Text(
                          '保\n' + '存',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(5, 95),
                        ),
                      )
                    ],
                  ),
          ),
          SizedBox(
            height: 500,
            child: items.length == 0
                ? Text('今日の履歴はありません')
                : GestureDetector(
                    onLongPress: () {},
                    child: Obx(
                      () => ReorderableListView(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          for (int index = 0; index < todayUrls.length; index++)
                            Slidable(
                              key: Key('$index'),
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: GestureDetector(
                                onLongPress: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 400,
                                        color: Colors.white,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 30),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      child: const Text('金利'),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.white,
                                                        onPrimary: Colors.black,
                                                        shape:
                                                            const StadiumBorder(),
                                                      ),
                                                      onPressed: () {
                                                        //ここにタグの表示非表示切り替え処理を書く
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text('日経平均'),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.white,
                                                        onPrimary: Colors.black,
                                                        shape:
                                                            const StadiumBorder(),
                                                      ),
                                                      onPressed: () {},
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text('米国株'),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.white,
                                                        onPrimary: Colors.black,
                                                        shape:
                                                            const StadiumBorder(),
                                                      ),
                                                      onPressed: () {},
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: ElevatedButton(
                                                  child:
                                                      Text('Close BottomSheet'),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 345,
                                        child: SimpleUrlPreview(
                                          url: todayUrls[index].url,
                                          bgColor: Colors.white,
                                          titleLines: 1,
                                          descriptionLines: 2,
                                          imageLoaderColor: Colors.white,
                                          previewHeight: 150,
                                          previewContainerPadding:
                                              EdgeInsets.all(5),
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
                                      ),
                                      ReorderableDragStartListener(
                                        index: index,
                                        child: const Icon(Icons.drag_handle),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {
                                    wc.records[index].hide = true;
                                    // setState(() {
                                    //   todayData[index].hide = true;
                                    // },
                                    // );
                                  },
                                ),
                              ],
                            ),
                        ],

                        //ここのエラーはsetstate()ができていないことが原因かも
                        onReorder: (int oldIndex, int newIndex) {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          // final int item = items.removeAt(oldIndex);//元のコード
                          // urls.value = urls..removeAt(oldIndex); //山村さんのコード
                          final int item = items.removeAt(oldIndex); //試してみる

                          // items.value = items..insert(newIndex, item);//元のコード
                          // urls.value = urls
                          //   ..insert(newIndex, urls[oldIndex]); //山村さんのコード
                          items.insert(newIndex, item); //自分のコード

                          //ここがリストが入れ替わらないエラーの原因かも
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
