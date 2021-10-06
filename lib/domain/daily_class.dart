import 'package:one_app_everyday921/domain/record_class.dart';

class Daily {
  Daily({
    this.memo,
    this.day,
    // this.records
  });

  // フィールド
  String? memo;
  String? day;
  // String valuableUrl; //一番readtimeが
  // List? tags = [];
  List<Record>? records; //レコードをここで管理する。

  //書き方違うかも
  Daily.fromJson(Map<String, dynamic> json)
      : memo = json["memo"],
        day = json["day"];

  Map<String, dynamic> toJson() {
    return {'memo': memo, 'day': day};
  }
}
