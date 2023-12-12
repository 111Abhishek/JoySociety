class APIMetaData {
  int totalCount;
  int pageCount;
  int currentPage;
  int perPage;
  String? next;
  String? previous;

  APIMetaData({
    required this.totalCount,
    required this.pageCount,
    required this.currentPage,
    required this.perPage,
    required this.next,
    required this.previous,
  });

  factory APIMetaData.fromJson(Map<String, dynamic> json) =>
      APIMetaData(
        totalCount: json["count"] ,
        pageCount: json["pageCount"] ,
        currentPage: json["currentPage"] ,
        perPage: json["perPage"] = 20,
        next: json["next"],
        previous: json["previous"],
      );

}
