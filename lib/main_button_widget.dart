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
  showModalWidget({
    Key? key,
  }) : super(key: key);
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

  final wc = Get.put(WebController());

  Widget build(BuildContext context) => Container(
        height: 320,
        color: Colors.white,
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => ElevatedButton(
                        child: const Text('金利'),
                        style: ElevatedButton.styleFrom(
                          primary: (tag.value) ? Colors.blue : Colors.white,
                          onPrimary: Colors.black,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          (tag.value) ? tag.value = false : tag.value = true;
                          wc.records.last.tag = tag.value;
                        },
                      ),
                    ),
                    Obx(
                      () => ElevatedButton(
                        child: const Text('日経平均'),
                        style: ElevatedButton.styleFrom(
                          primary: (tag1.value) ? Colors.blue : Colors.white,
                          onPrimary: Colors.black,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          (tag1.value) ? tag1.value = false : tag1.value = true;
                        },
                      ),
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
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: const Text('個別株'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {},
                    ),
                    ElevatedButton(
                      child: const Text('テクニカル'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {},
                    ),
                    ElevatedButton(
                      child: const Text('FRB'),
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
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: const Text('REIT'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {},
                    ),
                    ElevatedButton(
                      child: const Text('債券'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {},
                    ),
                    ElevatedButton(
                      child: const Text('その他'),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Icon(Icons.star_purple500_outlined),
                      onPressed: () {},
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
  BookmarkWidget({
    Key? key,
  }) : super(key: key);

  @override
  final tvc = Get.put(TabViewController());
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ///検索フォーム
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 85, 10, 70),
            child: SizedBox(
              height: 45,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Google検索',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        ///仮で記載
                        tvc.selectedTabIndex.value = 3;
                        tvc.selectedUrl.value = 'https://www.google.com/';
                        WebContentPage();
                      },
                      child: Text('検索'))
                ],
              ),
            ),
          ),

          ///それぞれの画像がタップされた時にURLを渡してWebViewへ遷移
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: () {
                    tvc.selectedTabIndex.value = 3;
                    tvc.selectedUrl.value = 'https://www.reuters.com/';
                    WebContentPage();
                  },
                  child: Column(
                    children: const [
                      Image(
                        width: 80,
                        height: 80,
                        image: AssetImage('images/ruiters.jpeg'),
                      ),
                      Text('ruiters'),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: () {
                    tvc.selectedTabIndex.value = 3;
                    tvc.selectedUrl.value = 'https://www.bloomberg.co.jp/';
                    WebContentPage();
                  },
                  child: Column(
                    children: const [
                      Image(
                        width: 80,
                        height: 80,
                        image: AssetImage('images/bloomberg.png'),
                      ),
                      Text('Bloomberg')
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: () {
                    tvc.selectedTabIndex.value = 3; //タップされたらTabBarの位置も変更する
                    tvc.selectedUrl.value = 'https://finance.yahoo.co.jp/';
                    WebContentPage();
                  },
                  child: Column(
                    children: const [
                      Image(
                        width: 80,
                        height: 80,
                        image: AssetImage('images/yahoofinance_logo.jpeg'),
                      ),
                      Text('Yahoo Finance!')
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        tvc.selectedTabIndex.value = 3; //タップされたらTabBarの位置も変更する
                        tvc.selectedUrl.value = 'https://nikkei225jp.com/cme/';
                        WebContentPage();
                      },
                      child: const Image(
                        width: 80,
                        height: 80,
                        image: AssetImage('images/cme_logo.jpeg'),
                      ),
                    ),
                    Text('CME日経平均')
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: () {
                    tvc.selectedTabIndex.value = 3;
                    tvc.selectedUrl.value = 'https://jp.reuters.com/';
                    WebContentPage();
                  },
                  child: Column(
                    children: const [
                      Image(
                        width: 80,
                        height: 80,
                        image: AssetImage('images/ruiters.jpeg'),
                      ),
                      Text('ruiters'),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: () {
                    tvc.selectedTabIndex.value = 3;
                    tvc.selectedUrl.value = 'https://www.bloomberg.co.jp/';
                    WebContentPage();
                  },
                  child: Column(
                    children: const [
                      Image(
                        width: 80,
                        height: 80,
                        image: AssetImage('images/bloomberg.png'),
                      ),
                      Text('Bloomberg')
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: () {
                    tvc.selectedTabIndex.value = 3; //タップされたらTabBarの位置も変更する
                    tvc.selectedUrl.value = 'https://finance.yahoo.co.jp/';
                    WebContentPage();
                  },
                  child: Column(
                    children: const [
                      Image(
                        width: 80,
                        height: 80,
                        image: AssetImage('images/yahoofinance_logo.jpeg'),
                      ),
                      Text('Yahoo Finance!')
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        tvc.selectedTabIndex.value = 3; //タップされたらTabBarの位置も変更する
                        tvc.selectedUrl.value = 'https://nikkei225jp.com/cme/';
                        WebContentPage();
                      },
                      child: const Image(
                        width: 80,
                        height: 80,
                        image: AssetImage('images/cme_logo.jpeg'),
                      ),
                    ),
                    const Text('CME日経平均')
                  ],
                ),
              ),
            ],
          ),
        ],
      );
}
