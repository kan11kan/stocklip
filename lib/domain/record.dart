class Record {
  Record({this.url = '', this.day = '', this.hide = false});
  // フィールド
  String url;
  String day;
  // DateTime time;
  bool hide;

  Record.fromJson(Map<String, dynamic> json)
      : url = json["url"],
        day = json["day"],
        hide = json["hide"];

  Map<String, dynamic> toJson() {
    return {'url': url, 'day': day, 'hide': hide};
  }

  //firestoreテスト
  // Record.fromDocumentSnapshot(
  //   DocumentSnapshot documentSnapshot,
  // ) {
  //   url = documentSnapshot.data["url"];
  //   day = documentSnapshot.data["day"];
  //   hide = documentSnapshot.data["hide"];
  //   urlId = documentSnapshot.data["urlId"];
  // }

  // Record copyWith({
  //   //Recordクラスのメソッド copyWithっていう名前のついたメソッド
  //   String? url,
  //   String? day,
  // }) {
  //   return Record(
  //     url: url ?? this.url, //？？の意味→左辺がnullだったら右辺を代入する
  //     day: day ?? this.day,
  //   );
  // }

// メソッド
// void setUrl(String url) {
//   this.url = url;
// }
//
// void setDay(String day) {
//   this.day = day;
// }
}
