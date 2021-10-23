// import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:one_app_everyday921/presentation/archives_page/archives_page.dart';
import 'package:one_app_everyday921/presentation/daily_page/daily_page.dart';
import 'package:one_app_everyday921/presentation/web_page/web_controller.dart';
import 'package:one_app_everyday921/presentation/web_page/web_page.dart';

import 'domain/record_class.dart';
import 'main_button_widget.dart';

void main() async {
  await Hive.initFlutter();

  ///wc.recordは常にデータをもっている状態にする。boxからwc.recordsをgetする
  /// その後の状態管理はすべてgetxで行う。
  final wc = Get.put(WebController());
  final box = await Hive.openBox('recordsGeneratedByUrl');

  if (box.get('records') != null) {
    wc.records.value = jsonDecode(box.get('records'))
        .map((el) => Record.fromJson(el))
        .toList()
        .cast<Record>() as List<Record>;
  }

  ///Dailyが保存されているか確認
  // print(urls.value[0].url);
  // print(urls.value[1].url);
  // print(urls.value[2].url);
  // print(urls.value[3].url);
  // print(urls.value.length);
  // final list = [];
  runApp(MyApp());
}

///MyHomePageの呼び出し
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(),
    );
  }
}

///TabView（どのタブバーがタップされたのかを管理するコントローラーを作成）
class TabViewController extends GetxController {
  var selectedUrl = 'https://www.google.com/'.obs; //選択された画像に対してUrlを割り当てる。
  var selectedTabIndex = 0.obs; //選択されたタブを'selectedTabIndex'で管理している
  void onItemTapped(int index) {
    selectedTabIndex.value = index;
  }
}

///MyHomePageをStatelessWidgetで作る
class MyHomePage extends StatelessWidget {
  ///childListでどのページを表示するのか（Tabは共通でそれ以外の中身部分）を管理
  final List<Widget> contentsList = [
    MyHomePageContent(),
    ArchivesPage(),
    DailyPage(),
    WebContentPage(),
  ];
  final List<Widget> navBarNameList = [
    const Text('Home'),
    const Text('Archives'),
    const Text('Daily News'),
    const Text('Web Page')
  ];
  final List<bool> floatingButtonList = [
    false,
    false,
    false,
    true,
  ];
  final tvc = Get.put(TabViewController());

  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(
          () => navBarNameList[tvc.selectedTabIndex.value],
        ),
        // leading: const Icon(Icons.arrow_back),
        // actions: <Widget>[
        //   IconButton(onPressed: () {}, icon: const Icon(Icons.menu))
        // ],
      ),

      ///ここからTabBar
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined),
              // icon: Icon(Icons.source_outlined),
              label: 'Archives',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_edu_outlined),
              // icon: Icon(Icons.article_outlined),
              label: 'Daily news',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.public),
              label: 'Web Page',
            ),
          ],
          currentIndex: tvc.selectedTabIndex.value,
          selectedItemColor: Colors.blueAccent,
          onTap: tvc.onItemTapped,
        ),
      ),
      body: Obx(() => contentsList[tvc.selectedTabIndex.value]),
      floatingActionButton: Obx(
        () => Visibility(
          child: FloatingActionButton(
            
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return showModalWidget();
                },
              );
            },
            child: const Icon(Icons.star_purple500_outlined),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          visible: floatingButtonList[tvc.selectedTabIndex.value],
        ),
      ),
    );
  }
}

///ここからボディの中身（MyHomePageContent == HomeのTab,NavBar以外の部分）を記載していく
class MyHomePageContent extends StatelessWidget {
  final tvc = Get.put(TabViewController());

  MyHomePageContent({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: BookmarkWidget());
  }
}

///後から解消する不具合
///①最初にWebPageにタブバーへ移動すると、URLが未選択　→タイトルがとれないのでarchivesがエラーに
///②simple url preview　の　並び替えがうまくいかない

///⑤タグの管理
///⑥戻る、進むボタンの実装
///⑦Google検索→グーグルが開く
///⑧スライドで削除
///⑨時刻
///⑩メモの表示
