import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/domain/record_class.dart';
import 'package:one_app_everyday921/presentation/web_page/web_controller.dart';
//ここからWebPageのURLを保存するモデル（コントローラーを記載）

import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';

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
    return WebView(
      initialUrl: tvc.selectedUrl.value.toString(),
      onPageStarted: (url) {
        ///登録するデータ（url,dayを準備）
        final DateTime now = DateTime.now(); //現在時刻を取得（DateTime型）
        DateFormat outputFormatDay =
            DateFormat('yyyy-MM-dd'); //DateTime→Stringへの変換方法を記載
        String day = outputFormatDay.format(now);

        ///一回一回の履歴に対してインスタンスを作成する
        Record tmpRecord = Record(url: url, day: day, startTime: now);
        wc.records.add(tmpRecord);

        ///wc.recordsを監視し、変更（新しいURLの追加）のタイミングで
        ///wc.recordsのオブジェクト配列の最後の'endTime'にendTimeを代入する処理を書く
        ///endTimeが空かつrecordのURLが異なる場合に
        ever(wc.records, (_) {
          var endTime = DateTime.now();
          wc.records.last.endTime = endTime;
        });

        ///boxに保存する処理を記載
        void saveUrl() async {
          await Hive.openBox('recordsGeneratedByUrl');
          final box = await Hive.openBox('recordsGeneratedByUrl');

          box.put('records', jsonEncode(wc.records));
          // print('${box.get('records')}');
        }

        ///関数を実行して保存する処理
        saveUrl();
      },

      // },
    );
  }
}

//DailyDataのインスタンスの有無を確認→なければURLを取得したタイミングでDailyDataを作成
//メモを書く時にDailyDataのインスタンスがなければ作成する。
