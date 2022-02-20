class NewsItem {
  final NewsSource source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  NewsItem(
      {required this.source,
      required this.author,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt,
      required this.content});

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    final source=json["source"] as Map<String,dynamic>;
    return NewsItem(
        source: NewsSource(id:source["id"],name:source["name"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: json["publishedAt"],
        content: json["content"]);
  }
}

class NewsSource {
  final String? id;
  final String name;

  NewsSource({required this.id, required this.name});
}
class NewsModel{
  final String status;
  final int totalResults;
  final List<NewsItem> articles;
  NewsModel({required this.status,required this.totalResults,required this.articles});
  factory NewsModel.fromJson(Map<String,dynamic>json){
    final newsList=(json["articles"] as List).map((ele) => NewsItem.fromJson(ele)).toList();
    return NewsModel(
      status: json["status"],
      totalResults: json["totalResults"],
      articles: newsList
    );

  }

}


