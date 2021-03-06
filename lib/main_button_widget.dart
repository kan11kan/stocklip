import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:one_app_everyday921/presentation/web_page/web_controller.dart';
import 'package:one_app_everyday921/presentation/web_page/web_page.dart';

import 'main.dart';

///URLの配列を定義（Dailyの非表示URL選択でも使いたいのでコントローラー作成）
class MainUrlsController extends GetxController {
  var mainUrls = [
    'https://www.reuters.com/',
    'https://www.bloomberg.co.jp/',
    'https://finance.yahoo.co.jp/',
    'https://nikkei225jp.com/cme/'
  ].obs;

  RxList<int> items = <int>[].obs;
}

///ここからfloatingActionButton押下時のモーダル表示部分
class showModalWidget extends StatelessWidget {
  showModalWidget({Key? key}) : super(key: key);

  @override

  ///ここでタグの状態を管理
  var tag = false.obs;
  var tag1 = false.obs;
  var tag2 = false.obs;
  var tag3 = false.obs;
  var tag4 = false.obs;
  var tag5 = false.obs;
  var tag6 = false.obs;
  var tag7 = false.obs;
  var tag8 = false.obs;
  var tag9 = false.obs;

  final wc = Get.put(WebController());
  final double tagWidth = 120;

  Widget build(BuildContext context) => Container(
        height: 320,
        color: Colors.white,
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 50,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),

