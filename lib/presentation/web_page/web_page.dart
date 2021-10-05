import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/domain/record.dart';
//ここからWebPageのURLを保存するモデル（コントローラーを記載）

import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';

class WebController extends GetxController {
  final RxList<Record> records = <Record>[].obs;
  List<String> todayUrls = <String>[];
}

//Webの中身だけ表示するページ
class WebContentPage extends StatelessWidget {
  final tvc = Get.put(TabViewController());
  final wc = Get.put(WebController());
  final tags = [];

  // void getUrls() async {
  //   await Hive.openBox('url');
  //   final box = await Hive.openBox('url');
  //   wc.records.value = jsonDecode(box.get('records'))
  //       .map((el) => Record.fromJson(el))
  //       .toList()
  //       .cast<Record>() as List<Record>;
  // }

  @override
  Widget build(BuildContext context) {
    //ここで現在の年月日について取得。
    final DateTime now = DateTime.now(); //現在時刻を取得（DateTime型）
    //DateTime→Stringへの変換方法を記載
    DateFormat outputFormatDay = DateFormat('yyyy-MM-dd');
    String day = outputFormatDay.format(now);
    //同じく時間について変換定義（まだ使ってない）
    // DateFormat outputFormatTime = DateFormat('yyyy-MM-dd-Hm');
    // String time = outputFormatTime.format(now);

    return WebView(
        initialUrl: tvc.selectedUrl.value.toString(),
        onPageStarted: (url) {
          final record = Record(url: url, day: day);
          wc.records.add(record);
          void saveUrl() async {
            await Hive.openBox('recordsGeneratedByUrl');
            final box = await Hive.openBox('recordsGeneratedByUrl');
            box.put('records', jsonEncode(wc.records));
            // print('${box.get('records')}');
          }

          saveUrl();
        });
  }
}

//DailyDataのインスタンスの有無を確認→なければURLを取得したタイミングでDailyDataを作成
//メモを書く時にDailyDataのインスタンスがなければ作成する。
