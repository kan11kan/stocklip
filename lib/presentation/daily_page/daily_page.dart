import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/domain/record_class.dart';
import 'package:one_app_everyday921/presentation/web_page/web_controller.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

import '../../main_button_widget.dart';

///解消すべき問題
///タグによる優先順位づけ
///並び替えのエラー

///Daily Newsの内容を記載
class DailyPage extends StatelessWidget {
  final wc = Get.put(WebController());
  final muc = Get.put(MainUrlsController());

  ///しんじさんのコード
  ///Recordクラスのオブジェクト配列の変化を監視
  RxList<Record> urls = <Record>[].obs;

  ///getUrls()を定義　=> 'recordsGeneratedByUrl'ボックスからkey='records'を取得
  ///空のurlsにboxから取得した値を全て入れ直している
  void getUrls() async {
    final box = await Hive.openBox('recordsGeneratedByUrl');

    ///ここで空の配列に入れ直している。
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

  @override
  Widget build(BuildContext context) {
    ///Recordクラスの全てのrecordsを取得し、url,day,hideをurlsに格納。
    getUrls();
    // var myController = TextEditingController();
    var tmpMemo = ''.obs;

    ///処理が走った日付（String）と時刻（DateTime）を取得
    final now = DateTime.now();
    DateFormat outputFormatDay = DateFormat('yyyy-MM-dd');
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

    ///itemsを作成し、インデックスを管理
    final tmpList = List<int>.generate(todayUrls.length, (int index) => index);

    if (muc.items.isEmpty) {
      muc.items.value = tmpList;
    } else {
      tmpList.asMap().forEach((el, idx) =>
          idx >= muc.items.length ? muc.items.add(el) : print('stay'));
      // for (int i = 0; i < tmpList.length; i++) {
      //   if (i > muc.items.length) {
      //     muc.items.add(tmpList[i]);
      //   }
      // }
    }

    ///ここからページ内容
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SizedBox(
              height: 30,
              child: Text('$todayの履歴'),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 320,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0, left: 16.0),
                  child: TextField(
                    onChanged: (text) {
                      tmpMemo.value = text;
                    },
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  ///クリックでメモ内容を'recordsGeneratedByUrl'の'records'に保存する
                  ///url=''、day='String'で保存する。
                  void saveDailyData() async {
                    final box = await Hive.openBox('recordsGeneratedByUrl');
                    final DateTime now = DateTime.now();
                    DateFormat outputFormatDay = DateFormat('yyyy-MM-dd');
                    String day = outputFormatDay.format(now);

                    var memo = '';
                    ever(tmpMemo, (String tmpMemo2) {
                      memo = tmpMemo2;
                    });

                    ///Recordクラスのインスタンスを作成

                    Record dailyTmpRecord =
                        Record(memo: memo, day: day, url: '');
                    wc.records.add(dailyTmpRecord);

                    ///boxにput
                    box.put('records', jsonEncode(wc.records));
                  }

                  saveDailyData();

                  ///テキストフィールド初期化
                  tmpMemo.value = '';
                },
                child: const Text(
                  '保\n' '存',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(5, 95),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: muc.items.isEmpty
                ? const Text('今日の履歴はありません')
                : SizedBox(
                    height: 500,
                    child: muc.items.isEmpty
                        ? const Text('今日の履歴はありません')
                        : GestureDetector(
                            onLongPress: () {},
                            child: Obx(
                              () => ReorderableListView(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  for (int index = 0;
                                      index < todayUrls.length;
                                      index++)
                                    Slidable(
                                      key: Key('$index'),
                                      actionPane:
                                          const SlidableDrawerActionPane(),
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
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 30),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                              child: const Text(
                                                                  '金利'),
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Colors
                                                                    .white,
                                                                onPrimary:
                                                                    Colors
                                                                        .black,
                                                                shape:
                                                                    const StadiumBorder(),
                                                              ),
                                                              onPressed: () {
                                                                //ここにタグの表示非表示切り替え処理を書く
                                                              },
                                                            ),
                                                            ElevatedButton(
                                                              child: const Text(
                                                                  '日経平均'),
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Colors
                                                                    .white,
                                                                onPrimary:
                                                                    Colors
                                                                        .black,
                                                                shape:
                                                                    const StadiumBorder(),
                                                              ),
                                                              onPressed: () {},
                                                            ),
                                                            ElevatedButton(
                                                              child: const Text(
                                                                  '米国株'),
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Colors
                                                                    .white,
                                                                onPrimary:
                                                                    Colors
                                                                        .black,
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
                                                          child: const Text(
                                                              'Close BottomSheet'),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
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
                                          child: Obx(() => Row(
                                                children: [
                                                  Container(
                                                    width: 345,
                                                    // ----------------------- SimpleUrlPreview -----------------------
                                                    child: SimpleUrlPreview(
                                                      url: todayUrls[
                                                              muc.items[index]]
                                                          .url,
                                                      bgColor: Colors.white,
                                                      titleLines: 1,
                                                      descriptionLines: 2,
                                                      imageLoaderColor:
                                                          Colors.white,
                                                      previewHeight: 150,
                                                      previewContainerPadding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      onTap: () {
                                                        // Get.to(WebContentPage());
                                                      },
                                                      titleStyle:
                                                          const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                      descriptionStyle:
                                                          const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                      siteNameStyle:
                                                          const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  ReorderableDragStartListener(
                                                    index: muc.items[index],
                                                    child: const Icon(
                                                        Icons.drag_handle),
                                                  ),
                                                ],
                                              )),
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
                                  print(
                                      ' --------------------- oldIndex:$oldIndex , newIndex:$newIndex --------------------- ');
                                  print(muc.items);
                                  print(
                                      '${todayUrls[muc.items[0]].url},\n ${todayUrls[muc.items[1]].url},\n${todayUrls[muc.items[2]].url},\n${todayUrls[muc.items[3]].url}');

                                  final int item =
                                      muc.items.removeAt(oldIndex); //試してみる

                                  print(muc.items);
                                  print(
                                      '${todayUrls[muc.items[0]].url},\n ${todayUrls[muc.items[1]].url},\n${todayUrls[muc.items[2]].url},\n${todayUrls[muc.items[3]].url}');
                                  // items.value = items..insert(newIndex, item);//元のコード
                                  // urls.value = urls
                                  //   ..insert(newIndex, urls[oldIndex]); //山村さんのコード
                                  muc.items.insert(newIndex, item); //自分のコード
                                  print(muc.items);
                                  print(
                                      '${todayUrls[muc.items[0]].url},\n ${todayUrls[muc.items[1]].url},\n${todayUrls[muc.items[2]].url},\n${todayUrls[muc.items[3]].url}');

                                  //ここがリストが入れ替わらないエラーの原因かも
                                },
                              ),
                            ),
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
