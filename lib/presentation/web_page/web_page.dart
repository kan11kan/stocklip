import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/domain/record_class.dart';
import 'package:one_app_everyday921/presentation/daily_page/daily_controller.dart';
import 'package:one_app_everyday921/presentation/web_page/web_controller.dart';
//ここからWebPageのURLを保存するモデル（コントローラーを記載）

import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';

///Webの中身だけ表示するページ
class WebContentPage extends StatelessWidget {
  final tvc = Get.put(TabViewController());
  final wc = Get.put(WebController());
  final dc = Get.put(DailyDataController());
  final tags = [];

  ///WebViewControllerはサイトのタイトル取得に必要。
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WebView(
      // javascriptMode: JavascriptMode.unrestricted,
      // onWebViewCreated: (WebViewController webViewController) {
      //   _controller.complete(webViewController);
      // },

      ///Webviewが作られたときの処理
      onWebViewCreated: _controller.complete,

      initialUrl: tvc.selectedUrl.value.toString(),

      ///ページの読み込み開始時の処理
      onPageStarted: (url) {
        // Future<String> getUrlTitle(url) async {
        //   final controller = await _controller.future;
        //   final newsTitle = await controller.getTitle();
        //   return newsTitle!;
        // }

        // final newsTitle = _controller.getTitle();

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
          wc.records[wc.records.length - 2].endTime = endTime;
        });

        ///ここにデイリーデータの保存について記載
        ///boxにputすると動かなくなる。boxそのものがnullかどうかではなく
        /// 型の変換でエラーをはいているような気がする
        // void saveDailyData() async {
        //   final box = await Hive.openBox('mostImportantUrl');
        //   // final DateTime now = DateTime.now();
        //   // DateFormat outputFormatDay =
        //   // DateFormat('yyyy-MM-dd');
        //   // String day = outputFormatDay.format(now);
        //
        //   ///一旦全てのメモ（更新は配列の最後から取得）を保存する記載（残す）
        //   Daily dailyTmpRecord =
        //       Daily(memo: dc.memoContent.value, day: day, allUrls: url);
        //   dc.dailyRecords.add(dailyTmpRecord);
        //   box.put('mostImportantUrl', jsonEncode(dc.dailyRecords));
        // }
        //
        // saveDailyData();

        ///確認用
        // void confirmDailyBox() async {
        //   final box = await Hive.openBox('mostImportantUrl');
        //   print('${box.get("mostImportantUrl")}');
        // }

        // confirmDailyBox();
      },
      onPageFinished: (String url) async {
        // ページタイトル取得
        final controller = await _controller.future;
        final title = await controller.getTitle();
        wc.records.last.newsTitle = title;

        ///boxにrecordsを保存する処理を記載
        void saveUrl() async {
          await Hive.openBox('recordsGeneratedByUrl');
          final box = await Hive.openBox('recordsGeneratedByUrl');

          box.put('records', jsonEncode(wc.records));
          // print('${box.get('records')}');
        }

        ///関数を実行してboxに保存する処理
        saveUrl();
      },

      // },
    );
  }
}

//DailyDataのインスタンスの有無を確認→なければURLを取得したタイミングでDailyDataを作成
//メモを書く時にDailyDataのインスタンスがなければ作成する。
