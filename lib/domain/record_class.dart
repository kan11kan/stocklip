class Record {
  Record({
    this.url = '',
    this.day = '',
    this.hide = false,
    this.startTime,
    this.endTime,
    this.title = '',
    // this.tags,
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
  String title;
  // List<String> tags = [];
  // String newstitle;

  /// 外部から値を代入するメソッド
  Record copyWith({
    String? url,
    String? day,
    bool? hide,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return Record(
      url: url ?? this.url,
      day: day ?? this.day,
      hide: hide ?? this.hide,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Record.fromJson(Map<String, dynamic> json)
      : url = json["url"],
        day = json["day"],
        hide = json["hide"],
        title = json["title"];

  ///startTimeとendTimeを作成したらエラーになったので一旦消す。
  // startTime = json["startTime"],
  // endTime = json["endTime"];
  // newstitle = json['newstitle'],
  // tags = json["tags"];
  //jsondecodeでjson tagsを囲う（decodeする）→List<String>に変換する。
  //Map<String , dynamic>の型を<Record>型にしている

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'day': day,
      'hide': hide,
      'title': title,
      // 'startTime': startTime,
      // 'endTime': endTime
    };
    //レコード型のものがMap<String ,dynamic>になる。
    // JsonをDecodeしたものがMap<String,dynamic>になる
  }
}
