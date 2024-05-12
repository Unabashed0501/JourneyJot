import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:my_tourist_app/Components/attraction_card.dart';
import 'package:my_tourist_app/Model/cart_model.dart';
import 'package:my_tourist_app/Redux/actions.dart';
import 'package:redux/redux.dart';

class AttractionsPage extends StatefulWidget {
  final List<String> likes;
  final String itineraryName;
  final int numberOfDays;
  const AttractionsPage(
      {super.key,
      required this.likes,
      required this.itineraryName,
      required this.numberOfDays});
  static String id = 'attractions_page';
  @override
  _AttractionsPageState createState() => _AttractionsPageState();
}

class _AttractionsPageState extends State<AttractionsPage> {
  List<dynamic> attractions = [];
  List<dynamic> filteredAttractions = [];
  TextEditingController searchController = TextEditingController();
  late final Store<List<Map<String, dynamic>>> store;

  @override
  void initState() {
    super.initState();
    // store = ReduxSetup.store;
    fetchAttractions();
  }

  void filterAttractions(String query) {
    setState(() {
      filteredAttractions = attractions
          .where((attraction) => attraction['Name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchAttractions() async {
    // try {
    final response = await http.get(
      Uri.parse(
          'https://data.moa.gov.tw/Service/OpenData/ODwsv/ODwsvTravelStayEn.aspx'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        'Content-Type': 'text/plain; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        attractions = jsonDecode(response.body);
        filteredAttractions = attractions;
      });
    } else {
      throw Exception('Failed to load attractions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourist Attractions'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                filterAttractions(value);
              },
            ),
          ),
          Expanded(
            child: attractions.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : StoreConnector<List<CartModel>, ViewModel>(
                    converter: (store) => ViewModel.create(store),
                    builder: (context, model) {
                      return ListView.builder(
                        itemCount: filteredAttractions.length,
                        itemBuilder: (context, index) {
                          final attraction = filteredAttractions[index];
                          return AttractionCard(
                            attraction: attraction,
                            likes: widget.likes,
                            itineraryName: widget.itineraryName,
                            numberOfDays: widget.numberOfDays,
                          );
                        },
                      );
                    },
                  ),
          ),
          // Expanded(
          //   child: attractions.isEmpty
          //       ? Center(
          //           child: CircularProgressIndicator(),
          //         )
          //       : Consumer<CartModel>(builder: (context, value, child) {
          //           return ListView.builder(
          //             itemCount: filteredAttractions.length,
          //             itemBuilder: (context, index) {
          //               final attraction = filteredAttractions[index];
          //               return AttractionCard(
          //                 attraction: attraction,
          //                 likes: widget.likes,
          //                 itineraryName: widget.itineraryName,
          //                 numberOfDays: widget.numberOfDays,
          //               );
          //             },
          //           );
          //         }),
          // ),
        ],
      ),
    );
  }
}
