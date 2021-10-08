import 'dart:async';
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

///Webの中身だけ表示するページ
class WebContentPage extends StatelessWidget {
  final tvc = Get.put(TabViewController());
  final wc = Get.put(WebController());
  final tags = [];

  ///WebViewControllerはサイトのタイトル取得に必要。
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  WebContentPage({Key? key}) : super(key: key);

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
        ///登録するデータ（url,dayを準備）
        final DateTime now = DateTime.now(); //現在時刻を取得（DateTime型）
        DateFormat outputFormatDay =
            DateFormat('yyyy-MM-dd'); //DateTime→Stringへの変換方法を記載
        String day = outputFormatDay.format(now);

        ///一回一回の履歴に対してインスタンスを作成する
        Record tmpRecord = Record(url: url, day: day, startTime: now);
        wc.records.add(tmpRecord);

        ///wc.recordsを監視し、変更（新しいURLの追加）のタイミングで
        ///wc.recordsのオブジェクト配列の最後から二番目の'endTime'にendTimeを代入する処理を書く
        ///endTimeが空かつrecordのURLが異なる場合に
        ever(
          wc.records,
          (_) {
            var endTime = DateTime.now();
            wc.records[wc.records.length - 2].endTime = endTime;
          },
        );
      },

      ///ここの処理が不安、、、URLはrecordsの最後に追加でいいのか？
      ///ページの読み込みが終わった段階で、URLのタイトルを取得
      onPageFinished: (String url) async {
        final controller = await _controller.future;
        final title = await controller.getTitle();
        wc.records.last.newsTitle = title;

        ///boxにrecordsを保存する処理を記載
        void saveUrl() async {
          await Hive.openBox('recordsGeneratedByUrl');
          final box = await Hive.openBox('recordsGeneratedByUrl');

          box.put('records', jsonEncode(wc.records));
        }

        ///関数を実行してboxに保存する処理
        saveUrl();
      },
    );
  }
}
