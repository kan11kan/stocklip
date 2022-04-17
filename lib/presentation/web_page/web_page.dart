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

class WebContentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WebContentPageState();
}

class WebContentPageState extends State<WebContentPage> {
//class WebContentPage extends StatelessWidget {
  final tvc = Get.put(TabViewController());
  final wc = Get.put(WebController());
  final tags = [];

  ///WebViewControllerはサイトのタイトル取得に必要。
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();

  // String decideURL() {
  //   if (tvc.selectedUrl == null) return 'https://www.google.com';
  //   return tvc.selectedUrl.value.toString();
  // }
  late WebViewController _controller;
  //WebContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
      // javascriptMode: JavascriptMode.unrestricted,
      // onWebViewCreated: (WebViewController webViewController) {
      //   _controller.complete(webViewController);
      // },

      ///Webviewが作られたときの処理
      // onWebViewCreated: controller.complete,

      initialUrl: tvc.selectedUrl.value,

// エラー回避のために追記
      onWebViewCreated: (controller) {
        _controller = controller;
      },

      ///ページの読み込み開始時の処理
      onPageStarted: (url) async {
        // print('---------------------onPageStarted---------------------');
        ever(
          wc.records,
          (_) {
            var endTime = DateTime.now();
            wc.records[wc.records.length - 2].endTime = endTime;
          },
        );
      },

      onPageFinished: (String url) async {
        // print('---------------------onPageFnished---------------------');
        ///boxにrecordsを保存するメソッド
        void saveUrl() async {
          await Hive.openBox('recordsGeneratedByUrl');
          final box = await Hive.openBox('recordsGeneratedByUrl');
          box.put('records', jsonEncode(wc.records));
        }

        ///登録するデータ（url, now, day, titleを準備）
        final DateTime now = DateTime.now(); //現在時刻を取得（DateTime型）
        final DateFormat outputFormatDay =
            DateFormat('yyyy-MM-dd'); //DateTime→Stringへの変換方法を記載
        final String day = outputFormatDay.format(now);
        final title = await _controller.getTitle();

        ///一回一回の履歴に対してインスタンスを作成する
        Record tmpRecord =
            Record(url: url, day: day, startTime: now, newsTitle: title);
        wc.records.add(tmpRecord);

        saveUrl();
      },
    );
  }
}
