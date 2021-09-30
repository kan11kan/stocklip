import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:one_app_everyday921/domain/record.dart';
import 'package:one_app_everyday921/presentation/record_page/record_page.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

import '../../main.dart';

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

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    // final urls = widget.passedValue.map((element) => (element.url)).toList();
    final days = widget.passedValue.map((element) => (element.day)).toList();
    final now = widget.now;
    String date = widget.outputFormat.format(now);
    var todayData = widget.passedValue
        .where((el) => el.day == date && el.hide == false)
        .toList();
    var todayUrls = todayData.map((element) => (element.url)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${date}'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            title: Text('archives'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_format),
            title: Text('Daily record'),
          ),
          BottomNavigationBarItem(
            title: Text('Web Page'),
            icon: Icon(Icons.add_box_rounded),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
          GestureDetector(
            onLongPress: () {},
            child: ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                for (int index = 0; index < todayUrls.length; index++)
                  Slidable(
                    key: Key('$index'),
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: GestureDetector(
                      onLongPress: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 320,
                              color: Colors.white,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(bottom: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            child: const Text('金利'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              onPrimary: Colors.black,
                                              shape: const StadiumBorder(),
                                            ),
                                            onPressed: () {},
                                          ),
                                          ElevatedButton(
                                            child: const Text('日経平均'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              onPrimary: Colors.black,
                                              shape: const StadiumBorder(),
                                            ),
                                            onPressed: () {},
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
                                      child: ElevatedButton(
                                        child: Text('Close BottomSheet'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Container(
                              width: 380,
                              child: SimpleUrlPreview(
                                url: todayUrls[_items[index]],
                                bgColor: Colors.white,
                                // isClosable: true,
                                titleLines: 1,
                                descriptionLines: 2,
                                imageLoaderColor: Colors.white,
                                previewHeight: 150,
                                previewContainerPadding: EdgeInsets.all(5),
                                onTap: () {
                                  // print('ccc');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebPage(
                                              // '${todayUrls[_items[index]]}'
                                              )));
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
                            Container(
                              child: ReorderableDragStartListener(
                                index: index,
                                child: const Icon(Icons.drag_handle),
                              ),
                            ),

                            // Container(
                            //     width: 10,
                            //     child: GestureDetector(
                            //         onTap: () {
                            //           setState(() {
                            //             todayData[index].hide = true;
                            //           });
                            //         },
                            //         child: Icon(Icons.delete)))
                          ],
                        ),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          setState(() {
                            todayData[index].hide = true;
                          });
                        },
                      ),
                    ],
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(todayData[0].hide);
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
