import 'package:flutter/material.dart';

import 'package:news_app/screens/home_screen.dart' show HomeScreenState;

class CountryBottomSheet extends StatefulWidget {
  final String selectedCountry;
  final HomeScreenState homeScreenState;
  CountryBottomSheet({required this.selectedCountry,required this.homeScreenState});

  @override
  _CountryBottomSheetState createState() => _CountryBottomSheetState(selectedCountry: selectedCountry,homeScreenState: homeScreenState);
}

class _CountryBottomSheetState extends State<CountryBottomSheet> {
  final countryList = [
    "India",
    "United Arab Emirates",
    "Argentina",
    "Austria",
    "Australia",
    "Belgium"
  ];
  String selectedCountry="";
  HomeScreenState homeScreenState;
  _CountryBottomSheetState({required this.selectedCountry,required this.homeScreenState});

  changeSelectedCountry(String country){
    selectedCountry=country;
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
                "Choose Your Location",
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
                    itemCount: countryList.length,
                    itemBuilder: (context, pos) {
                      return CountryListItem(
                          countryBottomSheetState: this,
                          country: countryList[pos],
                          selectedCountry: "India");
                    })),

            Container(
              height: 40,
              alignment: Alignment.center,
              child:ElevatedButton(
                onPressed: () {
                     homeScreenState.selectCountry(selectedCountry);
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

class CountryListItem extends StatelessWidget {
  final _CountryBottomSheetState countryBottomSheetState;
  final String country;
  String selectedCountry;
  CountryListItem({required this.countryBottomSheetState,required this.country,required this.selectedCountry}) ;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(country),
      trailing: Radio(
        value: country,
        groupValue: countryBottomSheetState.selectedCountry,
        onChanged: (String? value) {
          if(value!=null){
            countryBottomSheetState.changeSelectedCountry(value);

          }},
      ),
    );
  }

}



