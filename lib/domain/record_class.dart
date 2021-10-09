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
    this.tag1 = false,
    this.tag2 = false,
    this.tag3 = false,
    this.tag4 = false,
    this.tag5 = false,
    this.tag6 = false,
    this.tag7 = false,
    this.tag8 = false,
    this.tag9 = false,
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
  bool tag1;
  bool tag2;
  bool tag3;
  bool tag4;
  bool tag5;
  bool tag6;
  bool tag7;
  bool tag8;
  bool tag9;

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
        tag = json["tag"],
        tag1 = json["tag1"],
        tag2 = json["tag2"],
        tag3 = json["tag3"],
        tag4 = json["tag4"],
        tag5 = json["tag5"],
        tag6 = json["tag6"],
        tag7 = json["tag7"],
        tag8 = json["tag8"],
        tag9 = json["tag9"];

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
      'tag1': tag1,
      'tag2': tag2,
      'tag3': tag3,
      'tag4': tag4,
      'tag5': tag5,
      'tag6': tag6,
      'tag7': tag7,
      'tag8': tag8,
      'tag9': tag9

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
