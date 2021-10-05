class Record {
  Record({
    this.url = '',
    this.day = '',
    this.hide = false,
    // required this.tags,
    // this.newstitle = ''
  });
  // フィールド
  String url;
  String day;
  bool hide;
  // List<String> tags = [];
  // String newstitle;

  //title
  //date

  Record.fromJson(Map<String, dynamic> json)
      : url = json["url"],
        day = json["day"],
        hide = json["hide"];
  // newstitle = json['newstitle'],
  // tags = json["tags"];
  //jsondecodeでjson tagsを囲う（decodeする）→List<String>に変換する。

  //Map<String , dynamic>の型を<Record>型にしている

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'day': day,
      'hide': hide,
    };
    //レコード型のものがMap<String ,dynamic>になる。
    // JsonをDecodeしたものがMap<String,dynamic>になる
  }
}
