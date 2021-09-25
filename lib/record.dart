class Record {
  Record({this.url = '', this.day = '', this.hide = false});
  // フィールド
  final String url;
  final String day;
  bool hide;

  Record copyWith({
    //Recordクラスのメソッド copyWithっていう名前のついたメソッド
    String? url,
    String? day,
  }) {
    return Record(
      url: url ?? this.url, //？？の意味→左辺がnullだったら右辺を代入する
      day: day ?? this.day,
    );
  }

// メソッド
// void setUrl(String url) {
//   this.url = url;
// }
//
// void setDay(String day) {
//   this.day = day;
// }
}
