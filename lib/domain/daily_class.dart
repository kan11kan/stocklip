class Daily {
  Daily({this.memo, this.day, this.allUrls, this.mostImportantUrl
      // this.records
      });

  // フィールド
  String? memo;
  String? day;
  String? allUrls;
  String? mostImportantUrl;
  // String valuableUrl; //一番readtimeが
  // List? tags = [];
  // List<Record>? records; //レコードをここで管理する。

  //書き方違うかも
  Daily.fromJson(Map<String, dynamic> json)
      : memo = json["memo"],
        day = json["day"],
        allUrls = json["allUrls"],
        mostImportantUrl = json["mostImportantUrl"];

  Map<String, dynamic> toJson() {
    return {
      'memo': memo,
      'day': day,
      'allUrls': allUrls,
      'mostImportantUrl': mostImportantUrl
    };
  }
}
