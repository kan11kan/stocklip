import 'package:one_app_everyday921/domain/record.dart';

class Daily {
  Daily({this.memo, this.day, this.records});

  // フィールド
  String? memo;
  DateTime? day;
  // String valuableUrl; //一番readtimeが
  // List? tags = [];
  List<Record>? records; //レコードをここで管理する。

  // DailyData.fromJson(Map<String, dynamic> json)
  //     : memo = json["memo"],
  //       day = json["day"],
  //       valuableUrl = json["valuableUrl"];
  //
  // Map<String, dynamic> toJson() {
  //   return {'memo': memo, 'day': day, 'valuableUrl': valuableUrl};
  // }
}
