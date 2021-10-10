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
    // print('///////////////////////////////////////////////////////////////////////////\n/////---------------------${tvc.selectedUrl.value}---------------------/////\n///////////////////////////////////////////////////////////////////////////');
    return WebView(
      // javascriptMode: JavascriptMode.unrestricted,
      // onWebViewCreated: (WebViewController webViewController) {
      //   _controller.complete(webViewController);
      // },

      ///Webviewが作られたときの処理
      // onWebViewCreated: controller.complete,

      initialUrl: tvc.selectedUrl.value,

// 2回目以降の表示でエラーが出るのはcontroller が怪しい。
// E/eglCodecCommon(23366): glUtilsParamSize: unknow param 0x000088ef
// I/chatty  (23366): uid=10146(com.example.one_app_everyday921) Chrome_InProcGp identical 2 lines
// E/eglCodecCommon(23366): glUtilsParamSize: unknow param 0x000088ef
// E/flutter (23366): [ERROR:flutter/lib/ui/ui_dart_state.cc(209)] Unhandled Exception: Bad state: Future already completed

// hotreloadでは以下の記述
// The following LateError was thrown during paint():
// LateInitializationError: Field '_currentAndroidViewSize@427508051' has not been initialized.

// エラー回避のために追記
      onWebViewCreated: (controller) {
            _controller = controller;
      },
      ///ページの読み込み開始時の処理
      onPageStarted: (url) {
        print('---------------------onPageStarted---------------------');
        // print(url);

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
        print('---------------------onPageFinished---------------------');

        final title = await _controller.getTitle();
        wc.records.last.newsTitle = title;

// ここでもエラー起きてるくさい
// [ERROR:flutter/lib/ui/ui_dart_state.cc(209)] Unhandled Exception: MissingPluginException(No implementation found for method getTitle on channel plugins.flutter.io/webview_15)
// ERROR:page_load_metrics_update_dispatcher.cc(170)] Invalid first_paint 0.275 s for first_image_paint 0.242 s

        print('---------------------onPageFinished gotTitle maybe... ---------------------');

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
