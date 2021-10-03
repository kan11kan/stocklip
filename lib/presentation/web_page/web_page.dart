import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
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
  final day = ''; //仮で作成
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
    // getUrls();

    return WebView(
      initialUrl: tvc.selectedUrl.value.toString(),
      onPageStarted: (url) {
        final record = Record(url: url, day: day);
        wc.records.add(record);
        void saveUrl() async {
          await Hive.openBox('url');
          final box = await Hive.openBox('url');
          box.put('records', jsonEncode(wc.records));
          // print('${box.get('records')}');
        }

        saveUrl();
      },
    );
  }
}

//DailyDataのインスタンスの有無を確認→なければURLを取得したタイミングでDailyDataを作成
//メモを書く時にDailyDataのインスタンスがなければ作成する。
