class Daily {
  Daily({this.memo, this.day, this.allUrls, this.mostImportantUrl});

  // フィールド
  String? memo;
  String? day;
  String? allUrls;
  String? mostImportantUrl;

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
