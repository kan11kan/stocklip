// import 'package:cloud_firestore/cloud_firestore.dart';

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

import 'main_button_widget.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  ///wc.recordは常にデータをもっている状態にする。boxからwc.recordsをgetする
  /// その後の状態管理はすべてgetxで行う。

  final wc = Get.put(WebController());

  ///最初にboxを開く処理を書くとエラーで立ち上がらない！！
  ///box.get('record')==null ? :
  // final box = await Hive.openBox('recordsGeneratedByUrl');
  // wc.records.value = jsonDecode(box.get('records'))
  //     .map((el) => Record.fromJson(el))
  //     .toList()
  //     .cast<Record>() as List<Record>;
  // print('${box.get('records')}');

  // final dc = Get.put(DailyDataController());
  // final dbox = await Hive.openBox('recordsByDay');
  // dc.records.value = jsonDecode(dbox.get('recordsByDay'))
  //     .map((el) => DailyData.fromJson(el));
  //     .toList()
  //     .cast<DailyData>() as List<DailyData>;
  // print('${box.get('records')}');

  // print(urls.value[0].url);
  // print(urls.value[1].url);
  // print(urls.value[2].url);
  // print(urls.value[3].url);
  // print(urls.value.length);
  // final list = [];
  runApp(MyApp());
}

//MyHomePageの呼び出し
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'nanannanana',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

//TabView（どのタブバーがタップされたのかを管理するコントローラーを作成）
class TabViewController extends GetxController {
  //Hiveの確認
  // final bbb = ''.obs;
  // void aaa() async {
  //   await Hive.openBox('settings');
  //   final box = await Hive.openBox('settings');
  //   bbb.value = box.get('key');
  // }
  var selectedUrl = ''.obs; //選択された画像に対してUrlを割り当てる。
  var selectedTabIndex = 0.obs; //選択されたタブを'selectedTabIndex'で管理している
  void onItemTapped(int index) {
    selectedTabIndex.value = index;
  }
}

//MyHomePageをStatelessWidgetで作る
class MyHomePage extends StatelessWidget {
  //childListでどのページを表示するのか（Tabは共通でそれ以外の中身部分）を管理
  final List<Widget> contentsList = [
    MyHomePageContent(),
    ArchivesPage(),
    DailyPage(),
    WebContentPage(),
  ];
  final List<Widget> navBarNameList = [
    const Text('Home'),
    const Text('Archives'),
    const Text('Daily news'),
    const Text('Web page')
  ];
  final List<bool> floatingButtonList = [
    false,
    false,
    false,
    true,
  ];
  final tvc = Get.put(TabViewController());
  // final dc = Get.put(DailyDataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => navBarNameList[tvc.selectedTabIndex.value],
        ),
        leading: Icon(Icons.arrow_back_ios),
        actions: <Widget>[IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: 'archives',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.text_format),
              label: 'Daily news',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded),
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
              // void tmp() async {
              //   final box = await Hive.openBox('recordsByDay');
              //   print('${box.get("dailyRecords")}');
              // }
              // tmp();
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return showModalWidget();
                },
              );
            },
            child: const Icon(Icons.star_purple500_outlined),
            backgroundColor: Colors.blue,
          ),
          visible: floatingButtonList[tvc.selectedTabIndex.value],
        ),
      ),
    );
  }
}

//ここからボディの中身（MyHomePageContent == HomeのTab,NavBar以外の部分）を記載していく
class MyHomePageContent extends StatelessWidget {
  final tvc = Get.put(TabViewController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: BookmarkWidget());
  }
}

//dateの書き方について念の為残す
//   final List<Record> records = <Record>[]; // setStateで状態を管理したいのでここで宣言をしている値
//   final String day =
//       DateFormat('yyyy-MM-dd').format(DateTime.now()); //一度だけ定義したい値
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now(); //ビルドするたびに代入される値。setstateでは変えることができない。
//     // DateFormat outputFormat = DateFormat('yyyy/MM/dd(E) HH:mm:ss');
//     DateFormat outputFormat = DateFormat('yyyy-MM-dd');
//     String day = outputFormat.format(now);
