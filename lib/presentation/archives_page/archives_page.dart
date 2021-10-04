import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/presentation/web_page/web_page.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

import 'button_widget.dart';

//StatelessWidgetで描き直し
class ArchivesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Container(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'キーワード検索',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: DateRangePickerWidget(),
              ),
              ElevatedButton(
                onPressed: () {
                  //Archivesのページに検索履歴を表示する。戻るボタンでArchivesに戻る。
                  //Get.to()で記載
                  Get.to(SearchResult());
                },
                child: Text('検索'),
              ),
            ],
          ),
        ),
        ShowCards(),
      ],
    );
  }
}

class DateRangePickerWidget extends StatefulWidget {
  @override
  _DateRangePickerWidgetState createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  DateTimeRange dateRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(hours: 24 * 3)));

  String getFrom() {
    if (dateRange == null) {
      return 'From';
    } else {
      return DateFormat('MM/dd/yyyy').format(dateRange.start);
    }
  }

  String getUntil() {
    if (dateRange == null) {
      return 'Until';
    } else {
      return DateFormat('MM/dd/yyyy').format(dateRange.end);
    }
  }

  @override
  Widget build(BuildContext context) => HeaderWidget(
        title: 'Date',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              child: ButtonWidget(
                text: getFrom(),
                onClicked: () => pickDateRange(context),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.blueGrey),
            const SizedBox(width: 8),
            SizedBox(
              width: 150,
              child: ButtonWidget(
                text: getUntil(),
                onClicked: () => pickDateRange(context),
              ),
            ),
          ],
        ),
      );

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 15),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: initialDateRange,
    );

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }
}

//ここからカード形式で表示するテスト
class ShowCards extends StatefulWidget {
  @override
  ShowCardsState createState() => ShowCardsState();
}

class ShowCardsState extends State<ShowCards> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 500,
        child: ListView(
          children: [
            Card(
              child: SizedBox(
                width: 300,
                height: 200,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('10月10日　'),
                        Text('日経平均終値：30,200円'),
                      ],
                    ),
                    Row(
                      children: [
                        Text('タグ1'),
                        Text('タグ2'),
                        Text('タグ3'),
                      ],
                    ),
                    ImportantContent(),
                  ],
                ),
              ),
            ),
            Card(
              child: SizedBox(
                width: 300,
                height: 200,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('10月9日　'),
                        Text('日経平均終値：30,000円'),
                      ],
                    ),
                    Row(
                      children: [
                        Text('タグ1'),
                        Text('タグ2'),
                        Text('タグ3'),
                      ],
                    ),
                    ImportantContent2(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//リストの作成は、recordの中に本日の日付と一致するものがあれば作成する？
//ImportantContentはメモがある場合とない場合で場合わけする。

class ImportantContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //onTap: ここにTapしたらDaily recordに画面遷移する（タップしたカードの日付を渡す）
      child: Container(
        width: 400,
        child: SimpleUrlPreview(
          url:
              //ここにもっとも滞在時間が長いURLが表示される
              //日付と開始時刻、終了時刻でフィルターをかけたURLを表示する
              'https://www.bloomberg.co.jp/news/articles/2021-10-01/R0B7KODWRGG301?srnd=cojp-v2',
          bgColor: Colors.white,
          titleLines: 1,
          descriptionLines: 2,
          imageLoaderColor: Colors.white,
          previewHeight: 150,
          previewContainerPadding: EdgeInsets.all(5),
          onTap: () {
            Get.to(WebContentPage());
          },
          titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          descriptionStyle: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          siteNameStyle: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

//擬似的にメモがある場合を再現
class ImportantContent2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: SizedBox(
            width: 270,
            height: 140,
            child: Text(
                //ここに日付でフィルターをかけたメモの内容が表示される
                //recordsに保存した日付とメモの組み合わせから取得
                'メモの内容が入ります'),
          ),
        ),
      ),
    );
  }
}

class SearchResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Text('test'),
    );
  }
}
