import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/domain/record_class.dart';
import 'package:one_app_everyday921/main.dart';
import 'package:one_app_everyday921/presentation/daily_page/daily_controller.dart';
import 'package:one_app_everyday921/presentation/web_page/web_controller.dart';
import 'package:one_app_everyday921/presentation/web_page/web_page.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

import '../../main_button_widget.dart';

///解消すべき問題
///タグによる優先順位づけ
///並び替えのエラー

///Daily Newsの内容を記載

class DailyPage extends StatefulWidget {
  DailyPage({Key? key}) : super(key: key);
  @override
  State<DailyPage> createState() => _DailyPageState();
  TextEditingController memoContent = TextEditingController();
}

class _DailyPageState extends State<DailyPage> {
  final wc = Get.put(WebController());
  final muc = Get.put(MainUrlsController());
  final dc = Get.put(DailyDataController());
  final tvc = Get.put(TabViewController());

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
    ///test
    final double deviceWidth = MediaQuery.of(context).size.width;

    ///Recordクラスの全てのrecordsを取得し、url,day,hideをurlsに格納。
    getUrls();

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
            el.url != 'https://www.jpx.co.jp/' &&
            el.url != 'https://newspicks.com/' &&
            el.url != 'https://www.reuters.com/' &&
            el.url != 'https://www.nikkei.com/' &&
            !el.url.contains('https://www.google.com/') &&
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: SizedBox(
                height: 20,
                child: Text(
                  'Browsed in $today',
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: //muc.items.isEmpty
                  // ? const Text('今日の履歴はありません')
                  SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: muc.items.isEmpty
                    ? const Center(child: Text('今日の履歴はありません'))
                    : Obx(
                        () => ReorderableListView(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            for (int index = 0;
                                index < todayUrls.length;
                                index++)
                              Slidable(
                                key: Key('$index'),
                                actionPane: const SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: GestureDetector(
                                  onDoubleTap: () {
                                    tvc.selectedTabIndex.value = 3;
                                    tvc.selectedUrl.value =
                                        todayUrls[muc.items[index]].url;
                                    WebContentPage();
                                  },
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    child: Obx(() => Row(
                                          children: [
                                            Container(
                                              width: deviceWidth * 0.85,
                                              // ----------------------- SimpleUrlPreview -----------------------
                                              child: SimpleUrlPreview(
                                                url: todayUrls[muc.items[index]]
                                                    .url,
                                                bgColor: Colors.white,
                                                titleLines: 1,
                                                descriptionLines: 2,
                                                imageLoaderColor: Colors.white,
                                                previewHeight: 150,
                                                previewContainerPadding:
                                                    const EdgeInsets.all(5),
                                                onTap: () {
                                                  // Get.to(WebContentPage());
                                                },
                                                titleStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                descriptionStyle:
                                                    const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                                siteNameStyle: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            ReorderableDragStartListener(
                                              index: muc.items[index],
                                              child:
                                                  const Icon(Icons.drag_handle),
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
                            // print(
                            //     ' --------------------- oldIndex:$oldIndex , newIndex:$newIndex --------------------- ');
                            // print(muc.items);
                            // print(
                            //     '${todayUrls[muc.items[0]].url},\n ${todayUrls[muc.items[1]].url},\n${todayUrls[muc.items[2]].url},\n${todayUrls[muc.items[3]].url}');

                            final int item =
                                muc.items.removeAt(oldIndex); //試してみる

                            // print(muc.items);
                            // print(
                            //     '${todayUrls[muc.items[0]].url},\n ${todayUrls[muc.items[1]].url},\n${todayUrls[muc.items[2]].url},\n${todayUrls[muc.items[3]].url}');
                            // items.value = items..insert(newIndex, item);//元のコード
                            // urls.value = urls
                            //   ..insert(newIndex, urls[oldIndex]); //山村さんのコード
                            muc.items.insert(newIndex, item); //自分のコード
                            // print(muc.items);
                            // print(
                            //     '${todayUrls[muc.items[0]].url},\n ${todayUrls[muc.items[1]].url},\n${todayUrls[muc.items[2]].url},\n${todayUrls[muc.items[3]].url}');

                            //ここがリストが入れ替わらないエラーの原因かも
                          },
                        ),
                      ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: deviceWidth * 0.85,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.0, left: 18.0),
                    child: TextField(
                      controller: widget.memoContent,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white60,
                        hintText: 'Fill in your notes of the day !',
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

                    dc.memoContent.value = widget.memoContent.text;
                    void saveDailyData() async {
                      final box = await Hive.openBox('recordsGeneratedByUrl');
                      final DateTime now = DateTime.now();
                      DateFormat outputFormatDay = DateFormat('yyyy-MM-dd');
                      String day = outputFormatDay.format(now);

                      ///Recordクラスのインスタンスを作成

                      Record dailyTmpRecord = Record(
                          memo: dc.memoContent.value,
                          day: day,
                          url: '',
                          startTime: now,
                          endTime: now.add((Duration(days: 1) * 10)));
                      wc.records.add(dailyTmpRecord);

                      ///boxにput
                      box.put('records', jsonEncode(wc.records));

                      ///unFocus
                      FocusScope.of(context).unfocus();

                      Fluttertoast.showToast(
                        msg: "メモを保存しました",
                        toastLength: Toast.LENGTH_SHORT,
                        // gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.grey[300]!.withOpacity(0.8),
                        textColor: Colors.black87,
                        // fontSize: 16.0
                      );
                    }

                    saveDailyData();

                    ///テキストフィールド初期化　→保存しましたへ今後変更
                    // widget.memoContent.clear();
                  },
                  child: const Text(
                    '保\n' '存',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(4, 95),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
