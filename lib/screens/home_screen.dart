import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/NewsModel.dart';
import 'package:news_app/screens/NewsSourcesBottomSheet.dart';
import 'package:news_app/screens/country_bottomsheet.dart';
import 'package:news_app/screens/news_details.dart';
import 'package:news_app/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoaded = false;
  int currentPage = 0;
  String country = "India";
  String countryCode = "in";
  int currentSize = 0;
  int totalSize = 0;
  String sortBy = "popularity";
  late int totalPage;
  List<String> sourcesList = [];
  Map<String, String> countryMap = <String, String>{
    "India": "in",
    "United Arab Emirates": "ar",
    "Argentina": "at",
    "Austria": "au",
    "Australia": "au",
    "Belgium": "be"
  };
  Map<String, String> sourcesMap = <String, String>{
    "ABC News": "abc-news",
    "BBC News": "",
    "Al Jazeera English": "al-jazeera-english",
    "Associated Press": "associated-press",
    "Bloomberg": "bloomberg",
    "Buzzfeed": "buzzfeed"
  };
  List<NewsItem> list = [];
  final _apiKey = "df9430a94fae4b218d7c7c78f470e01b";

  selectCountry(String country) {
    this.country = country;
    Navigator.pop(context);
    var code = countryMap[country];
    if (code != null) {
      list.clear();
      countryCode = code;
      sourcesList = [];
      totalSize = 0;
      currentPage = 0;
      _loadTopHeadines();
    }
  }

  selectSources(List<String> sources) {
    Navigator.pop(context);
    if (sources.isNotEmpty) {
      list.clear();
      sourcesList = sources;
      totalSize = 0;
      currentPage = 0;
      _loadTopHeadines();
    }
  }

  Future<bool> _loadTopHeadines() async {
    if (totalSize != 0 && currentSize == totalSize) {
      isLoaded = true;
      return true;
    } else {
      currentPage++;
    }
    var url = "";
    if (sourcesList.isEmpty) {
      url =
          "https://newsapi.org/v2/top-headlines?country=$countryCode&page=$currentPage&apiKey=$_apiKey&sortBy=$sortBy";
    } else {
      List<String> sourcesCode = [];
      var sources = "";
      sourcesList.forEach((element) {
        sourcesCode.add("${sourcesMap[element]}");
      });
      if (sourcesCode.length == 1) {
        sources = sourcesCode[0];
      } else {
        sources = sourcesCode.join(',');
      }
      url =
          "https://newsapi.org/v2/top-headlines?sources=$sources&page=$currentPage&apiKey=$_apiKey&sortBy=$sortBy";
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final newsModel = NewsModel.fromJson(json);
      list.addAll(newsModel.articles);
      currentSize = list.length;
      totalSize = newsModel.totalResults;
      isLoaded = true;
      setState(() {});
      return true;
    } else {
      isLoaded = true;
      throw Exception("Failed to load data");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTopHeadines();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          isLoaded &&
          currentSize != totalSize) {
        isLoaded = false;
        setState(() {});
        _loadTopHeadines();
      }
    });
  }

  changeSortBy(String category) {
    sortBy = category;
    currentPage = 0;
    totalSize = 0;
    totalPage = 0;
    list.clear();
    _loadTopHeadines();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return NewsSourcesBottomSheet(
                      selectedNewsSources: sourcesList, homeScreenState: this);
                });
          },
          child: const ImageIcon(AssetImage("assets/image/filter_icon.png")),
          backgroundColor: const Color(0xff0c54be),
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xff0c54be),
          title: const Text(
            "MyNEWS",
            style: TextStyle(fontFamily: 'Roboto'),
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.all(4),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return CountryBottomSheet(
                              selectedCountry: country, homeScreenState: this);
                        });
                  },
                  child: Column(
                    children: [
                      const Text(
                        "Location",
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      Row(children: [
                        const Icon(CupertinoIcons.location),
                        Text(
                          country,
                          style: const TextStyle(fontFamily: 'Poppins'),
                        )
                      ])
                    ],
                  ),
                ))
          ],
        ),
        body: Container(
          color: const Color(0xFFF5F9FD),
          child: (isLoaded)?Column(children: [
            SearchBox(),
            TopHeadLinesWidgets(homeScreenState: this, sortCat: sortBy),
            ListItem(newsList: list, scrollController: _scrollController),
            Container(
                height: (currentPage == 0 || isLoaded) ? 0 : 30,
                child: CircularProgressIndicator())
          ]):Center(child: CircularProgressIndicator()),
        ));
  }
}

class TopHeadLinesWidgets extends StatelessWidget {
  final HomeScreenState homeScreenState;
  final String sortCat;

  TopHeadLinesWidgets({required this.homeScreenState, required this.sortCat});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(12),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            "Top Headlines",
            style: TextStyle(fontFamily: 'Lato'),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  onTap: () {
                    homeScreenState.changeSortBy("popularity");
                  },
                  child: const Text("Popularity")),
              PopupMenuItem(
                  onTap: () {
                    homeScreenState.changeSortBy("publishedAt");
                  },
                  child: const Text("Published At"))
            ],
            child: Row(children: [
              const Text(
                "Sort",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 4),
              Text(this.sortCat),
              const ImageIcon(
                  AssetImage("assets/image/icons8-sort-down-48.png"))
            ]),
          )
        ]));
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SearchPage()));
          },
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
                    children: const [
                      Text("Search Here"),
                      Icon(CupertinoIcons.search)
                    ]),
              )),
        ));
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
