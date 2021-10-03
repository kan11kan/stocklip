class DailyData {
  DailyData(
      {this.memo = '',
      this.day = '',
      this.valuableUrl = '',
      required this.tags});

  // フィールド
  String memo;
  String day;
  String valuableUrl;
  List tags = []; //一旦なくてもOK

  DailyData.fromJson(Map<String, dynamic> json)
      : memo = json["memo"],
        day = json["day"],
        valuableUrl = json["valuableUrl"];

  Map<String, dynamic> toJson() {
    return {'memo': memo, 'day': day, 'valuableUrl': valuableUrl};
  }
}
