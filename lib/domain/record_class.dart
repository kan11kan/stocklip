class Record {
  Record({
    this.url = '',
    this.day = '',
    this.hide = false,
    this.startTime,
    this.endTime,
    this.memo = '',
    this.newsTitle = '',
    this.tag = false,
    // required this.tags,
    // this.newstitle = ''
  });
  // フィールド
  String url;
  String day;
  bool hide;
  DateTime? startTime;
  DateTime? endTime;
  // int get readTime => endTime?.difference(startTime).inSeconds ?? 0;
  int get readTime => endTime != null && startTime != null
      ? endTime!.difference(startTime!).inSeconds
      : 0;
  String? memo;
  String? newsTitle;
  bool tag;

  // List<String> tags = [];
  // String newstitle;

  /// 外部から値を代入するメソッド
  // Record copyWith({
  //   String? url,
  //   String? day,
  //   bool? hide,
  //   DateTime? startTime,
  //   DateTime? endTime,
  // }) {
  //   return Record(
  //     url: url ?? this.url,
  //     day: day ?? this.day,
  //     hide: hide ?? this.hide,
  //     startTime: startTime ?? this.startTime,
  //     endTime: endTime ?? this.endTime,
  //   );
  // }

  Record.fromJson(Map<String, dynamic> json)
      : url = json["url"],
        day = json["day"],
        hide = json["hide"],
        memo = json["memo"],
        newsTitle = json["newsTitle"],
        tag = json["tag"];

  ///startTimeとendTimeを作成したらエラーになったので一旦消す。
  // startTime = json["startTime"],
  // endTime = json["endTime"];
  // newstitle = json['newstitle'],
  //jsondecodeでjson tagsを囲う（decodeする）→List<String>に変換する。
  //Map<String , dynamic>の型を<Record>型にしている

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'day': day,
      'hide': hide,
      'memo': memo,
      'newsTitle': newsTitle,
      'tag': tag,
      // 'startTime': startTime,
      // 'endTime': endTime
    };
    //レコード型のものがMap<String ,dynamic>になる。
    // JsonをDecodeしたものがMap<String,dynamic>になる
  }
}

//class Daily {
//   Daily({this.memo, this.day, this.allUrls, this.mostImportantUrl
//       // this.records
//       });
//
//   // フィールド
//   String? memo;
//   String? day;
//   String? allUrls;
//   String? mostImportantUrl;
//   // String valuableUrl; //一番readtimeが
//   // List? tags = [];
//   // List<Record>? records; //レコードをここで管理する。
//
//   //書き方違うかも
//   Daily.fromJson(Map<String, dynamic> json)
//       : memo = json["memo"],
//         day = json["day"],
//         allUrls = json["allUrls"],
//         mostImportantUrl = json["mostImportantUrl"];
//
//   Map<String, dynamic> toJson() {
//     return {
//       'memo': memo,
//       'day': day,
//       'allUrls': allUrls,
//       'mostImportantUrl': mostImportantUrl
//     };
//   }
