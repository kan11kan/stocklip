class Record {
  const Record({this.url = '', this.day = ''});
  // フィールド
  final String url;
  final String day;

  Record copyWith({
    String? url,
    String? day,
  }) =>
      Record(
        url: url ?? this.url,
        day: day ?? this.day,
      );

// メソッド
// void setUrl(String url) {
//   this.url = url;
// }
//
// void setDay(String day) {
//   this.day = day;
// }
}
