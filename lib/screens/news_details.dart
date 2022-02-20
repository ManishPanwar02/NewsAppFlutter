import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/NewsModel.dart';
import 'package:url_launcher/url_launcher.dart';
class NewsDetailScreen extends StatelessWidget {
  final NewsItem newsItem;

  NewsDetailScreen({required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xff0c54be)),
      body: NewsDetailBody(newsItem: newsItem),
    );
  }
}

class NewsDetailBody extends StatelessWidget {
  final NewsItem newsItem;

  NewsDetailBody({required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Stack(children: [
        Image.network("${newsItem.urlToImage}"),
        Positioned.fill(
            child: Padding(
          padding: EdgeInsets.all(0),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Card(
                color: Colors.transparent,
                  child: Padding(padding:EdgeInsets.all(10),child:Text("${newsItem.title}",
                      style: TextStyle(color: Colors.white,fontFamily: "Poppins",fontWeight: FontWeight.w600))))),
        )),
      ]),
      Padding(
          padding: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 10),
            Text(
              "${newsItem.source.name}",
              style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic),
            ),
            Text("${newsItem.publishedAt}"),
            const SizedBox(height: 10),
            Text("${newsItem.content}"),
            const SizedBox(
              height: 10,
            ),
            InkWell(
                onTap: () async {
                  if (await canLaunch("${newsItem.url}")) {
                    print("Clicked");
                    await launch("${newsItem.url}", forceSafariVC: false);
                  }
                },
                child: Row(children: const [
                  Text(
                    "See Full Story",
                    style:
                        TextStyle(color: Color(0xff0c54be), fontFamily: "Lato"),
                  ),
                  SizedBox(
                      width: 20,
                      height: 18,
                      child: ImageIcon(
                        AssetImage("assets/image/icons8-right-arrow-64.png"),
                        color: Color(0xff0c54be),
                      ))
                ]))
          ]))
    ]));
  }
}
