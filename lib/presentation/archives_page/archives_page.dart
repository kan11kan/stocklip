import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'button_widget.dart';

//StatelessWidgetで描き直し
class ArchivesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Container(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'キーワード検索',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    )),
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
        Container(child: DateRangePickerWidget())
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
