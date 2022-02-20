import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/NewsModel.dart';
import 'news_details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final scrollController = ScrollController();
  int currentSize = 0;
  int totalSize = 0;
  bool isLoaded = false;
  int currentPage = 0;
  List<NewsItem> newsList = [];
  String query = "";
  final _apiKey = "df9430a94fae4b218d7c7c78f470e01b";

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          isLoaded &&
          currentSize != totalSize) {
        isLoaded = false;
        setState(() {});
        _searchNews(query, true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future<bool> _searchNews(String query, bool isPaginated) async {
    this.query = query;

    if (!isPaginated) {
      newsList.clear();
      currentPage = 0;
      totalSize = 0;
      currentSize = 0;
    }
    if (totalSize != 0 && currentSize == totalSize) {
      isLoaded = true;
      return true;
    } else {
      currentPage++;
    }
    final url =
        "https://newsapi.org/v2/everything?q=$query&apiKey=$_apiKey&page=$currentPage";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final newsModel = NewsModel.fromJson(json);
      totalSize = newsModel.totalResults;
      newsList.addAll(newsModel.articles);
      currentSize = newsList.length;
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0c54be),
        ),
        body: Container(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0XFFCED3DC),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Expanded(
                            child: TextFormField(
                              onFieldSubmitted: (value){
                                _searchNews(value, false);
                              },
                              decoration: const InputDecoration(
                                hintText: "Search here",
                                border: InputBorder.none
                              ),
                            ),
                          ),
                          const Icon(CupertinoIcons.search)
                        ]),
                  )),
            ),ListItem(newsList: newsList, scrollController: scrollController)]),
        ));
    //   child: Column(
    //     children: [Container(
    //       decoration: const BoxDecoration(
    //           color: Color(0XFFCED3DC),
    //           borderRadius: BorderRadius.all(Radius.circular(8))),
    //       height: 50,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //              Expanded(
    //                 child: TextFormField(
    //                   onFieldSubmitted: (value) {
    //                     // search api
    //                     if (value.isNotEmpty) {
    //                       _searchNews(value, false);
    //                     }
    //                   },
    //                   decoration: const InputDecoration(
    //                       hintText: "Search Here", border: InputBorder.none),
    //                 ),
    //               ),
    //              const Icon(CupertinoIcons.search)
    //           ]),
    //         ),
    //   Expanded(
    //       child: ListItem(
    //           newsList: newsList, scrollController: scrollController))
    //   ]),
    // ));
  }
}

class ListItem extends StatelessWidget {
  final List<NewsItem> newsList;
  final ScrollController scrollController;

  ListItem({required this.newsList, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: newsList.length,
          itemBuilder: (context, position) {
            final ele = newsList[position];
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(newsItem: ele)));
              },
              child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Card(
                          elevation: 2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("${ele.source?.name}",
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.italic)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text("${ele.title}",
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w300)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text("${ele.publishedAt}",
                                              style: const TextStyle(
                                                  fontFamily: 'Lato'))
                                        ],
                                      ))),
                              Expanded(
                                  flex: 3,
                                  child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                            Image.network("${ele.urlToImage}"),
                                      )))
                            ],
                          )))),
            );
          }),
    );
  }
}
