import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/record.dart';
import 'package:one_app_everyday921/record_page.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

class MemoPage extends StatefulWidget {
  MemoPage(this.passedValue);
  final List<Record> passedValue;
  DateTime now = DateTime.now();
  DateFormat outputFormat = DateFormat('yyyy-MM-dd');

  @override
  State<MemoPage> createState() => MemoPageState();
}

class MemoPageState extends State<MemoPage> {
  // List<String> todayUrls = <String>[];
  // List<String> day = <String>[];

  List<int> _items = List<int>.generate(100, (int index) => index);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    // final urls = widget.passedValue.map((element) => (element.url)).toList();
    final days = widget.passedValue.map((element) => (element.day)).toList();
    final now = widget.now;
    String date = widget.outputFormat.format(now);
    final todayData = widget.passedValue.where((el) => el.day == date).toList();
    final todayUrls = todayData.map((element) => (element.url)).toList();
    // return Text('aaaa');

    return Scaffold(
      appBar: AppBar(
        title: Text('${date}'),
      ),
      body: Center(
        child: ReorderableListView(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          children: <Widget>[
            for (int index = 0; index < todayUrls.length; index++)
              ListTile(
                key: Key('$index'),
                title: SimpleUrlPreview(
                  url: todayUrls[_items[index]],
                  bgColor: Colors.white,
                  isClosable: true,
                  titleLines: 2,
                  descriptionLines: 2,
                  imageLoaderColor: Colors.white,
                  previewHeight: 150,
                  previewContainerPadding: EdgeInsets.all(5),
                  onTap: () => print(todayUrls),
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
                onTap: () {},
                trailing: Column(
                  children: [
                    ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_handle),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return MemoFieldPage();
                                },
                                fullscreenDialog: true));
                      },
                      child: Icon(Icons.add),
                    )
                  ],
                ),
              ),
          ],
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final int item = _items.removeAt(oldIndex);
              _items.insert(newIndex, item);

              print(todayUrls);
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecordPage(widget.passedValue)));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.article_outlined),
      ),
    );
  }
}

//ここからメモ欄
class MemoFieldPage extends StatefulWidget {
  @override
  State<MemoFieldPage> createState() => MemoFieldPageState();
}

class MemoFieldPageState extends State<MemoFieldPage> {
  final myController = TextEditingController();
  List<String> items = <String>['aaa', 'bbb', 'ccc', 'ddd'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("メモ入力欄")),
      body: Column(
        children: [
          Center(
            child: TextField(controller: myController),
          ),
          ElevatedButton(
              onPressed: () {
                // print(myController.text);
                setState(
                  () {
                    items.add(myController.text);
                    myController.clear();
                    Navigator.pop(context);
                  },
                );
              },
              child: Text('保存'))
        ],
      ),
    );
  }
}