                    // ElevatedButton(
                    //   child: const Icon(Icons.close),
                    //   onPressed: () => Navigator.pop(context),
                    // ),
                  ),
                  // const SizedBox(width:8),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => SizedBox(
                        width: tagWidth,
                        child: ElevatedButton(
                          child: const Text('金利'),
                          style: ElevatedButton.styleFrom(
                            primary:
                                (tag.value) ? Colors.indigo : Colors.indigo[50],
                            onPrimary:
                                (tag.value) ? Colors.white : Colors.black,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            (tag.value) ? tag.value = false : tag.value = true;
                            wc.records.last.tag = tag.value;
                          },
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: tagWidth,
                        child: ElevatedButton(
                          child: const Text('債券'),
                          style: ElevatedButton.styleFrom(
                            primary: (tag1.value)
                                ? Colors.indigo
                                : Colors.indigo[50],
                            onPrimary:
                                (tag1.value) ? Colors.white : Colors.black,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            (tag1.value)
                                ? tag1.value = false
                                : tag1.value = true;
                            wc.records.last.tag1 = tag1.value;
                          },
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: tagWidth,
                        child: ElevatedButton(
                          child: const Text('米国株'),
                          style: ElevatedButton.styleFrom(
                            primary: (tag2.value)
                                ? Colors.indigo
                                : Colors.indigo[50],
                            onPrimary:
                                (tag2.value) ? Colors.white : Colors.black,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            (tag2.value)
                                ? tag2.value = false
                                : tag2.value = true;
                            wc.records.last.tag2 = tag2.value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => SizedBox(
                        width: tagWidth,
                        child: ElevatedButton(
                          child: const Text('日本株'),
                          style: ElevatedButton.styleFrom(
                            primary: (tag3.value)
                                ? Colors.indigo
                                : Colors.indigo[50],
                            onPrimary:
                                (tag3.value) ? Colors.white : Colors.black,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            (tag3.value)
                                ? tag3.value = false
                                : tag3.value = true;
                            wc.records.last.tag3 = tag3.value;
                          },
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: tagWidth,
                        child: ElevatedButton(
                          child: const Text('中国株'),
                          style: ElevatedButton.styleFrom(
                            primary: (tag4.value)
                                ? Colors.indigo
                                : Colors.indigo[50],
                            onPrimary:
                                (tag4.value) ? Colors.white : Colors.black,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            (tag4.value)
                                ? tag4.value = false
                                : tag4.value = true;
                            wc.records.last.tag4 = tag4.value;
                          },
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: tagWidth,
                        child: ElevatedButton(
                          child: const Text('FRB'),
                          style: ElevatedButton.styleFrom(
                            primary: (tag5.value)
                                ? Colors.indigo
                                : Colors.indigo[50],
                            onPrimary:
                                (tag5.value) ? Colors.white : Colors.black,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            (tag5.value)
                                ? tag5.value = false
                                : tag5.value = true;
                            wc.records.last.tag5 = tag5.value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => SizedBox(
                        width: tagWidth,
                        child: ElevatedButton(
                          child: const Text('テクニカル'),
                          style: ElevatedButton.styleFrom(
                            primary: (tag6.value)
                                ? Colors.indigo
                                : Colors.indigo[50],
                            onPrimary:
                                (tag6.value) ? Colors.white : Colors.black,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            (tag6.value)
                                ? tag6.value = false
                                : tag6.value = true;
                            wc.records.last.tag6 = tag6.value;
                          },
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: tagWidth,
                        child: ElevatedButton(
                          child: const Text('REIT'),
                          style: ElevatedButton.styleFrom(
                            primary: (tag7.value)
                                ? Colors.indigo
                                : Colors.indigo[50],
                            onPrimary:
                                (tag7.value) ? Colors.white : Colors.black,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            (tag7.value)
                                ? tag7.value = false
                                : tag7.value = true;
                            wc.records.last.tag7 = tag7.value;
                          },
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: tagWidth,
                        child: ElevatedButton(
                          child: const Text('その他'),
                          style: ElevatedButton.styleFrom(
                            primary: (tag8.value)
                                ? Colors.indigo
                                : Colors.indigo[50],
                            onPrimary:
                                (tag8.value) ? Colors.white : Colors.black,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            (tag8.value)
                                ? tag8.value = false
                                : tag8.value = true;
                            wc.records.last.tag8 = tag8.value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          child: const Icon(Icons.stars),
                          onPressed: () {
                            (tag9.value)
                                ? tag9.value = false
                                : tag9.value = true;
                            wc.records.last.tag9 = tag9.value;
                          },
                          style: ElevatedButton.styleFrom(
                            primary:
                                (tag9.value) ? Colors.indigo : Colors.white,
                            onPrimary: (tag9.value)
                                ? Colors.white
                                : Colors.indigo, //ボタンの背景色
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}

///ここからホーム画面の描画について
///後でGoogle検索実装
///一度URLを飛ばしてonloadのタイミングで入力されたワードを検索？？わからん
class BookmarkWidget extends StatelessWidget {
  BookmarkWidget({Key? key}) : super(key: key);
  final double txtsize = 12;
  @override
  final tvc = Get.put(TabViewController());
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ///ロゴ
          Padding(
            padding: const EdgeInsets.only(top: 35.0, left: 15.0, bottom: 0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Image.asset('images/katsutojiLogo_main.'
                    'png')),
          ),

          ///検索フォーム
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 45),
            child: SizedBox(
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Expanded(
                  //   child: TextField(
                  //     decoration: InputDecoration(
                  //       hintText: 'Google検索',
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(50),
                  //         borderSide: const BorderSide(
                  //           color: Colors.grey,
                  //         ),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(50),
                  //         borderSide: const BorderSide(
                  //           color: Colors.grey,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          side:
                              const BorderSide(color: Colors.black54, width: 1),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          )),
                      onPressed: () {
                        ///仮で記載
                        tvc.selectedTabIndex.value = 3;
                        tvc.selectedUrl.value = 'https://www.google.com/';
                        WebContentPage();
                      },
                      child: const Text('Google検索',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  )
                ],
              ),
            ),
          ),

          ///それぞれの画像がタップされた時にURLを渡してWebViewへ遷移
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                padding: const EdgeInsets.only(bottom: 21),
                child: GestureDetector(
                  onTap: () {
                    tvc.selectedTabIndex.value = 3;
                    tvc.selectedUrl.value = 'https://www.bloomberg.co.jp/';
                    WebContentPage();
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black54,
                                offset: Offset(2, 4),
                                spreadRadius: 1)
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundImage:
                              const AssetImage('images/bloomberg.png'),
                          radius: MediaQuery.of(context).size.width * 0.07,
                        ),
                      ),
                      // CircleAvatar(
                      //   radius: MediaQuery.of(context).size.width * 0.07,
                      //   backgroundColor: Colors.indigo[900],
                      //   child: CircleAvatar(
                      //     backgroundImage: const AssetImage('images/bloomberg.png'),
                      //     radius: MediaQuery.of(context).size.width * 0.068,
                      //   ),
                      // ),
                      const SizedBox(height: 8),
                      AutoSizeText(
                        'Bloomberg',
                        style: TextStyle(fontSize: 10),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                padding: const EdgeInsets.only(bottom: 21),
                child: GestureDetector(
                  onTap: () {
                    tvc.selectedTabIndex.value = 3; //タップされたらTabBarの位置も変更する
                    tvc.selectedUrl.value = 'https://www.traders.co.jp/';
                    WebContentPage();
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black54,
                                offset: Offset(2, 4),
                                spreadRadius: 1)
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundImage:
                              const AssetImage('images/traders_web.png'),
                          radius: MediaQuery.of(context).size.width * 0.07,
                        ),
                      ),
                      SizedBox(height: 8),
                      AutoSizeText(
                        'TradersWeb',
                        style: TextStyle(fontSize: 10),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                padding: const EdgeInsets.only(bottom: 21),
                child: GestureDetector(
                  onTap: () {
                    tvc.selectedTabIndex.value = 3; //タップされたらTabBarの位置も変更する
                    tvc.selectedUrl.value = 'https://finance.yahoo.co.jp/';
                    WebContentPage();
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black54,
                                offset: Offset(2, 4),
                                spreadRadius: 1)
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundImage:
                              const AssetImage('images/yahoofinance_logo.jpeg'),
                          radius: MediaQuery.of(context).size.width * 0.07,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AutoSizeText(
                        'Y!Finance',
                        style: TextStyle(fontSize: 10),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                padding: const EdgeInsets.only(bottom: 21),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        tvc.selectedTabIndex.value = 3; //タップされたらTabBarの位置も変更する
                        tvc.selectedUrl.value = 'https://nikkei225jp.com/cme/';
                        WebContentPage();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black54,
                                offset: Offset(2, 4),
                                spreadRadius: 1)
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundImage:
                              const AssetImage('images/cme_logo.jpeg'),
                          radius: MediaQuery.of(context).size.width * 0.07,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AutoSizeText(
                      'CME日経平均',
                      style: TextStyle(fontSize: 10),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                padding: const EdgeInsets.only(bottom: 21),
                child: GestureDetector(
                  onTap: () {
                    tvc.selectedTabIndex.value = 3;
                    tvc.selectedUrl.value = 'https://www.jpx.co.jp/';
                    WebContentPage();
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black54,
                                offset: Offset(2, 4),
                                spreadRadius: 1)
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundImage: const AssetImage('images/jpx.png'),
                          radius: MediaQuery.of(context).size.width * 0.07,
                        ),
                      ),
                      // Image(
                      //   width: MediaQuery.of(context).size.width * 0.15,
                      //   height: MediaQuery.of(context).size.width * 0.15,
                      //   image: AssetImage('images/jpx.png'),
                      // ),
                      const SizedBox(height: 8),
                      AutoSizeText(
                        '日本取引所',
                        style: TextStyle(fontSize: 10),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                padding: const EdgeInsets.only(bottom: 21),
                child: GestureDetector(
                  onTap: () {
                    tvc.selectedTabIndex.value = 3;
                    tvc.selectedUrl.value = 'https://newspicks.com/';
                    WebContentPage();
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black54,
                                offset: Offset(2, 4),
                                spreadRadius: 1)
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundImage:
                              const AssetImage('images/news_picks.png'),
                          radius: MediaQuery.of(context).size.width * 0.07,
                        ),
                      ),
                      // Image(
                      //   width: MediaQuery.of(context).size.width * 0.15,
                      //   height: MediaQuery.of(context).size.width * 0.15,
                      //   image: AssetImage('images/news_picks.png'),
                      // ),
                      const SizedBox(height: 8),
                      AutoSizeText(
                        'News Picks',
                        style: TextStyle(fontSize: 10),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                padding: const EdgeInsets.only(bottom: 21),
                child: GestureDetector(
                  onTap: () {
                    tvc.selectedTabIndex.value = 3;
                    tvc.selectedUrl.value = 'https://www.reuters.com/';
                    WebContentPage();
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black54,
                                offset: Offset(2, 4),
                                spreadRadius: 1)
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundImage:
                              const AssetImage('images/ruiters.jpeg'),
                          radius: MediaQuery.of(context).size.width * 0.07,
                        ),
                      ),
                      // Image(
                      //   width: MediaQuery.of(context).size.width * 0.15,
                      //   height: MediaQuery.of(context).size.width * 0.15,
                      //   image: AssetImage('images/ruiters.jpeg'),
                      // ),
                      const SizedBox(height: 8),
                      AutoSizeText(
                        'Ruiter',
                        style: TextStyle(fontSize: 10),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                padding: const EdgeInsets.only(bottom: 21),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        tvc.selectedTabIndex.value = 3; //タップされたらTabBarの位置も変更する
                        tvc.selectedUrl.value = 'https://www.nikkei.com/';
                        WebContentPage();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black54,
                                offset: Offset(2, 4),
                                spreadRadius: 1)
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundImage:
                              const AssetImage('images/nikkei.jpeg'),
                          radius: MediaQuery.of(context).size.width * 0.07,
                        ),
                      ),
                      // Image(
                      //   width: MediaQuery.of(context).size.width * 0.15,
                      //   height: MediaQuery.of(context).size.width * 0.15,
                      //   image: AssetImage('images/nikkei.jpeg'),
                      // ),
                    ),
                    const SizedBox(height: 8),
                    AutoSizeText(
                      '日本経済新聞',
                      style: TextStyle(fontSize: 10),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
}
