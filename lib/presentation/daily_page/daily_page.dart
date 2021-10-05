import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/domain/record.dart';
import 'package:one_app_everyday921/presentation/web_page/web_page.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

String memoContent = '';

class DailyPage extends StatelessWidget {
  //DailyDataを保存してみる
  // RxList<DailyData> memo = <DailyData>[].obs;
  // void getDailyData() async {
  //   await Hive.openBox('dailydata');
  //   final box2 = await Hive.openBox('dailydata');
  //   memo.value = jsonDecode(box2.get('memo'))
  //       .map((el) => DailyData.fromJson(el))
  //       .toList()
  //       .cast<DailyData>() as List<DailyData>;
  // }

  //しんじさんのコード
  RxList<Record> urls = <Record>[].obs;
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

  final wc = Get.put(WebController());
  @override
  Widget build(BuildContext context) {
    //ここでboxに格納された全てのrecordsを取得し、url,day,hideを取得しurlsに格納。
    getUrls();

    //urlsの中からdayが本日の日付と一致するものを取得し、一致したものを変数todayDataに格納する
    final now = DateTime.now();
    DateFormat outputFormatDay = DateFormat('yyyy-MM-dd');
    String today = outputFormatDay.format(now);

    //urlsのうち、日付が一致するものをだけを抽出して変数に格納する。
    var todayUrls = wc.records.where((el) => el.hide == false).toList().obs;
    //トップに記載しているURLは履歴から除外したい
    // .toList().filter((e) => e == "https://finance.yahoo.co.jp/")

    RxList items =
        List<int>.generate(todayUrls.length, (int index) => index).obs;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 320,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: TextField(
                      onChanged: (string) {
                        memoContent = string;
                        // print(name);
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
                    //ここにデータの保存について記載
                    // void saveDailyData() async {
                    //   await Hive.openBox('dailydata');
                    //   final box = await Hive.openBox('dailydata');
                    //   box.put('data', memoContent);
                    //   print('${box.get('data').toString()}');
                    // }
                    // saveDailyData();
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
            child: GestureDetector(
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
                                          padding: EdgeInsets.only(bottom: 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                child: const Text('金利'),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary: Colors.black,
                                                  shape: const StadiumBorder(),
                                                ),
                                                onPressed: () {
                                                  //ここにタグの表示非表示切り替え処理を書く
                                                },
                                              ),
                                              ElevatedButton(
                                                child: const Text('日経平均'),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary: Colors.black,
                                                  shape: const StadiumBorder(),
                                                ),
                                                onPressed: () {},
                                              ),
                                              ElevatedButton(
                                                child: const Text('米国株'),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary: Colors.black,
                                                  shape: const StadiumBorder(),
                                                ),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: ElevatedButton(
                                            child: Text('Close BottomSheet'),
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
