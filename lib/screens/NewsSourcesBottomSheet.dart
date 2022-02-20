import 'package:flutter/material.dart';

import 'package:news_app/screens/home_screen.dart' show HomeScreenState;

class NewsSourcesBottomSheet extends StatefulWidget {
  final List<String> selectedNewsSources;
  final HomeScreenState homeScreenState;
  NewsSourcesBottomSheet({required this.selectedNewsSources,required this.homeScreenState});

  @override
  _NewsSourcesBottomSheetState createState() => _NewsSourcesBottomSheetState(selectedNewsSources: selectedNewsSources,homeScreenState: homeScreenState);
}

class _NewsSourcesBottomSheetState extends State<NewsSourcesBottomSheet> {
  final sourcesList = [
    "BBC News",
    "ABC News",
    "Al Jazeera English",
    "Associated Press",
    "Bloomberg",
    "Buzzfeed"
  ];
  List<String> selectedNewsSources;
  HomeScreenState homeScreenState;
  _NewsSourcesBottomSheetState({required this.selectedNewsSources,required this.homeScreenState});

  selectNewsSource(String sources){
    if(!selectedNewsSources.contains(sources)){
      selectedNewsSources.add(sources);
    }
    setState(() {

    });
  }
  unselectNewsSource(String sources){
    if(selectedNewsSources.contains(sources)){
      selectedNewsSources.remove(sources);
    }
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Container(
                height: 4,
                alignment: Alignment.center,
                child: Container(
                  width: 60,
                  color: Color(0xFFd9d9d9),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              child: Text(
                "Filter By News Sources",
                style: TextStyle(fontFamily: 'Lato', fontSize: 15),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Container(
                height: 2,
                color: Color(0xFFd9d9d9),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: sourcesList.length,
                    itemBuilder: (context, pos) {
                      return NewsSourcesItem(
                          newsSourcesBottomSheetState: this,
                          source: sourcesList[pos],
                          selectedNewsSources: selectedNewsSources);
                    })),

            Container(
              height: 40,
              alignment: Alignment.center,
              child:ElevatedButton(
                onPressed: () {
                  homeScreenState.selectSources(selectedNewsSources);
                },
                child: Text("Apply",style: TextStyle(color: Colors.white),),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class NewsSourcesItem extends StatelessWidget {
  final _NewsSourcesBottomSheetState newsSourcesBottomSheetState;
  final String source;
  List<String> selectedNewsSources;
  NewsSourcesItem({required this.newsSourcesBottomSheetState,required this.source,required this.selectedNewsSources}) ;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(source),
      trailing:
      GestureDetector(
        onTap: (){
          print("hELLO");
        },
      child:


         Radio(
          value: source,
          toggleable: true,
          groupValue: selectedNewsSources.contains(source)?source:"",
          onChanged: (String? value) {
if(selectedNewsSources.contains(source)) {
              selectedNewsSources.remove(source);
              newsSourcesBottomSheetState.unselectNewsSource(source);
            }
            else{
              selectedNewsSources.add(source);

              newsSourcesBottomSheetState.selectNewsSource(source);
            }
        },
        ),
      ),
    );
  }

}



